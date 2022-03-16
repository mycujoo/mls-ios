//
// Copyright © 2020 mycujoo. All rights reserved.
//

import Foundation


class GetEventUpdatesUseCase {
    private let eventRepository: MLSEventRepository

    init(eventRepository: MLSEventRepository) {
        self.eventRepository = eventRepository
    }

    func start(id: String, completionHandler: @escaping (EventUpdate) -> ()) {
        eventRepository.startEventUpdates(for: id) { update in
            switch update {
            case .eventLiveViewers(let amount):
                completionHandler(.eventLiveViewers(amount: amount))
            case .eventUpdate(let updatedEvent):
                // TODO: Compare the updatedEvent with some properties of the current event (which may have to be an input param of this method).
                // That way, we don't do an update callback on every property change.
                completionHandler(.eventUpdate(event: updatedEvent))
            case .concurrencyLimitExceeded(let limit):
                completionHandler(.concurrencyLimitExceeded(limit: limit))
            case .errorAuthFailed:
                completionHandler(.errorAuthFailed)
            case .errorNotEntitled:
                completionHandler(.errorNotEntitled)
            }
        }
    }

    func stop(id: String) {
        eventRepository.stopEventUpdates(for: id)
    }
}

extension GetEventUpdatesUseCase {
    enum EventUpdate {
        case eventLiveViewers(amount: Int)
        case eventUpdate(event: Event)
        case concurrencyLimitExceeded(limit: Int)
        case errorAuthFailed
        case errorNotEntitled
    }
}
