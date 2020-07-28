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
    var currentItem: AVPlayerItem? { get }

    // MARK: MLSAVPlayer properties
    var currentDuration: Double { get }
    var currentTime: Double { get }
    var optimisticCurrentTime: Double { get }
    var isSeeking: Bool { get }

    // MARK: AVPlayer methods
    func play()
    func pause()
    func addObserver(_ observer: NSObject, forKeyPath keyPath: String, options: NSKeyValueObservingOptions, context: UnsafeMutableRawPointer?)
    func addPeriodicTimeObserver(forInterval interval: CMTime, queue: DispatchQueue?, using block: @escaping (CMTime) -> Void) -> Any
    func removeTimeObserver(_ observer: Any)
    func removeObserver(_ observer: NSObject, forKeyPath keyPath: String)
    func replaceCurrentItem(with item: AVPlayerItem?)
    func seek(to time: CMTime, toleranceBefore: CMTime, toleranceAfter: CMTime, completionHandler: @escaping (Bool) -> Void)


    // MARK: MLSAVPlayer methods
    func seek(to time: CMTime, toleranceBefore: CMTime, toleranceAfter: CMTime, debounceSeconds: Double, completionHandler: @escaping (Bool) -> Void)
    func seek(by amount: Double, toleranceBefore: CMTime, toleranceAfter: CMTime, debounceSeconds: Double, completionHandler: @escaping (Bool) -> Void)

}
