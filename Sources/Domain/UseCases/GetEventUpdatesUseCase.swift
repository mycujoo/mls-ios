//
// Copyright © 2020 mycujoo. All rights reserved.
//

import Foundation


class GetEventUpdatesUseCase {
    private let eventRepository: EventRepository

    init(eventRepository: EventRepository) {
        self.eventRepository = eventRepository
    }

    func start(id: String, pseudoUserId: String, completionHandler: @escaping (EventUpdate) -> ()) {
        eventRepository.startEventUpdates(for: id, pseudoUserId: pseudoUserId) { update in
            switch update {
            case .eventLiveViewers(let amount):
                completionHandler(.eventLiveViewers(amount: amount))
            case .eventUpdate(let updatedEvent):
                // TODO: Compare the updatedEvent with some properties of the current event (which may have to be an input param of this method).
                // That way, we don't do an update callback on every property change.
                completionHandler(.eventUpdate(event: updatedEvent))
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
    }
}
