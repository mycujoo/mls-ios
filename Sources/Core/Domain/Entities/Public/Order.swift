//
// Copyright © 2022 mycujoo. All rights reserved.
//

import Foundation

public struct Order: Decodable {
    
    var id: String
    var productName: String
    var productDesc: String
    var identityId: String
    var googlePlayAmount: String
    var googleSKU: String
    var appleProductId: String
    var redirectUrl: String
    var promoCode: String
    var googlePlayFinalAmount: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case productName = "product_name"
        case productDesc = "product_description"
        case identityId = "identity_id"
        case googlePlayAmount = "amount"
        case googleSKU = "google_play_sku"
        case appleProductId = "apple_app_store_product_id"
        case redirectUrl = "redirect_url"
        case promoCode = "promo_code"
        case googlePlayFinalAmount = "final_amount"
        
    }
}
