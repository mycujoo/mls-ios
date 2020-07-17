//
// Copyright © 2020 mycujoo. All rights reserved.
//

import Foundation
import Moya

enum API {
    case eventById(String)
    case events(pageSize: Int?, pageToken: String?, hasStream: Bool?, status: [ParamEventStatus]?, orderBy: ParamEventOrder?)
    case playerConfig(String)
    case annotations(String)

    /// A dateformatter that can be used on Event objects on this API.
    static var eventDateTimeFormatter: DateFormatter = {
        var formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        return formatter
    }()
}

extension API: TargetType {
    var baseURL: URL { return URL(string: "https://mls-api.mycujoo.tv")! }
    var path: String {
        switch self {
        case .eventById(let eventId):
            return "/bff/events/v1beta1/\(eventId)"
        case .events:
            return "/bff/events/v1beta1"
        case .playerConfig(let eventId):
            return "/bff/player_config/\(eventId)"
        case .annotations(let timelineId):
            return "/bff/annotations/\(timelineId)"
        }
    }

    var method: Moya.Method {
        switch self {
        case .eventById, .events, .playerConfig, .annotations:
            return .get
        }
    }



    var sampleData: Data {
        switch self {
        case .eventById:
            return Data("""
                {"id":"1eOhF2NnDunfzXdO6E10dVAK2tN","title":"TestwithShervin","description":"","thumbnail_url":"","location":{"physical":{"venue":"","city":"Amsterdam","country_code":"NL","continent_code":"EU","coordinates":{"latitude":52.3666969,"longitude":4.8945398}}},"organiser":"","start_time":"2020-07-09T08:52:18Z","timezone":"America/Los_Angeles","status":"EVENT_STATUS_SCHEDULED","streams":[{"full_url":"https://rendered-europe-west.mls.mycujoo.tv/mats/ckcd4l84800030108rouubqsj/master.m3u8"}],"timeline_ids":[],"is_test":false,"metadata":{}}
                """.utf8)
        case .events:
            return Data("""
                {"events":[{"id":"1eOhF2NnDunfzXdO6E10dVAK2tN","title":"TestwithShervin","description":"","thumbnail_url":"","location":{"physical":{"venue":"","city":"Amsterdam","country_code":"NL","continent_code":"EU","coordinates":{"latitude":52.3666969,"longitude":4.8945398}}},"organiser":"","start_time":"2020-07-09T08:52:18Z","timezone":"America/Los_Angeles","status":"EVENT_STATUS_SCHEDULED","streams":[{"full_url":"https://live.mycujoo.tv/sa/gcs/cjz1ycawc1hjn0gd7f8pjvs7l/master.m3u8"}],"timeline_ids":[],"is_test":false,"metadata":{}},{"id":"1e8KVTx5VfG27zJdRWlcZnQUVZY","title":"Fullflowtest","description":"","thumbnail_url":"","location":{"physical":{"venue":"","city":"Amsterdam","country_code":"NL","continent_code":"EU","coordinates":{"latitude":52.3666969,"longitude":4.8945398}}},"organiser":"","start_time":"2020-07-04T13:49:47Z","timezone":"America/Los_Angeles","status":"EVENT_STATUS_SCHEDULED","streams":[{"full_url":"https://live.mycujoo.tv/sa/gcs/cjz1ycawc1hjn0gd7f8pjvs7l/master.m3u8"}],"timeline_ids":[],"is_test":false,"metadata":{}}],"next_page_token":"","previous_page_token":""}
                """.utf8)
        case .playerConfig:
            return Data("""
                {"primary_color":"#ffffff","secondary_color":"#de4f1f","autoplay":true,"default_volume":80.0,"back_forward_buttons":true,"live_viewers":true,"event_info_button":true}
                """.utf8)
        case .annotations(let timelineId):
            return Data("""
                {
                    "actions": [
                        {
                            "data": {
                                "color": "#ffffff",
                                "label": "Kickoff"
                            },
                            "offset": 1699000,
                            "id": "f4354364q6afd",
                            "type": "show_timeline_marker"
                        },
                        {
                            "id": "43faf4j59595959",
                            "type": "set_variable",
                            "data": {
                                "name": "$homeScore",
                                "value": 0,
                                "type": "double",
                                "double_precision": 2
                            }
                        },
                        {
                            "id": "43faf4j5959fda8f9",
                            "type": "set_variable",
                            "data": {
                                "name": "$awayScore",
                                "value": 0,
                                "type": "double",
                                "double_precision": 2
                            }
                        },
                        {
                            "data": {
                                "animatein_duration": 300,
                                "animatein_type": "fade_in",
                                "custom_id": "scoreboard1",
                                "position": {
                                    "left": 5.0,
                                    "top": 5.0
                                },
                                "size": {
                                    "width": 25.0
                                },
                                "svg_url": "https://storage.googleapis.com/mycujoo-player-app.appspot.com/scoreboard_and_timer.svg",
                                "variable_positions": {
                                    "###_AWAYSCORE_###": "$awayScore",
                                    "###_HOMESCORE_###": "$homeScore",
                                    "###_TIMER_###": "$timer1"
                                }
                            },
                            "offset": 1699000,
                            "id": "54afag35yag",
                            "type": "show_overlay"
                        },
                        {
                            "data": {
                                "color": "#ffff01",
                                "label": "Goal"
                            },
                            "offset": 5891000,
                            "id": "fda43t943f9a",
                            "type": "show_timeline_marker"
                        },
                        {
                            "id": "aaa444466agfffag5",
                            "type": "increment_variable",
                            "data": {
                                "name": "$homeScore",
                                "amount": 1.0
                            }
                        },
                        {
                            "data": {
                                "animatein_duration": 500,
                                "animatein_type": "slide_from_right",
                                "animateout_duration": 500,
                                "animateout_type": "slide_to_left",
                                "duration": 5000,
                                "position": {
                                    "bottom": 10.0,
                                    "left": 5.0
                                },
                                "size": {
                                    "width": 30.0
                                },
                                "svg_url": "https://storage.googleapis.com/mycujoo-player-app.appspot.com/announcement_overlay.svg"
                            },
                            "offset": 5891000,
                            "id": "gagj9j9agj9a",
                            "type": "show_overlay"
                        },
                        {
                            "data": {
                                "color": "#de4f1f",
                                "label": "Fulltime"
                            },
                            "offset": 8850000,
                            "id": "bmb9t49bm34t",
                            "type": "show_timeline_marker"
                        },
                        {
                            "data": {
                                "animateout_duration": 300,
                                "animateout_type": "fade_out",
                                "custom_id": "scoreboard1"
                            },
                            "offset": 8850000,
                            "id": "f43f9ajf9dfjSX",
                            "type": "hide_overlay"
                        }
                    ]
                }
                """.utf8)

        }
    }

    var task: Moya.Task {
        switch self {
        case .events(let pageSize, let pageToken, let hasStream, let status, let orderBy):
            var params: [String : Any] = [:]
            if let pageSize = pageSize {
                params["page_size"] = pageSize
            }
            if let pageToken = pageToken {
                params["page_token"] = pageToken
            }
            if let hasStream = hasStream {
                params["has_stream"] = hasStream
            }
            if let status = status {
                params["status"] = status.map { $0.rawValue }
            }
            if let orderBy = orderBy {
                params["order_by"] = orderBy.rawValue
            }

            return .requestParameters(parameters: params, encoding: URLEncoding.queryString)
        case .eventById, .playerConfig, .annotations:
           return .requestPlain
       }
    }

    var headers: [String : String]? {
        return [:]
    }
}

extension API: AccessTokenAuthorizable {
    var authorizationType: AuthorizationType? {
        return .bearer
    }
}
