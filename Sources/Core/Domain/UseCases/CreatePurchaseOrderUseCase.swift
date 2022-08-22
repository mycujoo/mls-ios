//
// Copyright © 2022 mycujoo. All rights reserved.
//

import Foundation
import Moya

class CreatePurchaseOrderUseCase: BaseRepositoryImpl {
    override init(api: MoyaProvider<API>) {
        super.init(api: api)
    }
    
    @available(iOS 13.0.0, *)
    func execute(packageId: String) async throws -> Order {
        return try await withCheckedThrowingContinuation { continuation in
            _mutate(.createOrder(packageId: packageId), type: Order.self) { order, error in
                if let error = error {
                    continuation.resume(throwing: error)
                } else {
                    guard let order = order else {
                        continuation.resume(throwing: StoreError.orderError)
                        return
                    }
                    continuation.resume(returning: order)
                }
            }
        }
    }
}
