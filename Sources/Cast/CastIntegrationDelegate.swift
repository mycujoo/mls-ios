//
// Copyright © 2021 mycujoo. All rights reserved.
//

import Foundation
import MLSSDK
import GoogleCast


public protocol CastIntegrationDelegate: class {
    /// Should be implemented by the SDK user. Should return a UIView to which this SDK can add the Google Cast mini-controller as a subview. Nil if the mini controller is not desired.
    func getMiniControllerParentView() -> UIView?

    /// Should be implemented by the SDK user. Should return a UIView to which this SDK can add the Google Cast button.
    /// - note:  It is recommended that the SDK user places this UIView inside the `topTrailingControlsStackView` UIStackView on the VideoPlayer.
    func getCastButtonParentView() -> UIView
}
