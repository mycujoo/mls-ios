//
// Copyright © 2020 mycujoo. All rights reserved.
//

import Foundation


protocol EventRepository {
    func fetchEvent(byId id: String, callback: @escaping (Event?, Error?) -> ())
    func fetchEvents(pageSize: Int?, pageToken: String?, hasStream: Bool?, status: [ParamEventStatus]?, orderBy: ParamEventOrder?, callback: @escaping ([Event]?, Error?) -> ())

    func startEventUpdates(for id: String, callback: @escaping (EventRepositoryEventUpdate) -> ())
    func stopEventUpdates(for id: String)
}

/// An enum that represents updates on an Event
enum EventRepositoryEventUpdate {
    case eventTotal(total: Int)
    case eventUpdate(event: Event)
}
