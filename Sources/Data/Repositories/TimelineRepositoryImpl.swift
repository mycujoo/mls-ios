//
// Copyright © 2020 mycujoo. All rights reserved.
//

import Foundation
import Moya


class TimelineRepositoryImpl: BaseRepositoryImpl, TimelineRepository {
    let ws: WebSocketConnection

    init(api: MoyaProvider<API>, ws: WebSocketConnection) {
        self.ws = ws

        super.init(api: api)
    }

    func fetchAnnotationActions(byTimelineId timelineId: String, updateId: String?, callback: @escaping ([AnnotationAction]?, Error?) -> ()) {
        _fetch(.timelineActions(id: timelineId, updateId: nil), type: DataLayer.AnnotationActionWrapper.self) { (wrapper, err) in
            // TODO: Return the pagination tokens as well
            callback(wrapper?.actions.map { $0.toDomain }, err)
        }
    }

    func startTimelineUpdates(for timelineId: String, callback: @escaping (TimelineRepositoryTimelineUpdate) -> ()) {
        fetchAnnotationActions(byTimelineId: timelineId, updateId: nil) { [weak self] (actions, nil) in
            if let actions = actions {
                callback(.actionsUpdated(actions: actions))
            }

            self?.ws.subscribe(room: WebSocketConnection.Room(id: timelineId, type: .timeline)) { [weak self] update in
                switch update {
                case .timelineUpdate(let updateId):
                    // Fetch the timeline actions again and do the callback after that.
                    self?.fetchAnnotationActions(byTimelineId: timelineId, updateId: updateId, callback: { updatedActions, _ in
                        if let updatedActions = updatedActions {
                            callback(.actionsUpdated(actions: updatedActions))
                        }
                    })
                default:
                    break
                }
            }
        }
    }

    func stopTimelineUpdates(for timelineId: String) {

    }
}
