//
// Copyright © 2022 mycujoo. All rights reserved.
//

import Foundation


public struct PaymentVerification: Decodable {
    public var id: String
    
    enum CodingKeys: String, CodingKey {
        case id = "payment_id"
    }
}
