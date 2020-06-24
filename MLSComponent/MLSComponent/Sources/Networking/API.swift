//
// Copyright © 2020 mycujoo. All rights reserved.
//

import Foundation
import Moya

public enum API {
    case playerConfig(String)
    case annotations(String)
}
extension API: TargetType {
    public var baseURL: URL { return URL(string: "https://mls-api.mycujoo.tv")! }
    public var path: String {
        switch self {
        case .playerConfig(let eventId):
            return "/bff/player_config/\(eventId)"
        case .annotations(let timelineId):
            return "/bff/annotations/\(timelineId)"
        }
    }

    public var method: Moya.Method {
        switch self {
        case .playerConfig, .annotations:
            return .get
        }
    }

    public var sampleData: Data {
        switch self {
        case .playerConfig(let eventId):
            return Data("""
                {"primary_color":"#de4f1f","autoplay":true,"default_volume":80.0,"back_forward_buttons":true,"live_viewers":true,"event_info_button":true}
                """.utf8)
        case .annotations(let timelineId):
            switch timelineId {
            case "timelineMarkers":
                return Data("""
                {"annotations":[{"actions":[{"data":{"color":"#ff0000","label":"Goal"},"type":"show_timeline_marker"}],"id":"ann_1","offset":824000,"timeline_id":"tml_1"},{"actions":[{"data":{"color":"#cccccc","label":"Goal"},"type":"show_timeline_marker"}],"id":"ann_3","offset":4122000,"timeline_id":"tml_3"},{"actions":[{"data":{"color":"#fda89f","label":"A very long annotation"},"type":"show_timeline_marker"}],"id":"ann_4","offset":7419000,"timeline_id":"tml_4"}]}
                """.utf8)
            default:
                return Data("""
                {"annotations":[{"id":"ann_1","offset":120000,"timeline_id":"tml_1","actions":[{"type":"show_timeline_marker","data":{"color":"#cccccc","label":"Goal"}},{"type":"show_overlay","data":{"custom_id":"scoreboard1","svg_url":"https://svg.mls.mycujoo.tv/jfkdlajfd.svg","position":{"top":null,"bottom":5.0,"vcenter":null,"right":null,"left":5.0,"hcenter":null},"size":{"width":33.0,"height":null},"animatein_type":"fade_in","animateout_type":"fade_out","animatein_duration":0.3,"animateout_duration":0.3,"duration":5.0,"variable_positions":{"###_HOMESCORE_###":"homeScore","###_AWAYSCORE_###":"awayScore"}}},{"type":"hide_overlay","data":{"custom_id":"overlay1","animateout_type":"fade_out","animateout_duration":0.3}},{"type":"set_variable","data":{"name":"homeScore","value":0,"type":"double","double_precision":2}},{"type":"increment_variable","data":{"name":"homeScore","amount":1.0}},{"type":"create_timer","data":{"name":"scoreboardTimer","format":"ms","direction":"down","start_value":2700000,"step":1000,"cap_value":0}},{"type":"start_timer","data":{"name":"scoreboardTimer"}},{"type":"pause_timer","data":{"name":"scoreboardTimer"}},{"type":"adjust_timer","data":{"name":"scoreboardTimer","value":20000}},{"type":"create_clock","data":{"name":"clock1","format":"12h"}}]}]}
                """.utf8)
            }
        }
    }

    public var task: Moya.Task {
        switch self {
        case .playerConfig, .annotations:
           return .requestPlain
       }
    }

    public var headers: [String : String]? {
        return [:]
    }
}
