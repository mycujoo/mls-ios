//
// Copyright © 2020 mycujoo. All rights reserved.
//

import Foundation
import Moya

protocol APIServicing {
    func fetchEvent(byId id: String, callback: @escaping (Event?, Error?) -> ())
    func fetchEvents(pageSize: Int?, pageToken: String?, hasStream: Bool?, status: [ParamEventStatus]?, orderBy: ParamEventOrder?, callback: @escaping ([Event]?, Error?) -> ())
    func fetchAnnotations(byTimelineId timelineId: String, callback: @escaping ([Annotation]?, Error?) -> ())
    func fetchPlayerConfig(byEventId eventId: String, callback: @escaping (PlayerConfig?, Error?) -> ())
}

class APIService: APIServicing {
    private let api: MoyaProvider<API>

    // TMP
    var tmpapi: MoyaProvider<API> = {
        let authPlugin = AccessTokenPlugin(tokenClosure: { _ in
            return "F20E0UNTM29R0K5A30JAAE2L87URF2VO"
        })
        return MoyaProvider<API>(plugins: [authPlugin, NetworkLoggerPlugin()])
    }()

    init(api: MoyaProvider<API>) {
        self.api = api
    }

    func fetchEvent(byId id: String, callback: @escaping (Event?, Error?) -> ()) {
        _fetch(.eventById(id), type: Event.self) { (config, err) in
            callback(config, err)
        }
    }

    func fetchEvents(pageSize: Int?, pageToken: String?, hasStream: Bool?, status: [ParamEventStatus]?, orderBy: ParamEventOrder?, callback: @escaping ([Event]?, Error?) -> ()) {
        _fetch(.events(pageSize: pageSize, pageToken: pageToken, hasStream: hasStream, status: status, orderBy: orderBy), type: EventWrapper.self) { (wrapper, err) in
            // TODO: Return the pagination tokens as well
            callback(wrapper?.events, err)
        }
    }

    func fetchAnnotations(byTimelineId timelineId: String, callback: @escaping ([Annotation]?, Error?) -> ()) {
        _fetch(.annotations(timelineId), type: AnnotationWrapper.self) { (wrapper, err) in
            // TODO: Return the pagination tokens as well
            callback(wrapper?.annotations, err)
        }
    }

    func fetchPlayerConfig(byEventId eventId: String, callback: @escaping (PlayerConfig?, Error?) -> ()) {
        _fetch(.playerConfig(eventId), type: PlayerConfig.self) { (config, err) in
            callback(config, err)
        }
    }

    private func _fetch<T: Decodable>(_ endpoint: API, type t: T.Type, callback: @escaping (T?, Error?) -> ()) {
        api.request(endpoint) { result in
            switch result {
            case .success(let response):
                let decoder = JSONDecoder()
                do {
                    let config = try decoder.decode(t.self, from: response.data)
                    // TODO: Return the pagination tokens as well
                    callback(config, nil)
                } catch {
                    callback(nil, error)
                }
            case .failure(let error):
                callback(nil, error)
            }
        }
    }

    // TMP
    private func _tmpfetch<T: Decodable>(_ endpoint: API, type t: T.Type, callback: @escaping (T?, Error?) -> ()) {
        tmpapi.request(endpoint) { result in
            switch result {
            case .success(let response):
                let decoder = JSONDecoder()
                do {
                    let config = try decoder.decode(t.self, from: response.data)
                    // TODO: Return the pagination tokens as well
                    callback(config, nil)
                } catch {
                    callback(nil, error)
                }
            case .failure(let error):
                callback(nil, error)
            }
        }
    }
}
