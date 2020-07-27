//
// Copyright © 2020 mycujoo. All rights reserved.
//

import Foundation


protocol PlayerConfigRepository {
    func fetchPlayerConfig(byEventId eventId: String, callback: @escaping (PlayerConfig?, Error?) -> ())
}
