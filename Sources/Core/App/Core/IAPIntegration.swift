//
// Copyright © 2022 mycujoo. All rights reserved.
//

import Foundation



public protocol IAPIntegration: AnyObject {
    @available(iOS 15.0, *)
    /// - parameter eventId: The id of the MCLS event to retrieve the Products (Subscriptions) that this MCLS event is a part of.
    func listProducts(eventId: String) async throws -> [(packageId: String, product: IAPProduct)]

    @available(iOS 15.0, *)
    /// - parameter packageId: The packageId that comes from the `listProducts` method.
    /// - parameter callback: A callback that is called when the status of the Transaction associated with this purchase updates.
    ///   This can be called more than once (e.g. when moving to pending, and then to success.
    ///   It may also be called multiple times with a `success` state (e.g. when both synchronous and asynchronous processing has completed successfully).
    ///   It is up to the implementing developer to handle this gracefully, e.g. by filtering consecutive identical updates.
    /// - Note: This is the MCLS identifier for this package; not to be confused with Apple's product ID.
    func purchaseProduct(packageId: String, callback: @escaping (PaymentResult) -> ()) throws -> Void
}
