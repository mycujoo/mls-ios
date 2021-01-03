//
// Copyright © 2021 mycujoo. All rights reserved.
//

import Foundation
import AVFoundation


public protocol IMAIntegration {
    /// Let's the IMAIntegration know what AVPlayer is being used by the VideoPlayer.
    func setAVPlayer(_ avPlayer: AVPlayer)

    /// Updates the IMAIntegration that a different stream was loaded into the player.
    func newStreamLoaded()

    /// Updates the IMAIntegration that the stream was ended.
    func streamEnded()

    /// Updates the IMAIntegration that there is an IMA tag known for this event.
    /// - note: Should be called *before* `newEventLoaded()`.
    func newIMATagLoaded(_ imaTag: String?)
}

