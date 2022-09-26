//
// Copyright © 2020 mycujoo. All rights reserved.
//

import Foundation
import Moya


class EventRepositoryImpl: BaseRepositoryImpl, MLSEventRepository {
    let ws: WebSocketConnection
    let fwsFactory: (_ eventId: String) -> FeaturedWebsocketConnection
    let enableConcurrencyControl: Bool
    
    private var fws: [String: FeaturedWebsocketConnection] = [:]
    private var timers: [String: RepeatingTimer] = [:]

    init(api: MoyaProvider<API>, ws: WebSocketConnection, fwsFactory: @escaping (_ eventId: String) -> FeaturedWebsocketConnection, enableConcurrencyControl: Bool) {
        self.ws = ws
        self.fwsFactory = fwsFactory
        self.enableConcurrencyControl = enableConcurrencyControl
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

    /// - note: You can only have one listener for eventUpdates per event id.
    func startEventUpdates(for id: String, callback: @escaping (MLSEventRepositoryEventUpdate) -> ()) {
        timers[id] = RepeatingTimer(timeInterval: 10)
        fws[id] = fwsFactory(id)

        var latestEvent: Event? = nil {
            didSet {
                if let latestEvent = latestEvent, latestEvent.streams.count == 0 {
                    timers[id]?.resume()
                } else {
                    timers[id]?.suspend()
                }
            }
        }

        timers[id]?.eventHandler = { [weak self] in
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
                    self?.fetchEvent(byId: id, updateId: updateId, callback: { [weak self] updatedEvent, _ in
                        self?.timers[id]?.reset()
                        latestEvent = updatedEvent
                        if let updatedEvent = updatedEvent {
                            callback(.eventUpdate(event: updatedEvent))
                        }
                    })
                default:
                    break
                }
            }
            
            /// Feature toggle is available for `FeaturedWebsocket`, therefore sdk's user should define wether to use it or not when calling the `MLS` sdk.
            /// And also only connecting to this websocket if the event is not `Scheduled`.
            if let enableConcurrencyControl = self?.enableConcurrencyControl, enableConcurrencyControl, latestEvent?.status != .scheduled {
                
                // For now, only connect to this websocket if it requires entitlement.
                // Later on, we can also do this for non-protected events, when the websockets support more features.
                
                if (latestEvent?.isProtected ?? false) &&
                    (latestEvent?.streams.first?.error == nil) &&
                    (latestEvent?.isMLS != false) {
                    self?.fws[id]?.subscribe(room: FeaturedWebsocketConnection.Room(id: id, type: .event)) { update in
                        switch update {
                        case .concurrencyLimitExceeded(let eventId, let limit):
                            guard id == eventId else { return }
                            callback(.concurrencyLimitExceeded(limit: limit))
                        }
                    }
                }
            }
        }
    }
    
    func stopEventUpdates(for id: String) {
        ws.unsubscribe(room: WebSocketConnection.Room(id: id, type: .event))
        fws[id]?.unsubscribe(room: FeaturedWebsocketConnection.Room(id: id, type: .event))
        timers[id] = nil
        fws[id] = nil
    }
}
