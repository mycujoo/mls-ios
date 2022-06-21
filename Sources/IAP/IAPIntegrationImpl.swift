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
    }
    
    
}
@available(iOS 15.0, *)
extension IAPIntegratoinImpl {

    func listProducts(_ eventId: String, completion: @escaping ([IAPProduct], Error?) -> Void) {
        
        Task {
            completion(try await Product.products(for: ["testsub29YzWXKPMi6yBF63tRoCasuCu6Q"]).map { $0.toDomain }, nil)
        }
    }
    
    func purchaseProduct(_ product: IAPProduct, completion: @escaping (PaymentResult?, Error?) -> Void) {
        
        paymentRepository.createOrder { order, error in
            if order != nil {
                Task { [weak self] in
                    if let appleProduct = try await StoreKit.Product.products(for: [product.id]).first {
                        //Begin a purchase
                        let result = try await appleProduct.purchase()
                        switch result {
                        case .success(let verification):
                            
                            let transaction = try self?.verifyTransaction(verification)
                            
                            self?.paymentRepository.finishTransaction(jwsToken: verification.jwsRepresentation)
                            
                            await transaction?.finish()
                            
                            completion(.success, nil)
                        case .userCancelled:
                            completion(.failure, nil)
                        case .pending:
                            completion(.pending, nil)
                        @unknown default:
                            completion(nil, nil)
                        }
                    }
                    completion(nil, error)
                }
                completion(nil, error)
            }
            
        }
    }
    
    private func listenForTransaction() -> Task<Void, Error> {
        return Task.detached {
            //Iterate through any transactions which didn't come from a direct call to `purchase()`
            for await result in Transaction.updates {
                do {
                    let transaction = try self.verifyTransaction(result)
                    
                    //TODO: send jws
                    
                    self.paymentRepository.finishTransaction(jwsToken: result.jwsRepresentation)
                    
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
