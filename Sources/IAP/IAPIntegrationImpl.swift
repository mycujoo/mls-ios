//
// Copyright © 2022 mycujoo. All rights reserved.
//

import Foundation
import UIKit
import MLSSDK
import StoreKit


@available(iOS 15.0, *)
class IAPIntegratoinImpl: NSObject, IAPIntegration {
    
    /// Handle for App Store transactions.
    private var transactionListener: Task<Void, Error>? = nil
    private var paymentRepository: MLSPaymentRepository
    private var orderId: String = ""

    
    init(paymentRepository: MLSPaymentRepository) {
        self.paymentRepository = paymentRepository
        super.init()
        transactionListener = listenForTransaction()
    }
    
    deinit {
        transactionListener?.cancel()
        orderId = ""
    }
    
    
}
@available(iOS 15.0, *)
extension IAPIntegratoinImpl {

    func listProducts(_ eventId: String) async throws -> [IAPProduct] {
        guard let productIdsList = try? await paymentRepository.listProductIds(eventId: eventId) else {
            StoreLog.event(.fetchProductIdsListFailed)
            throw StoreException.fetchProductIdsListException
        }
        
        StoreLog.event(.requestProductsStarted)
        guard let products = try? await Product.products(for: productIdsList) else {
            StoreLog.event(.requestProductsFailure)
            return []
        }
        StoreLog.event(.requestProductsSuccess)
        return products.map { $0.toDomain }
    }
    
    func purchaseProduct(productId: String) async throws -> PaymentResult {
        
        guard let order = try? await paymentRepository.createOrder(packageId: productId) else {
            StoreLog.exception(.orderException, productId: productId)
            throw StoreException.orderException
        }
        StoreLog.event(.orderCreationSuccess)
        
        guard let appleProductsIdToPurchase = try? await StoreKit.Product.products(for: [order.appleProductId]).first else {
            StoreLog.exception(.requestProductException, productId: order.appleProductId)
            throw StoreException.requestProductException
        }
        StoreLog.event(.requestProductToPurchaseSuccess)
        
        guard let purchaseResult = try? await appleProductsIdToPurchase.purchase(options: [.appAccountToken(UUID(uuidString: order.appleAppAccountToken)!) ]) else {
            StoreLog.exception(.purchaseException, productId: appleProductsIdToPurchase.id)
            throw StoreException.purchaseException
        }
        StoreLog.event(.purchaseInProgress)
        
        switch purchaseResult {
        case .success(let verification):
            StoreLog.event(.purchaseSuccess)
            let result = checkVerificationResult(result: verification)
            StoreLog.transaction(.transactionReceived, productId: result.transaction.productID)
            if !result.verified {
                StoreLog.transaction(.transactionValidationFailure, productId: result.transaction.productID)
                throw StoreException.transactionVerificationFailed
            }
            StoreLog.event(.transactionValidationSuccess)
            
            let success = try? await verifyJWS(verification)
            if let success = success, success {
                StoreLog.transaction(.jwsVerificationSuccess, productId: result.transaction.productID)
                return .success
            }
            
            await result.transaction.finish()
            return .success
            
        case .userCancelled:
            StoreLog.event(.purchaseCancelled)
            transactionListener?.cancel()
            return .failure(.userCancelled)
        case .pending:
            StoreLog.event(.purchasePending)
            return .pending
        @unknown default:
            fatalError("Unhandle situation happened")
        }
    }
    
    private func listenForTransaction() -> Task<Void, Error> {
        return Task.detached { [self] in
            //Iterate through any transactions which didn't come from a direct call to `purchase()`
            for await verificationResult in Transaction.updates {
                let result = self.checkVerificationResult(result: verificationResult)
                StoreLog.transaction(.transactionReceived, productId: result.transaction.productID)
                
                if !result.verified {
                    StoreLog.transaction(.transactionValidationFailure, productId: result.transaction.productID)
                    throw StoreException.transactionVerificationFailed
                }
                StoreLog.event(.transactionValidationSuccess)
                
                let success = try? await verifyJWS(verificationResult)
                if let success = success, success {
                    StoreLog.transaction(.jwsVerificationSuccess, productId: result.transaction.productID)
                }

                await result.transaction.finish()
            }
        }
    }
    
    private func verifyJWS(_ verification: VerificationResult<Transaction>) async throws -> Bool {
        guard let jwsVerification = try? await paymentRepository.finishTransaction(jwsToken: verification.jwsRepresentation, orderId: self.orderId), jwsVerification.id.isEmpty else {
            StoreLog.event(.jwsVerificationFailed)
            throw StoreException.jwsVerificationException
        }
        StoreLog.event(.jwsVerificationSuccess)
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
