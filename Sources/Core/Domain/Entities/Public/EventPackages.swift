//
// Copyright © 2022 mycujoo. All rights reserved.
//

import Foundation


public struct EventPackages: Decodable {
    public var id: String
    public var appleProductId: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case appleProductId = "apple_app_store_product_id"
    }
}
