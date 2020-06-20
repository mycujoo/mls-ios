//
// Copyright © 2020 mycujoo. All rights reserved.
//

import Foundation

extension Bundle {
    static var resourceBundle: Bundle? {
        let bundle = Bundle(for: MLS.self)
        guard let resourcesBundleUrl = bundle.resourceURL?.appendingPathComponent("MLSResources.bundle") else {
            return nil
        }
        return Bundle(url: resourcesBundleUrl)
    }
}
