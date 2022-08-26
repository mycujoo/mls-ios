//
// Copyright © 2022 mycujoo. All rights reserved.
//

import Foundation
import UIKit
import MLSSDK
import StoreKit


@available(iOS 15.0, *)
class IAPIntegrationImpl: NSObject, IAPIntegration {
    
    /// Handle for App Store transactions.
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
    
    func purchaseProduct(_ productId: String, packageId: String) async throws -> PaymentResult {
        guard let order = try? await createOrderUseCase.execute(packageId) else {
            if [.verbose].contains(logLevel) {
                StoreLog.exception(.orderException, productId: productId)
            }
            throw StoreException.orderException
        }
        
        // Only start listening for transaction updates when there is an order created.
        transactionListener?.cancel()
        transactionListener = listenForTransaction(orderId: order.id)
        
        guard let appleProductToPurchase = try? await StoreKit.Product.products(for: [order.appleProductId]).first else {
            if [.verbose, .info].contains(logLevel) {
                StoreLog.exception(.requestProductException, productId: order.appleProductId)
            }
            throw StoreException.requestProductException
        }
        
        guard let purchaseResult = try? await appleProductToPurchase.purchase(options: [.appAccountToken(UUID(uuidString: order.appleAppAccountToken)!) ]) else {
            if [.verbose, .info].contains(logLevel) {
                StoreLog.exception(.purchaseException, productId: appleProductToPurchase.id)
            }
            throw StoreException.purchaseException
        }
        
        switch purchaseResult {
        case .success(let verification):
            try await handleTransactionResult(verification, orderId: order.id)
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
        return Task.detached { [self] in
            //Iterate through any transactions which didn't come from a direct call to `purchase()`
            for await verificationResult in Transaction.updates {
                try await handleTransactionResult(verificationResult, orderId: orderId)
            }
        }
    }
    
    private func handleTransactionResult(_ verificationResult: VerificationResult<Transaction>, orderId: String) async throws -> Void {
        let result = self.checkVerificationResult(result: verificationResult)
        
        if !result.verified {
            if [.verbose, .info].contains(logLevel) {
                StoreLog.transaction(.transactionValidationFailure, productId: result.transaction.productID)
            }
            throw StoreException.transactionVerificationFailed
        }
        
        guard (try? await finishTransactionUseCase.execute(verificationResult.jwsRepresentation, orderId: orderId)) != nil else {
            if [.verbose, .info].contains(logLevel) {
                StoreLog.transaction(.jwsVerificationFailed, productId: result.transaction.productID)
            }
            throw StoreException.finishTransactionException
        }

        await result.transaction.finish()
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
