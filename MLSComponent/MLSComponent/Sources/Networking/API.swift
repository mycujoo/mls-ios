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
        switch self {
        case .annotations(let timelineId):
            switch timelineId {
            case "timelineMarkers":
                return Data("""
                {"annotations":[{"id":"ann_1","timeline_id":"tml_1","offset":5000,"actions":[{"type":"show_timeline_marker","data":{"color":"#ff0000","label":"Goal"}}]},{"id":"ann_2","timeline_id":"tml_2","offset":120000,"actions":[{"type":"show_timeline_marker","data":{"color":"#aaaaaa","label":"Goal"}}]},{"id":"ann_3","timeline_id":"tml_3","offset":240000,"actions":[{"type":"show_timeline_marker","data":{"color":"#00ff44","label":"Goal"}}]},{"id":"ann_4","timeline_id":"tml_4","offset":260000,"actions":[{"type":"show_timeline_marker","data":{"color":"#fda89f","label":"Goal"}}]}]}
                """.utf8)
            default:
                return Data("""
                {"annotations":[{"id":"ann_1","timeline_id":"tml_1","offset":120,"actions":[{"type":"show_timeline_marker","data":{"color":"#cccccc","label":"Goal"}},{"type":"show_overlay","data":{"custom_id":"overlay1","svg_url":"https://svg.mls.mycujoo.tv/jfkdlajfd.svg","position":{"top":null,"bottom":5.0,"vCenter":null,"right":null,"left":5.0,"hCenter":null},"size":{"width":33.0,"height":null},"animatein_type":"fade_in","animateout_type":"fade_out","duration":5.0,"variable_positions":{"###_HOMESCORE_###":"homeScore","###_AWAYSCORE_###":"awayScore"}}},{"type":"hide_overlay","data":{"custom_id":"overlay1"}},{"type":"set_variable","data":{"name":"homeScore","string_value":null,"number_value":0,"bool_value":null}},{"type":"increment_variable","data":{"name":"homeScore","amount":1.0}},{"type":"create_timer","data":{"name":"scoreboardTimer","clock_type":"standard","direction":"down","start_value":2700000,"cap_value":0}},{"type":"start_timer","data":{"name":"scoreboardTimer"}},{"type":"pause_timer","data":{"name":"scoreboardTimer"}},{"type":"adjust_timer","data":{"name":"scoreboardTimer","value":20000}}]}]}
                """.utf8)
            }


        }
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
