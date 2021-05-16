//
// Copyright © 2020 mycujoo. All rights reserved.
//

import Foundation


class GetEventUseCase {
    private let eventRepository: MLSEventRepository

    init(eventRepository: MLSEventRepository) {
        self.eventRepository = eventRepository
    }

    func execute(id: String, completionHandler: @escaping (Event?, Error?) -> ()) {
        eventRepository.fetchEvent(byId: id, updateId: nil) { (event, error) in
            completionHandler(event, error)
        }
    }
}
