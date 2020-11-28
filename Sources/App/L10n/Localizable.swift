//
// Copyright © 2020 mycujoo. All rights reserved.
//

import Foundation


enum L10n {
    enum Localizable {
        static let buttonTitleLive = makeNSLocalizedString("LIVE", tableName: "Localizable", bundles: [Bundle.l10nBundle], value: "LIVE", comment: "The text on a button that indicates that a stream is live")

        static let geoblockedError = makeNSLocalizedString("GEOBLOCKED_ERROR", tableName: "Localizable", bundles: [Bundle.l10nBundle], value: "This video cannot be watched in your area.", comment: "")

        static let missingEntitlementError = makeNSLocalizedString("MISSING_ENTITLEMENT_ERROR", tableName: "Localizable", bundles: [Bundle.l10nBundle], value: "Access to this video is restricted.", comment: "")

        static let internalError = makeNSLocalizedString("INTERNAL_ERROR", tableName: "Localizable", bundles: [Bundle.l10nBundle, Bundle.resourceBundle], value: "An error occurred. Please try again later.", comment: "")
    }
}

private extension L10n.Localizable {
    /// A method with the same signature as the `NSLocalizedString` init method, except it takes an array of bundles.
    /// This method will check all of those Bundles until it finds a matching key within the bundle.
    static func makeNSLocalizedString(_ key: String, tableName: String? = nil, bundles: [Bundle?], value: String = "", comment: String) -> String {
        var resolvedValue: String = ""
        for bundle in bundles {
            guard let bundle = bundle else { continue }
            resolvedValue = NSLocalizedString(key, tableName: tableName, bundle: bundle, value: value, comment: comment)

            if resolvedValue != value {
                // A value was found in a bundle because it does not match the standard value passed into NSLocalizedString.
                return resolvedValue
            }
        }
        // Return the value, because that is either the value we are looking for, or the fallback value when nothing else was found.
        return value
    }
}
