//
// Copyright © 2020 mycujoo. All rights reserved.
//

import Foundation

public struct Stream: Equatable {
    public struct Err: Equatable {
        public enum ErrorCode: Equatable {
            case geoblocked
            case missingEntitlement
            case internalError
        }
        let code: ErrorCode?
        let message: String?

        public init(code: ErrorCode?, message: String?) {
            self.code = code
            self.message = message
        }
    }

    public let id: String
    private let fullUrl: URL?
    public let fairplay: FairplayStream?
    /// The size of the DVR window in milliseconds
    public let dvrWindowSize: Int?
    public let error: Err?

    /// This is the stream url. It assumes the `full_url` from the MLS API, or if that is null, it falls back to  the `full_url` on the fairplay object, if one is available.
    public var url: URL? {
        return fullUrl ?? fairplay?.fullUrl
    }

    public init(id: String, fullUrl: URL?, fairplay: FairplayStream?, dvrWindowSize: Int?, error: Err?) {
        self.id = id
        self.fullUrl = fullUrl
        self.fairplay = fairplay
        self.dvrWindowSize = dvrWindowSize
        self.error = error
    }
}

public struct FairplayStream: Equatable {
    public let fullUrl: URL
    public let licenseUrl: URL
    public let certificateUrl: URL
}
