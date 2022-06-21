//
// Copyright © 2022 mycujoo. All rights reserved.
//

import Foundation
import Moya


class MLSPaymentRepositoryImpl: BaseRepositoryImpl, MLSPaymentRepository {
    override init(api: MoyaProvider<API>) {
        super.init(api: api)
    }
    
    func createOrder(callback: @escaping (Order?, Error?) -> Void) {
        _fetch(.createOrder, type: Order.self) { order, error in
            callback(order, error)
        }
    }
    
    func finishTransaction(jwsToken: String) {
        //TODO: Impl the API here
    }
}

