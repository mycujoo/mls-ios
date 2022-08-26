//
// Copyright © 2022 mycujoo. All rights reserved.
//

import Foundation



public protocol IAPIntegration: AnyObject {
    @available(iOS 15.0, *)
    /// - Parameters:
    ///   - eventId: The id of the MCLS event to retrieve the Products (Subscriptions) that this MCLS event is a part of.
    func listProducts(eventId: String) async throws -> [(packageId: String, product: IAPProduct)]

    @available(iOS 15.0, *)
    /// - Parameters:
    /// - packageId: The packageId that comes from the `listProducts` method.
    /// - Note: This is the MCLS identifier for this package; not to be confused with Apple's product ID.
    func purchaseProduct(packageId: String) async throws -> PaymentResult
}
