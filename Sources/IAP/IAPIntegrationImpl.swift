//
// Copyright © 2022 mycujoo. All rights reserved.
//

import Foundation
import UIKit
import MLSSDK
import StoreKit


@available(iOS 15.0, *)
class IAPIntegrationImpl: NSObject, IAPIntegration {
    
    private var transactionListeners: [String: Task<Void, Error>] = [:]
    
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
        for (_, listener) in transactionListeners {
            listener.cancel()
        }
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
        
        transactionListeners[order.appleAppAccountToken]?.cancel()
        let transactionListener = listenForTransaction(orderId: order.id, appAccountToken: order.appleAppAccountToken, appleProductId: order.appleProductId)
        transactionListeners[order.appleAppAccountToken] = transactionListener
        
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
            try await handleTransactionResult(verification, orderId: order.id, appAccountToken: order.appleAppAccountToken, appleProductId: order.appleProductId)
            return .success
        case .userCancelled:
            transactionListeners[order.appleAppAccountToken]?.cancel()
            return .failure(.userCancelled)
        case .pending:
            return .pending
        @unknown default:
            throw StoreException.unhandledEventException
        }
    }
    
    private func listenForTransaction(orderId: String, appAccountToken: String, appleProductId: String) -> Task<Void, Error> {
        return Task.detached { [weak self] in
            //Iterate through any transactions which didn't come from a direct call to `purchase()`
            for await verificationResult in Transaction.updates {
                if let success = try await self?.handleTransactionResult(verificationResult, orderId: orderId, appAccountToken: appAccountToken, appleProductId: appleProductId), success {
                    // TODO: Trigger some callback to indicate that a Transaction was handled for the appleProductId we are interested in.
                    // Note that this can also have happened in an earlier purchase attempt of the user. Apple does not trigger a new Transaction
                    // if an existing one already covers a non-consumable product.
                }
            }
        }
    }
    
    /// - parameter verificationResult: The result containing the Transaction
    /// - parameter orderId: The order to which the Transaction is intended to belong
    /// - parameter appAccountToken: The appAccountToken to which the Transaction is intended to belong.
    ///   This can be used to match against an appAccountToken already stored on a Transaction, to make sure we do not use an unrelated Transaction to confirm this order with.
    /// - parameter appleProductId: The Apple product ID being purchased.
    ///   Similar to appAccountToken, this is used to determine whether the Transaction being handled is relevant to what is currently being purchased by the user
    ///   (as there may be unrelated Transactions being triggered by the listener).
    /// - returns: A boolean indicating whether the transaction was processed successfully AND it belongs to the product being purchased.
    ///   This is important because a transaction might be marked as finished, but it may be for an unrelated product.
    private func handleTransactionResult(_ verificationResult: VerificationResult<Transaction>, orderId: String, appAccountToken: String, appleProductId: String) async throws -> Bool {
        let result = self.checkVerificationResult(result: verificationResult)
        
        guard let transactionAppAccountToken = result.transaction.appAccountToken?.uuidString,
              transactionAppAccountToken.lowercased() == appAccountToken.lowercased() else {
            // The issue here is if a purchase was already done in a previous iteration recently,
            // but then the process got closed prematurely.
            // The appAccountToken (and orderId) will be different this time around, but the transaction's
            // productID will be the same. So Apple will not create a new Transaction because it recognizes this
            // product was already purchased recently, but we cannot send the server this information because
            // we lost the original orderId.
            // The server should've received this information from Apple already (through webhook), but that means
            // we somehow have to handle this scenario. For now, we close the transaction and assume it was successful.
            await result.transaction.finish()
            return result.transaction.productID == appleProductId
        }
        
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
