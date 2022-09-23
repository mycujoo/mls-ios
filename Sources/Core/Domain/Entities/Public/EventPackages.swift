//
// Copyright © 2022 mycujoo. All rights reserved.
//

import Foundation


public struct Package: Decodable {
    public var id: String
    public var appleProductId: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case appleProductId = "apple_app_store_product_id"
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let id: String = try container.decode(String.self, forKey: .id)
        
        let appleProductId: String = try container.decode(String.self, forKey: .appleProductId)
        self.id = id
        self.appleProductId = appleProductId
    }
}

public struct EventPackages: Decodable {
    public var nextToken: String
    public var packages: [Package]
    
    enum CodingKeys: String, CodingKey {
        case nextToken = "next_page_token"
        case packages = "packages"
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let nextToken: String = try container.decode(String.self, forKey: .nextToken)
        
        let packages: [Package] = try container.decode([Package].self, forKey: .packages)
        self.nextToken = nextToken
        self.packages = packages
    }
}
