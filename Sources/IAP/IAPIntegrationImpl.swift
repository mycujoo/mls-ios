//
// Copyright © 2022 mycujoo. All rights reserved.
//

import Foundation
import UIKit
import MLSSDK
import StoreKit


@available(iOS 15.0, *)
class IAPIntegrationImpl: NSObject, IAPIntegration {
    
    private var transactionListener: Task<Void, Error>? = nil
    
    private var logLevel: Configuration.LogLevel
    
    private let listProductsUseCase: ListProductsUseCase
    private let createOrderUseCase: CreateOrderUseCase
    private let finishTransactionUseCase: FinishTransactionUseCase
    
    init(listProductsUseCase: ListProductsUseCase,
         createOrderUseCase: CreateOrderUseCase,
         finishTransactionUseCase: FinishTransactionUseCase,
         logLevel: Configuration.LogLevel) {
        self.listProductsUseCase = listProductsUseCase
        self.createOrderUseCase = createOrderUseCase
        self.finishTransactionUseCase = finishTransactionUseCase
        self.logLevel = logLevel
        super.init()
    }
    
    deinit {
        transactionListener?.cancel()
    }
}
@available(iOS 15.0, *)
extension IAPIntegrationImpl {

    func listProducts(eventId: String) async throws -> [(packageId: String, product: IAPProduct)] {
        return try await listProductsUseCase.execute(eventId: eventId)
    }
    
    func purchaseProduct(packageId: String) async throws -> PaymentResult {
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
            _ = try await handleTransactionResult(verification, orderId: order.id)
            return .success
        case .userCancelled:
            transactionListener?.cancel()
            return .failure(.userCancelled)
        case .pending:
            return .pending
        @unknown default:
            throw StoreException.unhandledEventException
        }
    }
    
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
    ///   This is important because a transaction might be marked as finished, but it may be for an unrelated product.
    private func handleTransactionResult(_ verificationResult: VerificationResult<Transaction>, orderId: String) async throws -> Bool {
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
        
        guard (try? await finishTransactionUseCase.execute(verificationResult.jwsRepresentation, orderId: orderId)) != nil else {
            if [.verbose, .info].contains(logLevel) {
                StoreLog.transaction(.jwsVerificationFailed, productId: result.transaction.productID)
            }
            await result.transaction.finish()
            throw StoreException.finishTransactionException
        }

        await result.transaction.finish()
        return true
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
