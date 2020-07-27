//
// Copyright © 2020 mycujoo. All rights reserved.
//

import Foundation


protocol AnnotationActionRepository {
    func fetchAnnotationActions(byTimelineId timelineId: String, callback: @escaping ([AnnotationAction]?, Error?) -> ())
}
