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
    case listEventPackages(eventId: String)
    case createOrder(packageId: String)
    case paymentVerification(jws: String, orderId: String)
    case checkEntitlement(contentType: String, contentId: String)
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
    var baseURL: URL { return URL(string: "https://mcls-api.mycujoo.tv")! }
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
        case .listEventPackages(_):
            return "/bff/payments/v1/event_packages"
        case .createOrder:
            return "/bff/payments/v1/orders"
        case .paymentVerification(_, let orderId):
            return "/bff/payments/v1/orders/\(orderId)/app_store/payments"
        case .checkEntitlement(let contentType, let contentId):
            return "/bff/entitlements/v1/\(contentType)/\(contentId)"
        }
    }

    var method: Moya.Method {
        switch self {
        case .eventById, .events, .timelineActions, .playerConfig, .listEventPackages, .checkEntitlement:
            return .get
        case .createOrder, .paymentVerification:
            return .post
        }
    }

    var sampleData: Data {
        switch self {
        case .eventById:
            return Data("""
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
                    "streams": [
                        {
                            "full_url": null,
                            "id": "1234",
                            "fairplay": {
                                "full_url": "https://drmtestamirso.s3-eu-west-1.amazonaws.com/intertrust/fp2/stream_0.m3u8",
                                "license_url": "https://fp.service.expressplay.com/hms/fp/rights/?ExpressPlayToken=BgAb1JQfKcwAJDgyYjFlMTkzLTlkZWUtNDk4ZC05Mjc2LTM1M2QzYzhiMDU1YwAAAGBNeFgejhCatqc_hJckQ5_mxESR4bYEDVOX8vm-apwJvlXSWCnA1iEffgq16P7GT8ezEXDoieCli7ADLrPW_6Xp9ngBy4UOo72Y6ZCdfn-6F3r1_UCViV8QzV8RNkBHBZdW4znVifxBgepb-2qF-GKN8LbJXw",
                                "certificate_url": "https://storage.googleapis.com/stephen-ckdimbj4800000179uppzgkzy-europe-west/certificates/fairplay.cer"
                            }
                        }
                    ],
                    "thumbnail_url": "",
                    "timeline_ids": [],
                    "timezone": "America/Los_Angeles",
                    "title": "Fairplay stream"
                }
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
                            "title": "Fairplay stream"
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
                            "title": "Example event"
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
                        "update_id": "fe39f4ja9fd",
                        "actions": [
                            {
                                "data": {
                                    "color": "#ffffff",
                                    "label": "Kickoff",
                                    "seek_offset": -1500000
                                },
                                "offset": "1699000",
                                "id": "f4354364q6afd",
                                "type": "show_timeline_marker"
                            },
                            {
                                "offset": "1699000",
                                "id": "43faf4j59595959",
                                "type": "set_variable",
                                "data": {
                                    "name": "$homeScore",
                                    "value": 0,
                                    "type": "long"
                                }
                            },
                            {
                                "offset": "1699000",
                                "id": "43faf4j5959fda8f9",
                                "type": "set_variable",
                                "data": {
                                    "name": "$awayScore",
                                    "value": 0,
                                    "type": "long"
                                }
                            },
                            {
                                "offset": "1699000",
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
                                "offset": "1699000",
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
                                "offset": "1699000",
                                "id": "54afag35yag",
                                "type": "show_overlay"
                            },
                            {
                                "data": {
                                    "color": "#ffffff",
                                    "label": "Halftime",
                                    "seek_offset": -5000
                                },
                                "offset": "4720000",
                                "id": "fda43t943f9b",
                                "type": "show_timeline_marker"
                            },
                            {
                                "offset": "4720000",
                                "id": "4fdaf5tygfhfhffhb",
                                "type": "pause_timer",
                                "data": {
                                    "name": "$scoreboardTimer"
                                }
                            },
                            {
                                "offset": "4720000",
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
                                "offset": "5711000",
                                "id": "fda43t943f3c",
                                "type": "show_timeline_marker"
                            },
                            {
                                "offset": "5711000",
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
                                "offset": "5891000",
                                "id": "fda43t943f9a",
                                "type": "show_timeline_marker"
                            },
                            {
                                "offset": "5891000",
                                "id": "aaa444466agfffag5",
                                "type": "increment_variable",
                                "data": {
                                    "name": "$homeScore",
                                    "amount": 1.0
                                }
                            },
                            {
                                "offset": "5891000",
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
                                "offset": "5891000",
                                "id": "gagj9j9agj9a",
                                "type": "show_overlay"
                            },
                            {
                                "data": {
                                    "color": "#de4f1f",
                                    "label": "Fulltime",
                                    "seek_offset": 0
                                },
                                "offset": "8850000",
                                "id": "bmb9t49bm34t",
                                "type": "show_timeline_marker"
                            },
                            {
                                "offset": "8850000",
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
                                "offset": "8855000",
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
        case .createOrder:
            return Data("""
                {
                  "apple_app_account_token": "sampleToken123",
                  "apple_app_store_product_id": "test123",
                  "id": "1",
                  "product_name": "test subscription"
                }
                """.utf8)
        case .listEventPackages:
            return Data("""
            {
              "packages": [
                {
                  "apple_app_store_product_id": "test123",
                  "id": "1"
                }
              ]
            }
            """.utf8)
        default: return Data("".utf8)
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
        case .listEventPackages(let eventId):
            var params: [String: Any] = [:]
            params["event_id"] = eventId
            return .requestParameters(parameters: params, encoding: URLEncoding.queryString)
        case .createOrder(let packageId):
            var params: [String: Any] = [:]
            params["content_reference"] = ["type": "package", "id": packageId]
            return .requestParameters(parameters: params, encoding: JSONEncoding.default)
            
        case .paymentVerification(let jws, let orderId):
            var params: [String: Any] = [:]
            params["jws_representation"] = jws
            params["order_id"] = orderId
            return .requestParameters(parameters: params, encoding: JSONEncoding.default)
        case .checkEntitlement(_, _):
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
