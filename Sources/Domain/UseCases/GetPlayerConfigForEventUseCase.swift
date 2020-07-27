//
// Copyright © 2020 mycujoo. All rights reserved.
//

import Foundation


class GetPlayerConfigForEventUseCase {
    private let playerConfigRepository: PlayerConfigRepository

    init(playerConfigRepository: PlayerConfigRepository) {
        self.playerConfigRepository = playerConfigRepository
    }

    func execute(eventId: String, completionHandler: @escaping (PlayerConfig?, Error?) -> ()) {
        playerConfigRepository.fetchPlayerConfig(byEventId: eventId) { (config, error) in
            completionHandler(config, error)
        }
    }
}
