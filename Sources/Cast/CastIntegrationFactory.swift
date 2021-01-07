//
// Copyright © 2021 mycujoo. All rights reserved.
//

import Foundation
import MLSSDK
import GoogleCast


public class CastIntegrationFactory {
    public static func build(delegate: CastIntegrationDelegate) -> CastIntegration {
        return CastIntegrationImpl(delegate: delegate)
    }
}
