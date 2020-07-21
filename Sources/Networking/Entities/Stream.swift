//
// Copyright © 2020 mycujoo. All rights reserved.
//

import Foundation

public struct Stream: Decodable {
    public let fullUrl: URL
}

public extension Stream {
    enum CodingKeys: String, CodingKey {
        case fullUrl = "full_url"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let fullUrl: URL = try container.decode(URL.self, forKey: .fullUrl)

        self.init(fullUrl: fullUrl)
    }
}
