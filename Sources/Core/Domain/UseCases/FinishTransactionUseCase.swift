//
// Copyright © 2022 mycujoo. All rights reserved.
//

import Foundation
import Moya



class FinishTransactionUseCase: BaseRepositoryImpl {
    override init(api: MoyaProvider<API>) {
        super.init(api: api)
    }
    
    @available(iOS 13.0.0, *)
    func execute(jwsToken: String, orderId: String) async throws -> PaymentVerification {
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

