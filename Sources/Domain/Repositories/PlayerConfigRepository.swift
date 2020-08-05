//
// Copyright © 2020 mycujoo. All rights reserved.
//

import Foundation


protocol PlayerConfigRepository {
    func fetchPlayerConfig(callback: @escaping (PlayerConfig?, Error?) -> ())
}
