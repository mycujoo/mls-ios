//
// Copyright © 2020 mycujoo. All rights reserved.
//

import Foundation

public class DataProvider {
    let listEventsUseCase: ListEventsUseCase

    init(listEventsUseCase: ListEventsUseCase) {
        self.listEventsUseCase = listEventsUseCase
    }

    /// Obtain a list of Events from the MLS API.
    /// - parameter completionHandler: gets called when the API response is available. Contains the desired list of Events, or nil if the request failed.
    public func eventList(pageSize: Int? = nil, pageToken: String? = nil, hasStream: Bool? = nil, status: [ParamEventStatus]? = nil, orderBy: ParamEventOrder? = nil, completionHandler: @escaping ([Event]?) -> ()) {
        listEventsUseCase.execute(pageSize: pageSize, pageToken: pageToken, hasStream: hasStream, status: status, orderBy: orderBy) { (events, _) in
            if let events = events {
                completionHandler(events)
                return
            }
            completionHandler(nil)
        }
    }
}
