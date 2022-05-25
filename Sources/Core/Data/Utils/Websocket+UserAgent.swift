//
// Copyright © 2022 mycujoo. All rights reserved.
//

import Foundation



extension WebSocket {
    convenience init(request: URLRequest, engine: Engine, addUserAgent: Bool = false) {
        self.init(request: request, engine: engine)
        self.request.addValue(UserAgentHeader().getDeviceInfo(), forHTTPHeaderField: "User-Agent")
    }
}
