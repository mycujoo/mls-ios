//
// Copyright © 2022 mycujoo. All rights reserved.
//

import Foundation
import UIKit
import MLSSDK
import StoreKit


@available(iOS 15.0, *)
class IAPIntegrationImpl: NSObject, IAPIntegration {
    
    
    private let queue = DispatchQueue(label: "purcahse.fulfillment.retry")
    private let maxRetry: Int = 6
    private var retryAttempt: Int = .zero
    private var workItem: DispatchWorkItem = DispatchWorkItem(block: { })
    private var purchaseFulfilled: Bool = false
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
    }
    
    deinit {
        transactionListener?.cancel()
        workItem.cancel()
        retryAttempt = .zero
        purchaseFulfilled = false
    }
}
@available(iOS 15.0, *)
extension IAPIntegrationImpl {

    func listProducts(eventId: String) async throws -> [(packageId: String, product: IAPProduct)] {
        return try await listProductsUseCase.execute(eventId: eventId)
    }
    
    func purchaseProduct(packageId: String, callback: @escaping (PaymentResult) -> ()) throws -> Void {
        Task { [weak self] in
            guard let `self` = self else { return }
            guard let order = try? await createOrderUseCase.execute(packageId) else {
                if [.verbose].contains(logLevel) {
                    StoreLog.exception(.orderException, productId: "Unknown. MCLS packageId: " + packageId)
                }
                throw StoreException.orderException
            }
            
            transactionListener?.cancel()
            transactionListener = listenForTransaction(orderId: order.id)
            
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
                let transactionResult = try await handleTransactionResult(verification, order: order)
                callback(transactionResult ? .success : .failure(StoreError.purchaseNotFulfilled))
            case .userCancelled:
                transactionListener?.cancel()
                callback(.failure(.userCancelled))
            case .pending:
                callback(.pending)
            @unknown default:
                throw StoreException.unhandledEventException
            }
        }
    }
    
    /// - parameter completionHandler: A closure that should be called when a Transaction was completed for the relevant Apple product. This can also be triggered from an earlier purchase!
    private func listenForTransaction(orderId: String) -> Task<Void, Error> {
        return Task.detached { [weak self] in
            //Iterate through any transactions which didn't come from a direct call to `purchase()`
            // We don't need this listener, therefore it's empty here and do nothing, to silence Apple's warning.
            for await verificationResult in Transaction.updates {
                guard let result = self?.checkVerificationResult(result: verificationResult) else { return }
                await result.transaction.finish()
            }
        }
    }
    
    /// - parameter verificationResult: The result containing the Transaction
    /// - parameter orderId: The order to which the Transaction is intended to belong
    /// - returns: A boolean indicating whether the transaction was processed successfully AND it belongs to the product being purchased.
    ///   This returns `false` if this transaction mismatches the appleProductId being passed, or the transaction has since expired.
    private func handleTransactionResult(_ verificationResult: VerificationResult<Transaction>, order: Order) async throws -> Bool {
        let result = self.checkVerificationResult(result: verificationResult)
        
        if !result.verified {
            if [.verbose, .info].contains(logLevel) {
                StoreLog.transaction(.transactionValidationFailure, productId: result.transaction.productID)
            }
            await result.transaction.finish()
            throw StoreException.transactionVerificationFailed
        }
        
        #if DEBUG
        print("jwsRepresentation")
        print(verificationResult.jwsRepresentation)
        #endif
        
        guard (try? await finishTransactionUseCase.execute(verificationResult.jwsRepresentation, orderId: order.id)) != nil else {
            if [.verbose, .info].contains(logLevel) {
                StoreLog.transaction(.jwsVerificationFailed, productId: result.transaction.productID)
            }
            await result.transaction.finish()
            throw StoreException.finishTransactionException
        }

        await result.transaction.finish()
        return await withCheckedContinuation { continuation in
            checkPurchaseFulfilment(order: order) { isFinished in
                continuation.resume(returning: isFinished)
            }
        }
        
    }
    
    /// Call the usecase to check purchase fulfillment,
    /// reutrn `true` only when get the response that purchase if fulfilled!
    private func checkPurchaseFulfilment(order: Order, callback: @escaping (Bool) -> Void) {
        
        Task {
            let fulfillmentResult = await checkEntitlementUseCase.execute(order: order)
            switch fulfillmentResult {
            case .failure(_):
                if [.verbose].contains(logLevel) {
                    print("### Calling fulfillment failed! retrying... \(retryAttempt)")
                }
                guard retryAttempt < maxRetry else {
                    callback(false)
                    return
                }
                self.retry(delay: .exponential(initial: 3, multiplier: 2)) { [self] in
                    checkPurchaseFulfilment(order: order, callback: callback)
                }
            case .success(let isFulfilled):
                if [.verbose].contains(logLevel) {
                    print("### Calling fulfillment succeed! Returning result.")
                }
                if isFulfilled {
                    workItem.cancel()
                    purchaseFulfilled = isFulfilled
                    callback(isFulfilled)
                }
            }
        }
    }
    
    /// A retry method with exponential back-off policy.
    /// - parameter delay: an option to choose the type of delay
    /// - parameter maxRetry: the maximum times we want this method to retry
    /// - parameter operation: a callback to pass in the action we want to retry
    func retry(delay: DelayOptions, _ operation: @escaping () -> Void) {
        workItem.cancel()
        guard !self.purchaseFulfilled else { return }
        
        workItem = DispatchWorkItem() {
            operation()
        }
        retryAttempt += 1
        queue.asyncAfter(deadline: .now() + Double(delay.make(retryAttempt)), execute: workItem)
        
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
