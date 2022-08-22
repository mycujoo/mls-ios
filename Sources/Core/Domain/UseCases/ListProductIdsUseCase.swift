//
// Copyright © 2022 mycujoo. All rights reserved.
//

import Foundation
import Moya

class ListProductIdsUseCase: BaseRepositoryImpl {
    override init(api: MoyaProvider<API>) {
        super.init(api: api)
    }
    
    @available(iOS 13.0.0, *)
    func execute(eventId: String) async throws -> [String] {
        return try await withCheckedThrowingContinuation { continuation in
            _fetch(.listProductIds(eventId: eventId), type: EventPackages.self) { eventPackages, error in
                if let error = error {
                    continuation.resume(throwing: error)
                } else {
                    guard let eventPackages = eventPackages else {
                        continuation.resume(throwing: StoreError.productError)
                        return
                    }
                    continuation.resume(returning: [eventPackages.appleProductId])
                }
            }
        }
    }
}

