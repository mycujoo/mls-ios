//
// Copyright © 2020 mycujoo. All rights reserved.
//

import Foundation


extension Bundle {
    /// The Bundle that should be used for localization (language strings). It defaults to the `resourceBundle` value, but can be overwritten to a custom Bundle
    /// by the SDK user. This is useful when the SDK user decides to provide their own strings instead of the ones defined by the SDK.
    /// If this bundle does not contain a string that should be translated, it will fallback to resourceBundle (see: `L10n.Localizable`)
    /// - seeAlso: `L10n.Localizable`
    static var l10nBundle: Bundle = resourceBundle ?? Bundle.main // the fallback to Bundle.main is just to ensure there is a always a bundle.

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
