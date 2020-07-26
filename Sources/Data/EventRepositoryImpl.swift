//
// Copyright © 2020 mycujoo. All rights reserved.
//

import Foundation


class EventRepositoryImpl: BaseRepositoryImpl, EventRepository {
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
}
