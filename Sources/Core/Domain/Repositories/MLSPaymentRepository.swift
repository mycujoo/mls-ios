//
// Copyright © 2022 mycujoo. All rights reserved.
//

import Foundation


public protocol MLSPaymentRepository {
    @available(tvOS 13.0, *)
    @available(iOS 13.0.0, *)
    func listPackages(eventId: String) async throws -> EventPackages
    @available(tvOS 13.0, *)
    @available(iOS 13.0.0, *)
    func createOrder(packageId: String) async throws -> Order
    @available(tvOS 13.0, *)
    @available(iOS 13.0.0, *)
    func finishTransaction(jwsToken: String) async throws -> PaymentVerification
    @available(tvOS 13.0, *)
    @available(iOS 13.0, *)
    func checkEntitlement(contentType: String, contentId: String) async throws -> Bool
}
