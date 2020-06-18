//
// Copyright © 2020 mycujoo. All rights reserved.
//

import Foundation
import Moya

public enum API {
    case annotations(String)
}
extension API: TargetType {
    public var baseURL: URL { return URL(string: "https://mls-api.mycujoo.tv")! }
    public var path: String {
        switch self {
        case .annotations(let timelineId):
            return "/bff/annotations/\(timelineId)"
        }
    }

    public var method: Moya.Method {
        switch self {
        case .annotations:
            return .get
        }
    }

    public var sampleData: Data {
        return Data()
    }

    public var task: Moya.Task {
        switch self {
       case .annotations:
           return .requestPlain
       }
    }

    public var headers: [String : String]? {
        return [:]
    }
}
