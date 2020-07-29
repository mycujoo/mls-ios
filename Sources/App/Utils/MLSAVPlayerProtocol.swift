//
// Copyright © 2020 mycujoo. All rights reserved.
//

import Foundation
import AVFoundation


/// This protocol contains all the methods and properties that VideoPlayer access on the MLSAVPlayer object.
/// It exists with the distinct purpose of being able to mock the MLSAVPlayer in the VideoPlayer for easy testability.
protocol MLSAVPlayerProtocol: class {
    // MARK: AVPlayer properties
    var status: AVPlayer.Status { get }
    var isMuted: Bool { get set }

    // MARK: MLSAVPlayer properties
    /// The duration (in seconds) of the currentItem. If unknown, returns 0.
    /// - seeAlso: `currentDurationAsCMTime`
    var currentDuration: Double { get }
    /// The duration reported by the currentItem, without any further manipulation. Typically, it is better to use `currentDuration`.
    var currentDurationAsCMTime: CMTime? { get }
    /// The current time (in seconds) of the currentItem.
    var currentTime: Double { get }
    /// The current time (in seconds) that is expected after all pending seek operations are done on the currentItem.
    var optimisticCurrentTime: Double { get }
    /// Whether the player is currently busy with a seeking operation, or is about to seek.
    var isSeeking: Bool { get }

    // MARK: AVPlayer methods
    func play()
    func pause()
    func addObserver(_ observer: NSObject, forKeyPath keyPath: String, options: NSKeyValueObservingOptions, context: UnsafeMutableRawPointer?)
    func addPeriodicTimeObserver(forInterval interval: CMTime, queue: DispatchQueue?, using block: @escaping (CMTime) -> Void) -> Any
    func removeTimeObserver(_ observer: Any)
    func removeObserver(_ observer: NSObject, forKeyPath keyPath: String)
    func replaceCurrentItem(with assetUrl: URL, headers: [String: String], callback: @escaping (Bool) -> ())
    func seek(to time: CMTime, toleranceBefore: CMTime, toleranceAfter: CMTime, completionHandler: @escaping (Bool) -> Void)


    // MARK: MLSAVPlayer methods
    func seek(to time: CMTime, toleranceBefore: CMTime, toleranceAfter: CMTime, debounceSeconds: Double, completionHandler: @escaping (Bool) -> Void)
    func seek(by amount: Double, toleranceBefore: CMTime, toleranceAfter: CMTime, debounceSeconds: Double, completionHandler: @escaping (Bool) -> Void)

}
