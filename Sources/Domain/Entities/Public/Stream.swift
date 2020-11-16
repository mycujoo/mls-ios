//
// Copyright © 2020 mycujoo. All rights reserved.
//

import Foundation

public struct Stream: Equatable {
    public let id: String
    private let fullUrl: URL?
    public let fairplay: FairplayStream?

    /// This is the stream url. It assumes the `full_url` from the MLS API, or if that is null, it falls back to  the `full_url` on the fairplay object, if one is available.
    var url: URL? {
        return fullUrl ?? fairplay?.fullUrl
    }

    public init(id: String, fullUrl: URL?, fairplay: FairplayStream?) {
        self.id = id
        self.fullUrl = fullUrl
        self.fairplay = fairplay
    }
}

public struct FairplayStream: Equatable {
    public let fullUrl: URL
    public let licenseUrl: URL
    public let certificateUrl: URL
}
