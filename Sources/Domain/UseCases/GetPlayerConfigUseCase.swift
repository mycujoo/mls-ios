//
// Copyright © 2020 mycujoo. All rights reserved.
//

import Foundation


class GetPlayerConfigUseCase {
    private let playerConfigRepository: PlayerConfigRepository

    init(playerConfigRepository: PlayerConfigRepository) {
        self.playerConfigRepository = playerConfigRepository
    }

    func execute(completionHandler: @escaping (PlayerConfig?, Error?) -> ()) {
        playerConfigRepository.fetchPlayerConfig { (config, error) in
            completionHandler(config, error)
        }
    }
}
