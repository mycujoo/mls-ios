//
// Copyright © 2021 mycujoo. All rights reserved.
//

import Foundation


public protocol CastIntegration: class {
    func initialize(_ videoPlayerDelegate: CastIntegrationVideoPlayerDelegate)

    /// Indicates whether this CastIntegration
    func isCasting() -> Bool

    /// Starts playback of an Event or Stream (both should be provided, where possible).
    func replaceCurrentItem(publicKey: String, pseudoUserId: String, event: MLSSDK.Event?, stream: MLSSDK.Stream?)

    /// Start or continue playback of the loaded stream.
    func play()

    /// Pause playback of the loaded stream.
    func pause()

    /// Seek to a position within the currentItem.
    /// - parameter to: The number of seconds within the currentItem to seek to.
    /// - parameter completionHandler: A closure that is called upon a completed seek operation.
    func seek(to: Double, completionHandler: @escaping (Bool) -> Void)
}

public protocol CastIntegrationVideoPlayerDelegate: class {
    /// Indicates that the `isCasting` state on the `CastIntegration` has updated to a different value.
    func isCastingStateUpdated()
}
