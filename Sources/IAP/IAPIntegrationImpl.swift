//
// Copyright © 2022 mycujoo. All rights reserved.
//

import Foundation
import UIKit
import MLSSDK
import StoreKit


@available(iOS 15.0, *)
class IAPIntegrationImpl: NSObject, IAPIntegration {
    private let entitlementQueue = DispatchQueue(label: "mcls.check_entitlement.retry", qos: .utility)
    /// A dictionary from orderId to DispatchWorkItem (used for entitlement checking)
    private var workItems: [String: DispatchWorkItem] = [:]
    /// A dictionary from orderId to known entitlements
    private var entitlements: [String: Bool] = [:]
    private var transactionListener: Task<Void, Error>? = nil
    
    private var logLevel: Configuration.LogLevel
    
    private let listProductsUseCase: ListProductsUseCase
    private let createOrderUseCase: CreateOrderUseCase
    private let finishTransactionUseCase: FinishTransactionUseCase
    private let checkEntitlementUseCase: CheckEntitlementUseCase
    init(listProductsUseCase: ListProductsUseCase,
         createOrderUseCase: CreateOrderUseCase,
         finishTransactionUseCase: FinishTransactionUseCase,
         checkEntitlementUseCase: CheckEntitlementUseCase,
         logLevel: Configuration.LogLevel) {
        self.listProductsUseCase = listProductsUseCase
        self.createOrderUseCase = createOrderUseCase
        self.finishTransactionUseCase = finishTransactionUseCase
        self.checkEntitlementUseCase = checkEntitlementUseCase
        self.logLevel = logLevel
        super.init()
        
        self.transactionListener = listenForTransaction()
    }
    
    deinit {
        transactionListener?.cancel()
        for (_, v) in workItems {
            v.cancel()
        }
        workItems = [:]
    }
}
@available(iOS 15.0, *)
extension IAPIntegrationImpl {

    func listProducts(eventId: String) async throws -> [(packageId: String, product: IAPProduct)] {
        return try await listProductsUseCase.execute(eventId: eventId)
    }
    
    func purchaseProduct(packageId: String, callback: @escaping (PaymentResult) -> ()) {
        Task { [weak self] in
            do {
                guard let `self` = self else { return }
                guard let order = try? await createOrderUseCase.execute(packageId) else {
                    if [.verbose].contains(logLevel) {
                        StoreLog.exception(.orderException, productId: "Unknown. MCLS packageId: " + packageId)
                    }
                    throw StoreException.orderException
                }
                
                guard let appleProductToPurchase = try? await StoreKit.Product.products(for: [order.appleProductId]).first else {
                    if [.verbose, .info].contains(logLevel) {
                        StoreLog.exception(.requestProductException, productId: order.appleProductId)
                    }
                    throw StoreException.requestProductException
                }
                
                guard let uuid = UUID(uuidString: order.appleAppAccountToken), let purchaseResult = try? await appleProductToPurchase.purchase(options: [.appAccountToken(uuid)]) else {
                    if [.verbose, .info].contains(logLevel) {
                        StoreLog.exception(.purchaseException, productId: appleProductToPurchase.id)
                    }
                    throw StoreException.purchaseException
                }
                
                switch purchaseResult {
                case .success(let verification):
                    let transactionResult = try await self.handleTransactionResult(verification, order: order)
                    callback(transactionResult ? .success : .failure(StoreException.finishPurchaseException))
                case .userCancelled:
                    callback(.failure(.userCancelled))
                case .pending:
                    callback(.pending)
                @unknown default:
                    throw StoreException.unhandledEventException
                }
            } catch let err as StoreException {
                callback(.failure(err))
            }
        }
    }
    
    private func listenForTransaction() -> Task<Void, Error> {
        return Task.detached { [weak self] in
            //Iterate through any transactions which didn't come from a direct call to `purchase()`
            for await verificationResult in Transaction.updates {
                _ = try? await self?.handleTransactionResult(verificationResult)
            }
        }
    }
    
    /// - parameter verificationResult: The result containing the Transaction
    /// - parameter orderId: The order to which the Transaction is intended to belong
    /// - returns: A boolean indicating whether the transaction was processed successfully AND it belongs to the product being purchased.
    ///   This returns `false` if this transaction mismatches the appleProductId being passed, or the transaction has since expired.
    private func handleTransactionResult(_ verificationResult: VerificationResult<Transaction>, order: Order? = nil) async throws -> Bool {
        let result = self.checkVerificationResult(result: verificationResult)
        
        if !result.verified {
            if [.verbose, .info].contains(logLevel) {
                StoreLog.transaction(.transactionValidationFailure, productId: result.transaction.productID)
            }
            
            // Do not finish the transaction, because we have not delivered on this transaction yet.
            throw StoreException.transactionVerificationFailed
        }
        
        let localStorageKey = "mcls_iap_transaction_finished_\(result.transaction.id)"
        if UserDefaults.standard.bool(forKey: localStorageKey) == false {
            // Since Apple does not clear transactions from Transaction.updates even after .finish() is called,
            // We need to check whether transaction was handled previously, and only act on unfinished ones.
            #if DEBUG
            print("jwsRepresentation")
            print(verificationResult.jwsRepresentation)
            #endif
            
            guard (try? await finishTransactionUseCase.execute(verificationResult.jwsRepresentation)) != nil else {
                if [.verbose, .info].contains(logLevel) {
                    StoreLog.transaction(.jwsVerificationFailed, productId: result.transaction.productID)
                }
                // Do not finish the transaction, because we have not delivered on this transaction yet.
                throw StoreException.finishTransactionException
            }

            await result.transaction.finish()
            
            UserDefaults.standard.set(true, forKey: localStorageKey)
        }

        if let order = order {
            return await withCheckedContinuation { [weak self] continuation in
                self?.checkEntitlement(order: order) { isFinished in
                    continuation.resume(returning: isFinished)
                }
            }
        } else {
            // The order is not available when the payment is being processed asynchronously, in which case this function optimistically assumes success.
            return true
        }
    }
    
    /// - parameter attempt: The nth amount of time this function is being retried. Leave this to 1 upon the initial call.
    /// - parameter callback: A closure that gets called with `true` only when get the response there is an entitlement belonging to this Order.
    private func checkEntitlement(order: Order, attempt: Int = 1, callback: @escaping (Bool) -> Void) {
        Task { [weak self] in
            guard let `self` = self else { return }
            let result = await checkEntitlementUseCase.execute(contentType: order.contentReference.type, contentId: order.contentReference.id)
            switch result {
            case .failure(_):
                if attempt > 10 {
                    if [.verbose].contains(logLevel) {
                        print("Calling checkEntitlement failed! Reached max retry attempts.")
                    }
                    
                    self.workItems[order.id]?.cancel()
                    self.entitlements[order.id] = false
                    callback(false)
                }
                
                if [.verbose].contains(logLevel) {
                    print("Calling checkEntitlement failed! retrying...")
                }
                
                self.workItems[order.id]?.cancel()
                let workItem = DispatchWorkItem() { [weak self] in
                    guard let `self` = self else { return }
                    if let hasEntitlement = self.entitlements[order.id], hasEntitlement {
                        // Do not call callback() here, because we can assume it's already been called previously,
                        // and it should only be called once.
                        return
                    }
                    self.checkEntitlement(order: order, attempt: attempt + 1, callback: callback)
                }
                
                self.workItems[order.id] = workItem
                self.entitlementQueue.asyncAfter(deadline: .now() + Double(DelayOptions.exponential(initial: 2, multiplier: 2, maxDelay: 60).make(attempt)), execute: workItem)
            case .success(_):
                if [.verbose].contains(logLevel) {
                    print("Calling checkEntitlement succeed! Returning result.")
                }
                self.workItems[order.id]?.cancel()
                self.entitlements[order.id] = true
                callback(true)
            }
        }
    }
    
    /// Check if StoreKit was able to automatically verify a transaction by inspecting the verification result.
    ///
    /// - Parameter result: The transaction VerificationResult to check.
    /// - Returns: Returns an `UnwrappedVerificationResult<T>` where `verified` is true if the transaction was
    /// successfully verified by StoreKit. When `verified` is false `verificationError` will be non-nil.
    private func checkVerificationResult<T>(result: VerificationResult<T>) -> UnwrappedVerificationResult<T> {
        switch result {
            case .unverified(let unverifiedTransaction, let error):
                // StoreKit failed to automatically validate the transaction
                return UnwrappedVerificationResult(transaction: unverifiedTransaction, verified: false, verificationError: error)
                
            case .verified(let verifiedTransaction):
                // StoreKit successfully automatically validated the transaction
                return UnwrappedVerificationResult(transaction: verifiedTransaction, verified: true, verificationError: nil)
        }
    }
}

@available(iOS 15.0, *)
public struct UnwrappedVerificationResult<T> {
    /// The verified or unverified transaction.
    let transaction: T
    
    /// True if the transaction was successfully verified by StoreKit.
    let verified: Bool
    
    /// If `verified` is false then `verificationError` will hold the verification error, nil otherwise.
    let verificationError: VerificationResult<T>.VerificationError?
}
