//
// Copyright © 2020 mycujoo. All rights reserved.
//

import Foundation

public struct Stream {
    public let id: String
    public let fullUrl: URL?

    public init(id: String, fullUrl: URL?) {
        self.id = id
        self.fullUrl = fullUrl
    }
}

