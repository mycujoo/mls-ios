//
// Copyright © 2020 mycujoo. All rights reserved.
//

import Foundation
import Moya

enum API {
    case eventById(id: String, updateId: String?)
    case events(pageSize: Int?, pageToken: String?, status: [DataLayer.ParamEventStatus]?, orderBy: DataLayer.ParamEventOrder?)
    case timelineActions(id: String, updateId: String?)
    case playerConfig

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
        case .eventById(let eventId, _):
            return "/bff/events/v1beta1/\(eventId)"
        case .events:
            return "/bff/events/v1beta1"
        case .timelineActions(let timelineId, _):
            return "/bff/timeline/v1beta1/\(timelineId)"
        case .playerConfig:
            return "/bff/player_config"
        }
    }

    var method: Moya.Method {
        switch self {
        case .eventById, .events, .timelineActions, .playerConfig:
            return .get
        }
    }

    var sampleData: Data {
        switch self {
        case .eventById:
            return Data("""
                {"id":"1eOhF2NnDunfzXdO6E10dVAK2tN","title":"TestwithShervin","description":"","thumbnail_url":"","location":{"physical":{"venue":"","city":"Amsterdam","country_code":"NL","continent_code":"EU","coordinates":{"latitude":52.3666969,"longitude":4.8945398}}},"organiser":"","start_time":"2020-07-09T08:52:18Z","timezone":"America/Los_Angeles","status":"EVENT_STATUS_SCHEDULED","streams":[{"id":"1234", "full_url":"https://rendered-europe-west.mls.mycujoo.tv/mats/ckcd4l84800030108rouubqsj/master.m3u8"}],"timeline_ids":[],"is_test":false,"metadata":{}}
                """.utf8)
        case .events:
            return Data("""
                {
                    "events": [
                        {
                            "description": "",
                            "id": "1eOhF2NnDunfzXdO6E10dVAK2tN",
                            "is_test": false,
                            "location": {
                                "physical": {
                                    "city": "Amsterdam",
                                    "continent_code": "EU",
                                    "coordinates": {
                                        "latitude": 52.3666969,
                                        "longitude": 4.8945398
                                    },
                                    "country_code": "NL",
                                    "venue": ""
                                }
                            },
                            "metadata": {},
                            "organiser": "",
                            "start_time": "2020-07-09T08:52:18Z",
                            "status": "EVENT_STATUS_SCHEDULED",
                            "streams": [],
                            "thumbnail_url": "",
                            "timeline_ids": [],
                            "timezone": "America/Los_Angeles",
                            "title": "TestwithShervin"
                        },
                        {
                            "description": "",
                            "id": "1e8KVTx5VfG27zJdRWlcZnQUVZY",
                            "is_test": false,
                            "location": {
                                "physical": {
                                    "city": "Amsterdam",
                                    "continent_code": "EU",
                                    "coordinates": {
                                        "latitude": 52.3666969,
                                        "longitude": 4.8945398
                                    },
                                    "country_code": "NL",
                                    "venue": ""
                                }
                            },
                            "metadata": {},
                            "organiser": "",
                            "start_time": "2020-07-04T13:49:47Z",
                            "status": "EVENT_STATUS_SCHEDULED",
                            "streams": [],
                            "thumbnail_url": "",
                            "timeline_ids": [],
                            "timezone": "America/Los_Angeles",
                            "title": "Fullflowtest"
                        }
                    ],
                    "next_page_token": "",
                    "previous_page_token": ""
                }
                """.utf8)
        case .timelineActions(let timelineId, _):
            switch timelineId {
            default:
                return Data("""
                    {
                        "actions": [
                            {
                                "data": {
                                    "color": "#ffffff",
                                    "label": "Kickoff",
                                    "seek_offset": -1500000
                                },
                                "offset": 1699000,
                                "id": "f4354364q6afd",
                                "type": "show_timeline_marker"
                            },
                            {
                                "offset": 1699000,
                                "id": "43faf4j59595959",
                                "type": "set_variable",
                                "data": {
                                    "name": "$homeScore",
                                    "value": 0,
                                    "type": "long"
                                }
                            },
                            {
                                "offset": 1699000,
                                "id": "43faf4j5959fda8f9",
                                "type": "set_variable",
                                "data": {
                                    "name": "$awayScore",
                                    "value": 0,
                                    "type": "long"
                                }
                            },
                            {
                                "offset": 1699000,
                                "id": "bbaaaa4444sssstg",
                                "type": "create_timer",
                                "data": {
                                    "name": "$scoreboardTimer",
                                    "format": "ms",
                                    "direction": "up",
                                    "start_value": 0
                                }
                            },
                            {
                                "offset": 1699000,
                                "id": "4fdaf5tygfhfhffha",
                                "type": "start_timer",
                                "data": {
                                    "name": "$scoreboardTimer"
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
                                    "variables": ["$awayScore", "$homeScore", "$scoreboardTimer"]
                                },
                                "offset": 1699000,
                                "id": "54afag35yag",
                                "type": "show_overlay"
                            },
                            {
                                "data": {
                                    "color": "#ffffff",
                                    "label": "Halftime",
                                    "seek_offset": -5000
                                },
                                "offset": 4720000,
                                "id": "fda43t943f9b",
                                "type": "show_timeline_marker"
                            },
                            {
                                "offset": 4720000,
                                "id": "4fdaf5tygfhfhffhb",
                                "type": "pause_timer",
                                "data": {
                                    "name": "$scoreboardTimer"
                                }
                            },
                            {
                                "offset": 4720000,
                                "id": "5cdaf5tygfhfhffhb",
                                "type": "adjust_timer",
                                "data": {
                                    "name": "$scoreboardTimer",
                                    "value": 2700000
                                }
                            },
                            {
                                "data": {
                                    "color": "#ffffff",
                                    "label": "Kickoff",
                                    "seek_offset": 2000
                                },
                                "offset": 5711000,
                                "id": "fda43t943f3c",
                                "type": "show_timeline_marker"
                            },
                            {
                                "offset": 5711000,
                                "id": "4fdaf5tygfhfhffhc",
                                "type": "start_timer",
                                "data": {
                                    "name": "$scoreboardTimer"
                                }
                            },
                            {
                                "data": {
                                    "color": "#ffff01",
                                    "label": "Goal",
                                    "seek_offset": -3000
                                },
                                "offset": 5891000,
                                "id": "fda43t943f9a",
                                "type": "show_timeline_marker"
                            },
                            {
                                "offset": 5891000,
                                "id": "aaa444466agfffag5",
                                "type": "increment_variable",
                                "data": {
                                    "name": "$homeScore",
                                    "amount": 1.0
                                }
                            },
                            {
                                "offset": 5891000,
                                "id": "5cdaf5tygfhfhfno4",
                                "type": "adjust_timer",
                                "data": {
                                    "name": "$scoreboardTimer",
                                    "value": 2940000
                                }
                            },
                            {
                                "offset": 5895000,
                                "id": "5cdaf5tygfhfhfno5",
                                "type": "skip_timer",
                                "data": {
                                    "name": "$scoreboardTimer",
                                    "value": -60000
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
                                    "label": "Fulltime",
                                    "seek_offset": 0
                                },
                                "offset": 8850000,
                                "id": "bmb9t49bm34t",
                                "type": "show_timeline_marker"
                            },
                            {
                                "offset": 8850000,
                                "id": "asaafafafa53",
                                "type": "pause_timer",
                                "data": {
                                    "name": "$scoreboardTimer"
                                }
                            },
                            {
                                "data": {
                                    "animateout_duration": 300,
                                    "animateout_type": "fade_out",
                                    "custom_id": "scoreboard1"
                                },
                                "offset": 8855000,
                                "id": "f43f9ajf9dfjSX",
                                "type": "hide_overlay"
                            }
                        ]
                    }
                """.utf8)
            }
        case .playerConfig:
            return Data("""
                {"primary_color":"#ffffff","secondary_color":"#de4f1f","autoplay":true,"default_volume":80.0,"back_forward_buttons":true,"live_viewers":true,"event_info_button":true}
                """.utf8)
        }
    }

    var task: Moya.Task {
        switch self {
        case .events(let pageSize, let pageToken, let status, let orderBy):
            var params: [String : Any] = [:]
            if let pageSize = pageSize {
                params["page_size"] = pageSize
            }
            if let pageToken = pageToken {
                params["page_token"] = pageToken
            }
            if let status = status {
                params["status"] = status.map { $0.rawValue }
            }
            if let orderBy = orderBy {
                params["order_by"] = orderBy.rawValue
            }

            return .requestParameters(parameters: params, encoding: URLEncoding.queryString)
        case .eventById(_, let updateId):
            var params: [String : Any] = [:]
            if let updateId = updateId {
                params["update_id"] = updateId
            }
            return .requestParameters(parameters: params, encoding: URLEncoding.queryString)
        case .timelineActions(_, let updateId):
            var params: [String : Any] = [:]
            if let updateId = updateId {
                params["update_id"] = updateId
            }
            return .requestParameters(parameters: params, encoding: URLEncoding.queryString)
        case .playerConfig:
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
