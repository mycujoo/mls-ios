//
// Copyright © 2022 mycujoo. All rights reserved.
//

import Foundation
import StoreKit


public struct IAPProduct: Identifiable {
    public enum ProductType {
        case consumable
        case nonConsumable
        case nonRenewable
        case autoRenewable
    }
    
    /// The unique product identifier.
    public let id: String

    /// The type of the product.
    public let type: ProductType

    /// A localized display name of the product.
    public let displayName: String

    /// A localized description of the product.
    public let description: String

    /// The price of the product in local currency.
    public let price: Decimal

    /// A localized string representation of `price`.
    public let displayPrice: String

    /// Whether the product is available for family sharing.
    public let isFamilyShareable: Bool

    public init(id: String, type: ProductType, displayName: String, description: String,  price: Decimal, displayPrice: String, isFamilyShareable: Bool) {
        self.id = id
        self.type = type
        self.displayName = displayName
        self.description = description
        self.price = price
        self.displayPrice = displayPrice
        self.isFamilyShareable = isFamilyShareable
    }
}

