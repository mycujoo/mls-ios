//
// Copyright © 2020 mycujoo. All rights reserved.
//

import Foundation

extension DataLayer {
    struct Stream: Decodable {
        let id: String
        let fullUrl: URL?
    }
}

extension DataLayer.Stream {
    enum CodingKeys: String, CodingKey {
        case id
        case fullUrl = "full_url"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let id: String = try container.decode(String.self, forKey: .id)
        let fullUrl: URL? = try? container.decode(URL.self, forKey: .fullUrl)

        self.init(id: id, fullUrl: fullUrl)
    }
}

// - MARK: Mappers

extension DataLayer.Stream {
    var toDomain: MLSSDK.Stream {
        return MLSSDK.Stream(id: self.id, fullUrl: self.fullUrl)
    }
}
