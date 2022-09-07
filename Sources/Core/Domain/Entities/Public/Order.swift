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
    public var contentReference: ContentReference
    enum CodingKeys: String, CodingKey {
        case id
        case productName = "product_name"
        case productDesc = "product_description"
        case appleProductId = "apple_app_store_product_id"
        case appleAppAccountToken = "apple_app_account_token"
        case contentReference = "content_reference"
    }
}

public struct ContentReference: Decodable {
    public var id: String
    public var type: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case type
    }
}
