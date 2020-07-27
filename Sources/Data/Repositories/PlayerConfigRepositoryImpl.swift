//
// Copyright © 2020 mycujoo. All rights reserved.
//

import Foundation


class PlayerConfigRepositoryImpl: BaseRepositoryImpl, PlayerConfigRepository {
    func fetchPlayerConfig(byEventId eventId: String, callback: @escaping (PlayerConfig?, Error?) -> ()) {
        _fetch(.playerConfig(eventId), type: DataLayer.PlayerConfig.self) { (config, err) in
            callback(config?.toDomain, err)
        }
    }
}
