//
// Copyright © 2020 mycujoo. All rights reserved.
//

import Foundation


public protocol MLSEventRepository {
    func fetchEvent(byId id: String, updateId: String?, callback: @escaping (Event?, Error?) -> ())
    /// - parameter callback: A callback that provides a list of Events, nextPageToken, previousPageToken, or an Error.
    func fetchEvents(pageSize: Int?, pageToken: String?, status: [ParamEventStatus]?, orderBy: ParamEventOrder?, callback: @escaping ([Event]?, String?, String?, Error?) -> ())
    func startEventUpdates(for id: String, callback: @escaping (MLSEventRepositoryEventUpdate) -> ())
    func stopEventUpdates(for id: String)
}

/// An enum that represents updates on an Event
public enum MLSEventRepositoryEventUpdate {
    case eventLiveViewers(amount: Int)
    case eventUpdate(event: Event)
    case concurrencyLimitExceeded(limit: Int)
    case errorAuthFailed
    case errorNotEntitled
}
