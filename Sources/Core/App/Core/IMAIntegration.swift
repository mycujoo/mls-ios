//
// Copyright © 2021 mycujoo. All rights reserved.
//

import Foundation
import AVFoundation


public protocol IMAIntegration {
    /// Let's the IMAIntegration know what AVPlayer is being used by the VideoPlayer.
    func setAVPlayer(_ avPlayer: AVPlayer)

    /// Updates the IMAIntegration that a different stream was loaded into the player.
    /// - parameter eventId: The event id that was loaded (if it is available)
    /// - parameter streamId: The stream id that was loaded (if it is available) 
    func newStreamLoaded(eventId: String?, streamId: String?)

    /// Updates the IMAIntegration that the stream was ended.
    func streamEnded()

    /// Updates the IMAIntegration that there is an IMA ad unit known for this event.
    /// - note: Should be called *before* `newEventLoaded()`.
    func newAdUnitLoaded(_ adUnit: String?)
}

