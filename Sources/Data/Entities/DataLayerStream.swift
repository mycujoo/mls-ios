//
// Copyright © 2020 mycujoo. All rights reserved.
//

import Foundation

extension DataLayer {
    struct Stream: Decodable {
        struct Err: Decodable {
            let code: MLSSDK.Stream.Err.ErrorCode?
            let message: String?
        }
        struct DRM: Decodable {
            struct FairplayStream: Decodable {
                let fullUrl: URL
                let licenseUrl: URL
                let certificateUrl: URL
            }
            let fairplay: FairplayStream?
        }

        let id: String
        let fullUrl: URL?
        let drm: DRM?
        let dvrWindowSize: Int?
        let error: Stream.Err?
    }
}


extension DataLayer.Stream {
    enum CodingKeys: String, CodingKey {
        case id
        case fullUrl = "full_url"
        case drm
        case dvrWindowSize = "dvr_window_size"
        case error
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let id: String = try container.decode(String.self, forKey: .id)
        let fullUrl: URL? = try? container.decode(URL.self, forKey: .fullUrl)
        let drm: DRM? = try? container.decode(DRM.self, forKey: .drm)
        let dvrWindowSize: Int?
        if let dvrWindowSizeAsStr = try? container.decode(String.self, forKey: .dvrWindowSize),
           let dvrWindowSizeAsInt = Int(dvrWindowSizeAsStr),
           dvrWindowSizeAsInt > 0 {
            dvrWindowSize = dvrWindowSizeAsInt
        } else {
            dvrWindowSize = nil
        }

        let error: DataLayer.Stream.Err? = try? container.decode(DataLayer.Stream.Err.self, forKey: .error)

        self.init(id: id, fullUrl: fullUrl, drm: drm, dvrWindowSize: dvrWindowSize, error: error)
    }
}

extension DataLayer.Stream.Err {
    enum CodingKeys: String, CodingKey {
        case code
        case message
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let message: String? = try? container.decode(String.self, forKey: .message)

        var errorCode: Stream.Err.ErrorCode? = nil
        if let errorCodeStr = try? container.decode(String.self, forKey: .code) {
            switch errorCodeStr {
            case "ERROR_CODE_GEOBLOCKED": errorCode = .geoblocked
            case "ERROR_CODE_NO_ENTITLEMENT": errorCode = .missingEntitlement
            default: errorCode = .internalError
            }
        }

        self.init(code: errorCode, message: message)
    }
}

extension DataLayer.Stream.DRM {
    enum CodingKeys: String, CodingKey {
        case fairplay
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        let fairplay: DataLayer.Stream.DRM.FairplayStream? = try? container.decode(DataLayer.Stream.DRM.FairplayStream.self, forKey: .fairplay)

        self.init(fairplay: fairplay)
    }
}

extension DataLayer.Stream.DRM.FairplayStream {
    enum CodingKeys: String, CodingKey {
        case fullUrl = "full_url"
        case licenseUrl = "license_url"
        case certificateUrl = "certificate_url"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let fullUrl: URL = try container.decode(URL.self, forKey: .fullUrl)
        let licenseUrl: URL = try container.decode(URL.self, forKey: .licenseUrl)
        let certificateUrl: URL = try container.decode(URL.self, forKey: .certificateUrl)

        self.init(fullUrl: fullUrl, licenseUrl: licenseUrl, certificateUrl: certificateUrl)
    }
}


// - MARK: Mappers

extension DataLayer.Stream {
    var toDomain: MLSSDK.Stream {
        return MLSSDK.Stream(id: self.id, fullUrl: self.fullUrl, fairplay: self.drm?.fairplay?.toDomain, dvrWindowSize: self.dvrWindowSize, error: self.error?.toDomain)
    }
}

extension DataLayer.Stream.Err {
    var toDomain: MLSSDK.Stream.Err {
        return MLSSDK.Stream.Err(code: self.code, message: self.message)
    }
}

extension DataLayer.Stream.DRM.FairplayStream {
    var toDomain: MLSSDK.FairplayStream {
        return MLSSDK.FairplayStream(fullUrl: fullUrl, licenseUrl: licenseUrl, certificateUrl: certificateUrl)
    }
}
