//
// Copyright © 2020 mycujoo. All rights reserved.
//

import Foundation
import AVFoundation

/// A subclass of AVPlayer to improve visibility of such things as seeking states.
class MLSAVPlayer: AVPlayer {
    var isSeeking = false
    private var isSeekingUpdatedAt = Date()

    private let seekThrottler = Throttler(minimumDelay: 0.3)

    override func seek(to time: CMTime) {
        self.seek(to: time, toleranceBefore: CMTime.positiveInfinity, toleranceAfter: CMTime.positiveInfinity, throttleSeconds: 0.0, completionHandler: { _ in })
    }

    override func seek(to time: CMTime, completionHandler: @escaping (Bool) -> Void) {
        self.seek(to: time, toleranceBefore: CMTime.positiveInfinity, toleranceAfter: CMTime.positiveInfinity, throttleSeconds: 0.0, completionHandler: completionHandler)
    }

    override func seek(to time: CMTime, toleranceBefore: CMTime, toleranceAfter: CMTime) {
        self.seek(to: time, toleranceBefore: toleranceBefore, toleranceAfter: toleranceAfter, throttleSeconds: 0.0, completionHandler: { _ in })
    }

    override func seek(to time: CMTime, toleranceBefore: CMTime, toleranceAfter: CMTime, completionHandler: @escaping (Bool) -> Void) {
        self.seek(to: time, toleranceBefore: toleranceBefore, toleranceAfter: toleranceAfter, throttleSeconds: 0.0, completionHandler: completionHandler)
    }

    override func seek(to date: Date) {
        self.seek(to: date, throttleSeconds: 0.0, completionHandler: { _ in })
    }

    override func seek(to date: Date, completionHandler: @escaping (Bool) -> Void) {
        self.seek(to: date, throttleSeconds: 0.0, completionHandler: completionHandler)
    }

    /// By using this method, the actual seek operation is throttled as long as there are more calls to this method coming in under the defined threshold.
    /// - note: `isSeeking` will be set to `true` even when the actual seek operation is still being throttled.
    func seek(to time: CMTime, throttleSeconds: Double, completionHandler: @escaping (Bool) -> Void) {
        seek(to: time, toleranceBefore: CMTime.positiveInfinity, toleranceAfter: CMTime.positiveInfinity, throttleSeconds: throttleSeconds, completionHandler: completionHandler)
    }

    /// By using this method, the actual seek operation is throttled as long as there are more calls to this method coming in under the defined threshold.
    /// - note: `isSeeking` will be set to `true` even when the actual seek operation is still being throttled.
    func seek(to time: CMTime, toleranceBefore: CMTime, toleranceAfter: CMTime, throttleSeconds: Double, completionHandler: @escaping (Bool) -> Void) {
        isSeeking = true
        let dateNow = Date()

        seekThrottler.throttle { [weak self] in
            guard let self = self else { return }
            self.isSeekingUpdatedAt = dateNow
            self.super_seek(to: time, toleranceBefore: toleranceBefore, toleranceAfter: toleranceAfter) { [weak self] b in
                guard let self = self else { return }
                if self.isSeekingUpdatedAt == dateNow {
                    self.isSeeking = false
                }
                completionHandler(b)
            }
        }
    }

    /// By using this method, the actual seek operation is throttled as long as there are more calls to this method coming in under the defined threshold.
    /// - note: `isSeeking` will be set to `true` even when the actual seek operation is still being throttled.
    func seek(to date: Date, throttleSeconds: Double, completionHandler: @escaping (Bool) -> Void) {
        isSeeking = true
        let dateNow = Date()

        seekThrottler.throttle { [weak self] in
            guard let self = self else { return }
            self.isSeekingUpdatedAt = dateNow
            self.super_seek(to: date) { [weak self] b in
                guard let self = self else { return }
                if self.isSeekingUpdatedAt == dateNow {
                    self.isSeeking = false
                }
                completionHandler(b)
            }
        }
    }

    /// Helper to avoid error: Using 'super' in a closure where 'self' is explicitly captured is not yet supported
    private func super_seek(to time: CMTime, toleranceBefore: CMTime, toleranceAfter: CMTime, completionHandler: @escaping (Bool) -> Void) {
        super.seek(to: time, toleranceBefore: toleranceBefore, toleranceAfter: toleranceAfter, completionHandler: completionHandler)
    }

    /// Helper to avoid error: Using 'super' in a closure where 'self' is explicitly captured is not yet supported
    private func super_seek(to date: Date, completionHandler: @escaping (Bool) -> Void) {
        super.seek(to: date, completionHandler: completionHandler)
    }
}
