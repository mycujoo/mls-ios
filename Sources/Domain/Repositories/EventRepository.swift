//
// Copyright © 2020 mycujoo. All rights reserved.
//

import Foundation


protocol EventRepository {
    func fetchEvent(byId id: String, updateId: String?, callback: @escaping (Event?, Error?) -> ())
    func fetchEvents(pageSize: Int?, pageToken: String?, status: [ParamEventStatus]?, orderBy: ParamEventOrder?, callback: @escaping ([Event]?, Error?) -> ())

    func startEventUpdates(for id: String, pseudoUserId: String, callback: @escaping (EventRepositoryEventUpdate) -> ())
    func stopEventUpdates(for id: String)
}

/// An enum that represents updates on an Event
enum EventRepositoryEventUpdate {
    case eventLiveViewers(amount: Int)
    case eventUpdate(event: Event)
}
