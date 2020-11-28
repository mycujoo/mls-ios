//
// Copyright © 2020 mycujoo. All rights reserved.
//

import Foundation


enum L10n {
    enum Localizable {
        static let buttonTitleLive = NSLocalizedString("LIVE", tableName: "Localizable", bundle: Bundle.l10nBundle, value: "LIVE", comment: "The text on a button that indicates that a stream is live")

        static let geoblockedError = NSLocalizedString("GEOBLOCKED_ERROR", tableName: "Localizable", bundle: Bundle.l10nBundle, value: "This video cannot be watched in your area.", comment: "")

        static let missingEntitlementError = NSLocalizedString("MISSING_ENTITLEMENT_ERROR", tableName: "Localizable", bundle: Bundle.l10nBundle, value: "Access to this video is restricted.", comment: "")

        static let internalError = NSLocalizedString("INTERNAL_ERROR", tableName: "Localizable", bundle: Bundle.l10nBundle, value: "An error occurred. Please try again later.", comment: "")
    }
}
