//
// Copyright © 2020 mycujoo. All rights reserved.
//

import Foundation


public protocol MLSPlayerConfigRepository {
    func fetchPlayerConfig(callback: @escaping (PlayerConfig?, Error?) -> ())
}
