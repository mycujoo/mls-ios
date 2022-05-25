//
// Copyright © 2020 mycujoo. All rights reserved.
//

import Foundation


enum L10n {
    enum Localizable {
        private static let bundles = [Bundle.mlsLocalizationBundle, Bundle.mlsResourceBundle]

        static let buttonTitleLive = makeNSLocalizedString("LIVE", tableName: "Localizable", bundles: bundles, value: "LIVE", comment: "The text on a button that indicates that a stream is live")

        static let geoblockedError = makeNSLocalizedString("GEOBLOCKED_ERROR", tableName: "Localizable", bundles: bundles, value: "This stream cannot be watched in your area.", comment: "")

        static let missingEntitlementError = makeNSLocalizedString("MISSING_ENTITLEMENT_ERROR", tableName: "Localizable", bundles: bundles, value: "Access to this stream is restricted.", comment: "")

        static let internalError = makeNSLocalizedString("INTERNAL_ERROR", tableName: "Localizable", bundles: bundles, value: "An error occurred. Please try again later.", comment: "")
        
        static let concurrencyLimitExceededTitle = makeNSLocalizedString("CONCURRENCY_LIMIT_TITLE", bundles: bundles,value: "Concurrency limit exceeded", comment: "Title for the concurrency limit exceeded error")
        
        static let concurrencyLimitExceededRawText = makeNSLocalizedString("CONCURRENCY_LIMIT_ERROR", bundles: bundles, value: "Concurrency limit of %@ has exceeded", comment: "Error for the concurrency limit exceed")
        
        static func numberOfLimitDevices(_ p1: Int) -> String {
            let format = NSLocalizedString(
                "number_of_limit_devices",
                bundle: Bundle.main,
                value: "number_of_limit_devices",
                comment: "DOES NOT NEED TO BE TRANSLATED.")
            
            return with(format, p1)
        }
        
        static func concurrencyLimitExceededError(_ p1: Int) -> String {
            return with(concurrencyLimitExceededRawText, numberOfLimitDevices(p1))
        }
    }
}

private extension L10n.Localizable {
    /// A method with the same signature as the `NSLocalizedString` init method, except it takes an array of bundles.
    /// This method will check all of those Bundles until it finds a matching key within the bundle.
    static func makeNSLocalizedString(_ key: String, tableName: String? = nil, bundles: [Bundle?], value: String = "", comment: String) -> String {
        var resolvedValue: String = ""
        var lastBundle: Bundle? = nil
        for bundle in bundles {
            guard lastBundle != bundle, let bundle = bundle else { continue }
            resolvedValue = NSLocalizedString(key, tableName: tableName, bundle: bundle, value: value, comment: comment)

            if resolvedValue != value {
                // A value was found in a bundle because it does not match the standard value passed into NSLocalizedString.
                return resolvedValue
            }

            lastBundle = bundle
        }
        // Return the value, because that is either the value we are looking for, or the fallback value when nothing else was found.
        return value
    }
}

extension L10n.Localizable {
    // In swift you cannot pass a variadic list to another variadic function.
    // https://bugs.swift.org/browse/SR-128
    static func with(_ localizedWithFormat: String, _ arg1: CVarArg) -> String {
        return String.localizedStringWithFormat(localizedWithFormat, arg1)
    }
}
