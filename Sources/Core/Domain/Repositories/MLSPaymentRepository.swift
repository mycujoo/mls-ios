//
// Copyright © 2022 mycujoo. All rights reserved.
//

import Foundation


public protocol MLSPaymentRepository {
    @available(iOS 13.0.0, *)
    func listPackages(eventId: String) async throws -> EventPackages
    @available(iOS 13.0.0, *)
    func createOrder(packageId: String) async throws -> Order
    @available(iOS 13.0.0, *)
    func finishTransaction(jwsToken: String, orderId: String) async throws -> PaymentVerification
}
