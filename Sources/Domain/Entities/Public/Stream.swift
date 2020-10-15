//
// Copyright © 2020 mycujoo. All rights reserved.
//

import Foundation

public struct Stream {
    public let id: String
    public let fullUrl: URL?
    public let fairplay: FairplayStream?

    public init(id: String, fullUrl: URL?, fairplay: FairplayStream?) {
        self.id = id
        self.fullUrl = fullUrl
        self.fairplay = fairplay
    }
}

public struct FairplayStream {
    public let fullUrl: URL
    public let licenseUrl: URL
    public let certificateUrl: URL
}
