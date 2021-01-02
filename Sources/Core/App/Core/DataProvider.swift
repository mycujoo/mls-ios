//
// Copyright © 2020 mycujoo. All rights reserved.
//

import Foundation

public class DataProvider {
    let getEventUseCase: GetEventUseCase
    let listEventsUseCase: ListEventsUseCase

    init(getEventUseCase: GetEventUseCase, listEventsUseCase: ListEventsUseCase) {
        self.getEventUseCase = getEventUseCase
        self.listEventsUseCase = listEventsUseCase
    }

    /// Obtain a single Event from the MLS API.
    /// - parameter completionHandler: gets called when the API response is available. Upon success, contains the Event.
    ///   Upon failure, this completionHandler is called with a nil value.
    public func event(id: String, completionHandler: @escaping (Event?) -> ()) {
        getEventUseCase.execute(id: id) { event, _ in
            if let event = event {
                completionHandler(event)
                return
            }
            completionHandler(nil)
        }
    }

    /// Obtain a list of Events from the MLS API.
    /// - parameter completionHandler: gets called when the API response is available. Upon success, contains the Events,
    ///   a nextPageToken and previousPageToken (respectively), to allow for pagination. Upon failure, this completionHandler is called with all-nil values.
    public func eventList(pageSize: Int? = nil, pageToken: String? = nil, status: [ParamEventStatus]? = nil, orderBy: ParamEventOrder? = nil, completionHandler: @escaping ([Event]?, String?, String?) -> ()) {
        listEventsUseCase.execute(pageSize: pageSize, pageToken: pageToken, status: status, orderBy: orderBy) { (events, nextPageToken, previousPageToken, _) in
            if let events = events {
                completionHandler(events, nextPageToken, previousPageToken)
                return
            }
            completionHandler(nil, nil, nil)
        }
    }
}
