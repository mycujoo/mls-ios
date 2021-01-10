//
// Copyright © 2021 mycujoo. All rights reserved.
//

import Foundation
import MLSSDK
import GoogleCast


public class CastIntegrationFactory {
    /// - parameter delegate: The delegate that should be used for this CastIntegration.
    /// - parameter customReceiverAppId: If you do not wish to use the standard MCLS receiver app, you can provide a customer identifier here.
    ///   It is recommended to leave this to `nil`, as the experience has been optimized for the MCLS receiver app.
    /// - note: `customReceiverAppId` only has any effect on the first initialization of this class, since that is when the Chromecast context is built.
    ///   On initializations after that, the existing Chromecast context is used, and so this will not have any effect.
    public static func build(delegate: CastIntegrationDelegate, customReceiverAppId: String? = nil) -> CastIntegration {
        return CastIntegrationImpl(delegate: delegate, customReceiverAppId: customReceiverAppId)
    }
}
