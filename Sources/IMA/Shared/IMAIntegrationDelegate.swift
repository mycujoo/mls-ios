//
// Copyright © 2021 mycujoo. All rights reserved.
//

import Foundation
import UIKit
import MLSSDK

public protocol IMAIntegrationDelegate: class {
    /// Should be implemented by the SDK user for IMA ads to be displayable.
    /// - returns: The UIViewController that is presenting the `VideoPlayer`.
    func presentingViewController(for videoPlayer: VideoPlayer) -> UIViewController?

    /// Should be implemented by the SDK user for IMA ads to be targetable to custom needs.
    /// This will populate the `custom_params` field in the IMA ad tag.
    /// If no extra parameters are needed, return an empty dictionary.
    func getCustomParameters(forItemIn videoPlayer: VideoPlayer) -> [String: String]

    /// Gets called when the video player starts playing an IMA ad.
    func imaAdStarted(for videoPlayer: VideoPlayer)

    /// Gets called when the video player stops playing an IMA ad.
    func imaAdStopped(for videoPlayer: VideoPlayer)
}
