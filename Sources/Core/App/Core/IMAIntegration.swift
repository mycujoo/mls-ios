//
// Copyright © 2021 mycujoo. All rights reserved.
//

import Foundation
import AVFoundation


public protocol IMAIntegration {
    /// Let's the IMAIntegration know what AVPlayer is being used by the VideoPlayer.
    func setAVPlayer(_ avPlayer: AVPlayer)

    /// Sets the basic custom parameters that the IMA integration should always send as a part of the IMA ad tag.
    /// Custom parameters can be set through the implementation delegate itself.
    func setBasicCustomParameters(eventId: String?, streamId: String?, eventStatus: EventStatus?)

    /// Updates the IMAIntegration that there is an IMA ad unit known for this event.
    /// - note: Should be called *before* playing any ads.
    func setAdUnit(_ adUnit: String?)

    /// Updates the IMAIntegration that a stream will start shortly, and it is now free to play a preroll.
    /// This may not happen if a preroll ad is unavailable.
    /// - important: This will call `play()` on the VideoPlayer when it should take over again,
    ///   so there is no need to call `play()` separately from within the VideoPlayer.
    func playPreroll()

    /// Updates the IMAIntegration that the stream was ended, and it is now free to play a postroll.
    /// This may not happen if a postroll ad is unavailable.
    func playPostroll()

    /// Indicates whether the IMAIntegration is currently playing an ad or not (also returns true if an ad is loaded but paused).
    func isShowingAd() -> Bool

    /// Tells the IMAIntegration to pause the currently playing ad. Does nothing if there is no ad playing.
    func pause()

    /// Tells the IMAIntegration to continue playing the currently playing ad. Does nothing if there is no ad playing.
    func resume()
}

