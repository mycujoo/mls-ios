//
// Copyright © 2021 mycujoo. All rights reserved.
//

import Foundation
import AVFoundation


public protocol PlayerProtocol: class {
    /// Indicates whether the Player is ready to play or not.
    var state: VideoPlayerState { get }

    var isMuted: Bool { get set }
    /// The duration (in seconds) of the currentItem. If unknown, returns 0.
    var currentDuration: Double { get }
    /// The current time (in seconds) of the currentItem.
    var currentTime: Double { get }
    /// The current time (in seconds) that is expected after all pending seek operations are done on the currentItem.
    var optimisticCurrentTime: Double { get }
    /// Whether the player is currently busy with a seeking operation, or is about to seek.
    var isSeeking: Bool { get }
    /// Whether the player is currently buffering or not.
    var isBuffering: Bool { get }
    /// Indicates whether the current item is a live stream.
    var isLivestream: Bool { get }
    /// Indicates whether the item that is currently loaded into the player has ended.
    var currentItemEnded: Bool { get }
    /// A callback that is called whenever the player's time-related properties are updated. Should be set by the owner of the player.
    var timeObserverCallback: (() -> Void)? { get set }
    /// A callback that is called whenever a the play/pause state is being updated (e.g. through a remote control).
    var playObserverCallback: ((_ isPlaying: Bool) -> Void)? { get set }

    // MARK: AVPlayer methods
    func play()
    func pause()

    func seek(to time: CMTime, toleranceBefore: CMTime, toleranceAfter: CMTime, completionHandler: @escaping (Bool) -> Void)

    // MARK: MLSAVPlayer methods
    func seek(to time: CMTime, toleranceBefore: CMTime, toleranceAfter: CMTime, debounceSeconds: Double, completionHandler: @escaping (Bool) -> Void)
    func seek(by amount: Double, toleranceBefore: CMTime, toleranceAfter: CMTime, debounceSeconds: Double, completionHandler: @escaping (Bool) -> Void)
}
