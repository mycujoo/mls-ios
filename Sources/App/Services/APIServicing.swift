//
// Copyright © 2020 mycujoo. All rights reserved.
//

import Foundation


protocol APIServicing {
    func fetchEvent(byId id: String, callback: @escaping (Event?, Error?) -> ())
    func fetchEvents(pageSize: Int?, pageToken: String?, hasStream: Bool?, status: [ParamEventStatus]?, orderBy: ParamEventOrder?, callback: @escaping ([Event]?, Error?) -> ())
    func fetchAnnotationActions(byTimelineId timelineId: String, callback: @escaping ([AnnotationAction]?, Error?) -> ())
    func fetchPlayerConfig(byEventId eventId: String, callback: @escaping (PlayerConfig?, Error?) -> ())
}
