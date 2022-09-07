//
// Copyright © 2022 mycujoo. All rights reserved.
//

import Foundation


public struct PaymentFulfillment: Decodable {
    public var isEntitled: Bool
    
    enum CodingKeys: String, CodingKey {
        case isEntitled = "is_entitled"
    }
}
