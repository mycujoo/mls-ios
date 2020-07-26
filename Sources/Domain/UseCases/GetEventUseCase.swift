//
// Copyright © 2020 mycujoo. All rights reserved.
//

import Foundation


class GetEventUseCase {
    private let eventRepository: EventRepository

    init(eventRepository: EventRepository) {
        self.eventRepository = eventRepository
    }

    func execute(id: String, completionHandler: @escaping (Event?, Error?) -> ()) {
        eventRepository.fetchEvent(byId: id) { (event, error) in
            completionHandler(event, error)
        }
    }
}
