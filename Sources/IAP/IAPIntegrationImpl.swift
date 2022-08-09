//
// Copyright © 2022 mycujoo. All rights reserved.
//

import Foundation
import UIKit
import MLSSDK
import StoreKit



class IAPIntegratoinImpl: NSObject, IAPIntegration {
    
    private var _updateListenerTask: Any? = nil
    private var paymentRepository: MLSPaymentRepository
    private var orderId: String = ""
    @available(iOS 15.0, *)
    private var updateListenerTask: Task<Void, Error>? {
        if _updateListenerTask == nil {
            _updateListenerTask = Task<Void, Error>?.self
        }
        return _updateListenerTask as! Task<Void, Error>?
    }
    
    
    init(paymentRepository: MLSPaymentRepository) {
        self.paymentRepository = paymentRepository
        super.init()
        if #available(iOS 15.0, *) {
            _updateListenerTask = listenForTransaction()
        }
    }
    
    deinit {
        if #available(iOS 15.0, *) {
            (_updateListenerTask as! Task<Void, Error>).cancel()
        } else {
            // Fallback on earlier versions
            _updateListenerTask = nil
        }
        orderId = ""
    }
    
    
}
@available(iOS 15.0, *)
extension IAPIntegratoinImpl {

    func listProducts(_ eventId: String) async throws -> [IAPProduct] {
        //TODO: Impl getting productIds for the `event` from server
        let productIds = ["testsub29YzWXKPMi6yBF63tRoCasuCu6Q"]
        return try await Product.products(for: productIds).map { $0.toDomain }
    }
    
    func purchaseProduct(productId: String) async -> PaymentResult {
        do {
            let order = try await paymentRepository.createOrder(packageId: productId)
            if let appleProductToPurchase = try await StoreKit.Product.products(for: [order.appleProductId]).first {
                let purchaseResult = try await appleProductToPurchase.purchase(options: [.appAccountToken(UUID(uuidString: order.appleAppAccountToken)!) ])
                switch purchaseResult {
                case .success(let verification):
                    let transaction = try self.verifyTransaction(verification)
                    self.orderId = order.id
                    let jwsverification = try await self.paymentRepository.finishTransaction(jwsToken: verification.jwsRepresentation, orderId: order.id)
                    if jwsverification.id.isEmpty {
                        return .failure(.productError)
                    }
                    await transaction.finish()
                    return .success
                case .userCancelled:
                    return .failure(.userCancelled)
                case .pending:
                    return .pending
                @unknown default:
                    return .failure(.unknownError)
                }
            } else {
                return .failure(.productError)
            }
        } catch {
            return (.failure(.orderError))
        }
    }
    
    private func listenForTransaction() -> Task<Void, Error> {
        return Task.detached {
            //Iterate through any transactions which didn't come from a direct call to `purchase()`
            for await result in Transaction.updates {
                do {
                    let transaction = try self.verifyTransaction(result)
                                        
                    // finish transaction
                    await transaction.finish()
                    
                } catch {
                    //StoreKit has a receipt it can read but it failed verification. Don't deliver content to the user.
                    print("Transaction failed verification")
                }
            }
        }
    }
    
    
    private func verifyTransaction<T>(_ result: VerificationResult<T>) throws -> T {
        //Check if the transaction passes StoreKit verification.
        switch result {
        case .unverified:
            //StoreKit has parsed the JWS but failed verification. Don't deliver content to the user.
            throw StoreError.failedVerification
        case .verified(let safe):
            //If the transaction is verified, unwrap and return it.
            return safe
        }
    }
    
}
