//
// Copyright © 2020 mycujoo. All rights reserved.
//

import Foundation

class TimelineRepositoryImpl: BaseRepositoryImpl, TimelineRepository {
    func fetchAnnotationActions(byTimelineId timelineId: String, callback: @escaping ([AnnotationAction]?, Error?) -> ()) {
        _fetch(.annotations(timelineId), type: DataLayer.AnnotationActionWrapper.self) { (wrapper, err) in
            // TODO: Return the pagination tokens as well
            callback(wrapper?.actions.map { $0.toDomain }, err)
        }
    }

    func startTimelineUpdates(for timelineId: String, callback: @escaping (TimelineRepositoryTimelineUpdate) -> ()) {

    }

    func stopTimelineUpdates(for timelineId: String) {

    }
}
