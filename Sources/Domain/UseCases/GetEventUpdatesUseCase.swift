//
// Copyright © 2020 mycujoo. All rights reserved.
//

import Foundation


class GetEventUpdatesUseCase {
    private let eventRepository: EventRepository

    init(eventRepository: EventRepository) {
        self.eventRepository = eventRepository
    }

    func start(id: String, completionHandler: @escaping (EventUpdate) -> ()) {
        eventRepository.startEventUpdates(for: id) { update in
            switch update {
            case .eventTotal(let total):
                completionHandler(.eventTotal(total: total))
            case .eventUpdate(let event):
                completionHandler(.eventUpdate(event: event))
            }
        }
    }

    func stop(id: String) {
        eventRepository.stopEventUpdates(for: id)
    }
}

extension GetEventUpdatesUseCase {
    enum EventUpdate {
        case eventTotal(total: Int)
        case eventUpdate(event: Event)
    }
}
