//
// Copyright © 2020 mycujoo. All rights reserved.
//

import Foundation


public protocol MLSTimelineRepository {
    func fetchAnnotationActions(byTimelineId timelineId: String, updateId: String?, callback: @escaping ([AnnotationAction]?, Error?) -> ())

    func startTimelineUpdates(for timelineId: String, callback: @escaping (MLSTimelineRepositoryTimelineUpdate) -> ())
    func stopTimelineUpdates(for timelineId: String)
}

/// An enum that represents updates on timeline Actions
public enum MLSTimelineRepositoryTimelineUpdate {
    case actionsUpdated(actions: [AnnotationAction])
}

