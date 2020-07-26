//
// Copyright © 2020 mycujoo. All rights reserved.
//

import Foundation

protocol EventsUseCase {
    func fetchEvent(byId id: String, callback: @escaping (Event?, Error?) -> ())
    func fetchEvents(pageSize: Int?, pageToken: String?, hasStream: Bool?, status: [ParamEventStatus]?, orderBy: ParamEventOrder?, callback: @escaping ([Event]?, Error?) -> ())
}
