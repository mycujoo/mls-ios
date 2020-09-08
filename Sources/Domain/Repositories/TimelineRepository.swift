//
// Copyright © 2020 mycujoo. All rights reserved.
//

import Foundation


protocol TimelineRepository {
    func fetchAnnotationActions(byTimelineId timelineId: String, updateId: String?, callback: @escaping ([AnnotationAction]?, Error?) -> ())

    func startTimelineUpdates(for timelineId: String, callback: @escaping (TimelineRepositoryTimelineUpdate) -> ())
    func stopTimelineUpdates(for timelineId: String)
}

/// An enum that represents updates on an Event
enum TimelineRepositoryTimelineUpdate {
    case actionsUpdated([AnnotationAction])
}

