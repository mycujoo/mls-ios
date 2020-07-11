//
// Copyright © 2020 mycujoo. All rights reserved.
//

import Foundation

public class DataProvider {
    let apiService: APIServicing

    init(apiService: APIServicing) {
        self.apiService = apiService
    }

    /// Obtain a list of Events from the MLS API.
    /// - parameter completionHandler: gets called when the API response is available. Contains the desired list of Events, or nil if the request failed.
    public func eventList(completionHandler: @escaping ([Event]?) -> ()) {
        apiService.fetchEvents { (events, _) in
            if let events = events {
                completionHandler(events)
                return
            }
            completionHandler(nil)
        }
    }
}
