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

    func fetchEvent(byId id: String, updateId: String?, callback: @escaping (Event?, Error?) -> ()) {
        _fetch(.eventById(id: id, updateId: updateId), type: DataLayer.Event.self) { (event, err) in
            callback(event?.toDomain, err)
        }
    }
    
    func fetchEvents(pageSize: Int?, pageToken: String?, status: [ParamEventStatus]?, orderBy: ParamEventOrder?, callback: @escaping ([Event]?, String?, String?, Error?) -> ()) {
            _fetch(
                .events(
                    pageSize: pageSize,
                    pageToken: pageToken,
                    status: status?.map { DataLayer.ParamEventStatus.fromDomain($0) },
                    orderBy: orderBy != nil ? DataLayer.ParamEventOrder.fromDomain(orderBy!) : nil),
                type: DataLayer.EventWrapper.self
        ) { (wrapper, err) in
            // TODO: Return the pagination tokens as well
            callback(wrapper?.events.map { $0.toDomain }, wrapper?.nextPageToken, wrapper?.previousPageToken, err)
        }
    }

    func startEventUpdates(for id: String, callback: @escaping (EventRepositoryEventUpdate) -> ()) {
        let timer = RepeatingTimer(timeInterval: 30)

        var latestEvent: Event? = nil {
            didSet {
                if let latestEvent = latestEvent, latestEvent.streams.count == 0 {
                    timer.resume()
                } else {
                    timer.suspend()
                }
            }
        }

        timer.eventHandler = { [weak self] in
            self?.fetchEvent(byId: id, updateId: nil, callback: { updatedEvent, _ in
                latestEvent = updatedEvent
                if let updatedEvent = updatedEvent {
                    callback(.eventUpdate(event: updatedEvent))
                }
            })
        }

        // Do an initial event fetch, and upon completion (regardless of failure or success) start subscribing.
        self.fetchEvent(byId: id, updateId: nil) { [weak self] (initialEvent, _) in
            latestEvent = initialEvent
            if let initialEvent = initialEvent {
                callback(.eventUpdate(event: initialEvent))
            }

            self?.ws.subscribe(room: WebSocketConnection.Room(id: id, type: .event)) { [weak self] update in
                switch update {
                case .eventTotal(let total):
                    callback(.eventLiveViewers(amount: total))
                case .eventUpdate(let updateId):
                    // Fetch the event again and do the callback after that.
                    self?.fetchEvent(byId: id, updateId: updateId, callback: { updatedEvent, _ in
                        timer.reset()
                        latestEvent = updatedEvent
                        if let updatedEvent = updatedEvent {
                            callback(.eventUpdate(event: updatedEvent))
                        }
                    })
                default:
                    break
                }
            }
        }
    }
    
    func stopEventUpdates(for id: String) {
        ws.unsubscribe(room: WebSocketConnection.Room(id: id, type: .event))

        // Note: the polling timer does not have to be explicitly stopped because it is deferenced and therefore cancelled.
    }
}
