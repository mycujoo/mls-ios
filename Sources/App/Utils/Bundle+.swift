//
// Copyright © 2020 mycujoo. All rights reserved.
//

import Foundation

extension Bundle {
    static var resourceBundle: Bundle? {
        #if SWIFT_PACKAGE
        return Bundle.module
        #else
        let bundle = Bundle(for: MLS.self)
        guard let resourcesBundleUrl = bundle.resourceURL?.appendingPathComponent("MLSResources.bundle") else {
            // Fallback to the main bundle, which is only useful when compiling the framework directly.
            return bundle
        }
        return Bundle(url: resourcesBundleUrl) ?? bundle

        #endif
    }
}
