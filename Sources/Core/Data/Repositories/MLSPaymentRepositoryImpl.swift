//
// Copyright © 2022 mycujoo. All rights reserved.
//

import Foundation
import Moya


class MLSPaymentRepositoryImpl: BaseRepositoryImpl, MLSPaymentRepository {
    
    override init(api: MoyaProvider<API>) {
        super.init(api: api)
    }
    
    @available(iOS 13.0, *)
    func listProducts(eventId: String) async throws -> EventPackages {
        return try await withCheckedThrowingContinuation { continuation in
            _fetch(.listEventProducts(eventId: eventId), type: EventPackages.self) { eventPackages, error in
                if let error = error {
                    
                    continuation.resume(throwing: error)
                } else {
                    guard let eventPackages = eventPackages else {
                        continuation.resume(throwing: StoreError.productError)
                        return
                    }
                    continuation.resume(returning: eventPackages)
                }
            }
        }
        
    }
    
    @available(iOS 13.0.0, *)
    func createOrder(packageId: String) async throws -> Order {
        return try await withCheckedThrowingContinuation { continuation in
            _mutate(.createOrder(packageId: packageId), type: Order.self) { order, error in
                if let error = error {
                    continuation.resume(throwing: error)
                } else {
                    guard let order = order else {
                        return continuation.resume(throwing: StoreError.orderError)
                    }
                    continuation.resume(returning: order)
                }
            }
        }
    }
    
    @available(iOS 13.0.0, *)
    func finishTransaction(jwsToken: String, orderId: String) async throws -> PaymentVerification {
        return try await withCheckedThrowingContinuation { continuation in
            _mutate(.paymentVerification(jws: jwsToken, orderId: orderId), type: PaymentVerification.self) { result, error in
                if let error = error {
                    continuation.resume(throwing: error)
                } else {
                    guard let result = result else {
                        continuation.resume(throwing: StoreError.failedVerification)
                        return
                    }
                    continuation.resume(returning: result)
                }
            }
        }
    }
}

