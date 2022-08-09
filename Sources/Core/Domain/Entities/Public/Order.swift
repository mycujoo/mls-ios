//
// Copyright © 2022 mycujoo. All rights reserved.
//

import Foundation

public struct Order: Decodable {
    
    public var id: String
    var productName: String
    var productDesc: String
    public var appleProductId: String
    public var appleAppAccountToken: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case productName = "product_name"
        case productDesc = "product_description"
        case appleProductId = "apple_app_store_product_id"
        case appleAppAccountToken = "apple_app_account_token"
    }
}

public struct PaymentVerification: Decodable {
    public var id: String
    
    enum CodingKeys: String, CodingKey {
        case id = "payment_id"
    }
}
