//
// Copyright © 2022 mycujoo. All rights reserved.
//

import Foundation


public protocol MLSPaymentRepository {
    func createOrder(callback: @escaping (Order?, Error?) -> Void)
    func finishTransaction(jwsToken: String)
}
