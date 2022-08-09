//
// Copyright © 2022 mycujoo. All rights reserved.
//

import Foundation
import Moya


class MLSPaymentRepositoryImpl: BaseRepositoryImpl, MLSPaymentRepository {
    override init(api: MoyaProvider<API>) {
        super.init(api: api)
    }
    
    @available(iOS 13.0.0, *)
    func createOrder(packageId: String) async throws -> Order {
        return try await withCheckedThrowingContinuation { continuation in
            _fetch(.createOrder(packageId: packageId), type: Order.self) { order, error in
                if let error = error {
                    continuation.resume(throwing: error)
                } else {
                    guard let order = order else {
                        fatalError("Expected non-nil result 'order' in the non-error case")
                    }
                    continuation.resume(returning: order)
                }
            }
        }
    }
    
    @available(iOS 13.0.0, *)
    func finishTransaction(jwsToken: String, orderId: String) async throws -> PaymentVerification {
        return try await withCheckedThrowingContinuation { continuation in
            _fetch(.paymentVerification(jws: jwsToken, orderId: orderId), type: PaymentVerification.self) { result, error in
                if let error = error {
                    continuation.resume(throwing: error)
                } else {
                    guard let result = result else {
                        fatalError("Expected non-nil result")
                    }
                    continuation.resume(returning: result)

                }
            }
        }
    }
}

