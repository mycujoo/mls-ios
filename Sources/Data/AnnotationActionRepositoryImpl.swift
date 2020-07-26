//
// Copyright © 2020 mycujoo. All rights reserved.
//

import Foundation

class AnnotationActionRepositoryImpl: BaseRepositoryImpl, AnnotationActionRepository {
    func fetchAnnotationActions(byTimelineId timelineId: String, callback: @escaping ([AnnotationAction]?, Error?) -> ()) {
        _fetch(.annotations(timelineId), type: AnnotationActionWrapper.self) { (wrapper, err) in
            // TODO: Return the pagination tokens as well
            callback(wrapper?.actions, err)
        }
    }
}
