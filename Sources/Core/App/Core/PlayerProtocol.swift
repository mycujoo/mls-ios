//
// Copyright © 2021 mycujoo. All rights reserved.
//

import Foundation
import AVFoundation


public protocol PlayerProtocol: class {
    var isMuted: Bool { get set }
    /// The duration (in seconds) of the currentItem. If unknown, returns 0.
    /// - seeAlso: `currentDurationAsCMTime`
    var currentDuration: Double { get }
    /// The duration reported by the currentItem, without any further manipulation. Typically, it is better to use `currentDuration`.
    var currentDurationAsCMTime: CMTime? { get }
    /// The current time (in seconds) of the currentItem.
    var currentTime: Double { get }
    /// The current item that is playing.
    var currentItem: AVPlayerItem? { get }
    /// The current time (in seconds) that is expected after all pending seek operations are done on the currentItem.
    var optimisticCurrentTime: Double { get }
    /// Whether the player is currently busy with a seeking operation, or is about to seek.
    var isSeeking: Bool { get }

    // MARK: AVPlayer methods
    func play()
    func pause()

    func seek(to time: CMTime, toleranceBefore: CMTime, toleranceAfter: CMTime, completionHandler: @escaping (Bool) -> Void)

    // MARK: MLSAVPlayer methods
    func seek(to time: CMTime, toleranceBefore: CMTime, toleranceAfter: CMTime, debounceSeconds: Double, completionHandler: @escaping (Bool) -> Void)
    func seek(by amount: Double, toleranceBefore: CMTime, toleranceAfter: CMTime, debounceSeconds: Double, completionHandler: @escaping (Bool) -> Void)
}
