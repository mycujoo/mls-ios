//
// Copyright © 2020 mycujoo. All rights reserved.
//

import Foundation


class EventRepositoryImpl: BaseRepositoryImpl, EventRepository {
    func fetchEvent(byId id: String, callback: @escaping (Event?, Error?) -> ()) {
        _fetch(.eventById(id), type: DataLayer.Event.self) { (event, err) in
            callback(event?.toDomain, err)
        }
    }
    
    func fetchEvents(pageSize: Int?, pageToken: String?, hasStream: Bool?, status: [ParamEventStatus]?, orderBy: ParamEventOrder?, callback: @escaping ([Event]?, Error?) -> ()) {
            _fetch(
                .events(
                    pageSize: pageSize,
                    pageToken: pageToken,
                    hasStream: hasStream,
                    status: status?.map { DataLayer.ParamEventStatus.fromDomain($0) },
                    orderBy: orderBy != nil ? DataLayer.ParamEventOrder.fromDomain(orderBy!) : nil),
                type: DataLayer.EventWrapper.self
        ) { (wrapper, err) in
            // TODO: Return the pagination tokens as well
            callback(wrapper?.events.map { $0.toDomain }, err)
        }
    }
}
