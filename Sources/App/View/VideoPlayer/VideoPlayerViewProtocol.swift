//
// Copyright © 2020 mycujoo. All rights reserved.
//

import Foundation
import AVFoundation
import UIKit


public protocol VideoPlayerViewPublicProtocol: class {
    var playerLayer: AVPlayerLayer? { get }
}

protocol VideoPlayerViewInternalProtocol: class {
    /// The color that is used throughout various controls and elements of the video player, together with the `secondaryColor`.
    var primaryColor: UIColor { get set }
    /// The color that is used throughout various controls and elements of the video player, together with the `primaryColor`.
    var secondaryColor: UIColor { get set }
    /// Whether the controlView has an alpha value of more than zero (0) or not.
    var controlViewHasAlpha: Bool { get }
    /// Whether the infoView has an alpha value of more than zero (0) or not.
    var infoViewHasAlpha: Bool { get }

    var playButton: UIButton { get }
}
