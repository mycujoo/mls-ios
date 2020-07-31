//
// Copyright © 2020 mycujoo. All rights reserved.
//

import Foundation
import Moya


class EventRepositoryImpl: BaseRepositoryImpl, EventRepository {
    let ws: WebSocketConnection

    init(api: MoyaProvider<API>, ws: WebSocketConnection) {
        self.ws = ws

        super.init(api: api)
    }

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

    func startEventUpdates(for id: String, callback: @escaping (EventRepositoryEventUpdate) -> ()) {
        // TODO: Determine sessionId
        ws.subscribe(eventId: id, sessionId: "") { update in
            switch update {
            case .eventTotal(let total):
                callback(.eventTotal(total: total))
            case .eventUpdate(let updateId):
                // TODO: Pass to Moya
                break
            }
        }
    }
    
    func stopEventUpdates(for id: String) {
        ws.unsubscribe(eventId: id)
    }
}
