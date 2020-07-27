//
// Copyright © 2020 mycujoo. All rights reserved.
//

import Foundation


class GetAnnotationActionsForTimelineUseCase {
    private let annotationActionRepository: AnnotationActionRepository

    init(annotationActionRepository: AnnotationActionRepository) {
        self.annotationActionRepository = annotationActionRepository
    }

    func execute(timelineId: String, completionHandler: @escaping ([AnnotationAction]?, Error?) -> ()) {
        annotationActionRepository.fetchAnnotationActions(byTimelineId: timelineId) { (actions, error) in
            completionHandler(actions, error)
        }
    }
}
