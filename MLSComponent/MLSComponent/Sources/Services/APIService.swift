//
// Copyright © 2020 mycujoo. All rights reserved.
//

import Foundation
import Moya

protocol APIServicing {
    func fetchEvent(byId id: String, callback: @escaping (Event?, Error?) -> ())
    func fetchEvents(callback: @escaping ([Event]?, Error?) -> ())
    func fetchAnnotations(byTimelineId timelineId: String, callback: @escaping ([Annotation]?, Error?) -> ())
    func fetchPlayerConfig(byEventId eventId: String, callback: @escaping (PlayerConfig?, Error?) -> ())
}

class APIService: APIServicing {
    private let api: MoyaProvider<API>

    init(api: MoyaProvider<API>) {
        self.api = api
    }

    func fetchEvent(byId id: String, callback: @escaping (Event?, Error?) -> ()) {
        api.request(.eventById(id)) { result in
            switch result {
            case .success(let response):
                let decoder = JSONDecoder()
                do {
                    let event = try decoder.decode(Event.self, from: response.data)
                    // TODO: Return the pagination tokens as well
                    callback(event, nil)
                } catch {
                    callback(nil, error)
                }
            case .failure(let error):
                callback(nil, error)
            }
        }
    }

    func fetchEvents(callback: @escaping ([Event]?, Error?) -> ()) {
        api.request(.events) { result in
            switch result {
            case .success(let response):
                let decoder = JSONDecoder()
                do {
                    let eventWrapper = try decoder.decode(EventWrapper.self, from: response.data)
                    // TODO: Return the pagination tokens as well
                    callback(eventWrapper.events, nil)
                } catch {
                    callback(nil, error)
                }
            case .failure(let error):
                callback(nil, error)
            }
        }
    }

    func fetchAnnotations(byTimelineId timelineId: String, callback: @escaping ([Annotation]?, Error?) -> ()) {
        api.request(.annotations(timelineId)) { result in
            switch result {
            case .success(let response):
                let decoder = JSONDecoder()
                do {
                    let annotationWrapper = try decoder.decode(AnnotationWrapper.self, from: response.data)
                    // TODO: Return the pagination tokens as well
                    callback(annotationWrapper.annotations, nil)
                } catch {
                    callback(nil, error)
                }
            case .failure(let error):
                callback(nil, error)
            }
        }
    }

    func fetchPlayerConfig(byEventId eventId: String, callback: @escaping (PlayerConfig?, Error?) -> ()) {
        api.request(.playerConfig(eventId)) { result in
            switch result {
            case .success(let response):
                let decoder = JSONDecoder()
                do {
                    let config = try decoder.decode(PlayerConfig.self, from: response.data)
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
