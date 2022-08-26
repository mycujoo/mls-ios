//
// Copyright © 2022 mycujoo. All rights reserved.
//

import Foundation



public protocol IAPIntegration: AnyObject {

    
    @available(iOS 15.0, *)
    /// - Parameters:
    ///   - eventId:    The id of the related event to retreive the Products(Subscriptions) based on that id from Apple
    func listProducts(eventId: String) async throws -> [(packageId: String, product: IAPProduct)]

    @available(iOS 15.0, *)
    /// - Parameters:
    /// - productId: The productId of the Product that comes from the `listProducts` method.
    func purchaseProduct(_ productId: String, packageId: String) async throws -> PaymentResult
}
