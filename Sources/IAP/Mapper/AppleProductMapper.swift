//
// Copyright © 2022 mycujoo. All rights reserved.
//

import Foundation
import StoreKit
import MLSSDK

@available(iOS 15.0, *)
public extension StoreKit.Product {
    var toDomain: IAPProduct {
        var type: IAPProduct.ProductType {
            switch self.type {
            case .consumable: return .consumable
            case .nonConsumable: return .nonConsumable
            case .autoRenewable: return .autoRenewable
            case .nonRenewable: return .nonRenewable
            default:
                return .consumable
            }
        }
        
        return IAPProduct(id: self.id, type: type, displayName: self.displayName, description: self.description, price: self.price, displayPrice: self.displayPrice, isFamilyShareable: self.isFamilyShareable)
        
    }
}
