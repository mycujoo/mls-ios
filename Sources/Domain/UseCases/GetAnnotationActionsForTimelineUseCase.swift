//
// Copyright © 2020 mycujoo. All rights reserved.
//

import Foundation


class GetAnnotationActionsForTimelineUseCase {
    private let timelineRepository: TimelineRepository

    init(timelineRepository: TimelineRepository) {
        self.timelineRepository = timelineRepository
    }

    func execute(timelineId: String, completionHandler: @escaping ([AnnotationAction]?, Error?) -> ()) {
        timelineRepository.fetchAnnotationActions(byTimelineId: timelineId) { (actions, error) in
            completionHandler(actions, error)
        }
    }
}
