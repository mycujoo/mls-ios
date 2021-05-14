//
// Copyright © 2020 mycujoo. All rights reserved.
//

import Foundation


class PlayerConfigRepositoryImpl: BaseRepositoryImpl, MLSPlayerConfigRepository {
    func fetchPlayerConfig(callback: @escaping (PlayerConfig?, Error?) -> ()) {
        _fetch(.playerConfig, type: DataLayer.PlayerConfig.self) { (config, err) in
            callback(config?.toDomain, err)
        }
    }
}
