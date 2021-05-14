//
// Copyright © 2021 mycujoo. All rights reserved.
//

import Foundation
import MLSSDK

class GetTimelineActionsUpdatesUseCase {
    private let timelineRepository: MLSTimelineRepository

    init(timelineRepository: MLSTimelineRepository) {
        self.timelineRepository = timelineRepository
    }

    func start(id: String, completionHandler: @escaping (TimelineUpdate) -> ()) {
        timelineRepository.startTimelineUpdates(for: id) { update in
            switch update {
            case .actionsUpdated(let actions):
                completionHandler(.actionsUpdated(actions: actions))
            }
        }
    }

    func stop(id: String) {
        timelineRepository.stopTimelineUpdates(for: id)
    }
}

extension GetTimelineActionsUpdatesUseCase {
    enum TimelineUpdate {
        case actionsUpdated(actions: [AnnotationAction])
    }
}
