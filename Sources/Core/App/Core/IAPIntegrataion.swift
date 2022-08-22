//
// Copyright © 2022 mycujoo. All rights reserved.
//

import Foundation



public protocol IAPIntegration: AnyObject {

    
    @available(iOS 15.0, *)
    func listProducts(_ eventId: String) async throws -> [IAPProduct]

    @available(iOS 15.0, *)
    func purchaseProduct(productId: String) async throws -> PaymentResult
}
