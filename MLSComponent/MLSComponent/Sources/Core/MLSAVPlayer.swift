//
// Copyright © 2020 mycujoo. All rights reserved.
//

import Foundation
import AVFoundation

/// A subclass of AVPlayer to improve visibility of such things as seeking states.
class MLSAVPlayer: AVPlayer {
    private(set) var isSeeking = false

    /// - returns: The current time (in seconds) of the currentItem.
    var currentTime: Double {
        return (CMTimeGetSeconds(currentTime()) * 10).rounded() / 10
    }

    /// - returns: The current time (in seconds) that is expected after all pending seek operations are done on the currentItem.
    var optimisticCurrentTime: Double {
        // TODO: Include seek values
        if let _seekingToTime = _seekingToTime {
            return (CMTimeGetSeconds(_seekingToTime) * 10).rounded() / 10
        }
        return currentTime
    }

    /// A variable that keeps track of where the player is currently seeking to. Should be set to nil once a seek operation is done.
    private var _seekingToTime: CMTime? = nil

    /// - returns: The duration (in seconds) of the currentItem. If unknown, returns 0.
    var currentDuration: Double {
        guard let duration = currentItem?.duration else { return 0 }
        let seconds = CMTimeGetSeconds(duration)
        guard !seconds.isNaN else {
            // Live stream
            if let items = currentItem?.seekableTimeRanges {
                if !items.isEmpty {
                    let range = items[items.count - 1]
                    let timeRange = range.timeRangeValue
                    let startSeconds = CMTimeGetSeconds(timeRange.start)
                    let durationSeconds = CMTimeGetSeconds(timeRange.duration)

                    return max(currentTime, Double(startSeconds + durationSeconds))
                }

            }
            return 0
        }

        return seconds
    }

    private var isSeekingUpdatedAt = Date()

    private var relativeSeekAmount: Double = 0.0

    private let seekDebouncer = Debouncer()

    override func seek(to time: CMTime) {
        self.seek(to: time, toleranceBefore: CMTime.positiveInfinity, toleranceAfter: CMTime.positiveInfinity, debounceSeconds: 0.0, completionHandler: { _ in })
    }

    override func seek(to time: CMTime, completionHandler: @escaping (Bool) -> Void) {
        self.seek(to: time, toleranceBefore: CMTime.positiveInfinity, toleranceAfter: CMTime.positiveInfinity, debounceSeconds: 0.0, completionHandler: completionHandler)
    }

    override func seek(to time: CMTime, toleranceBefore: CMTime, toleranceAfter: CMTime) {
        self.seek(to: time, toleranceBefore: toleranceBefore, toleranceAfter: toleranceAfter, debounceSeconds: 0.0, completionHandler: { _ in })
    }

    override func seek(to time: CMTime, toleranceBefore: CMTime, toleranceAfter: CMTime, completionHandler: @escaping (Bool) -> Void) {
        self.seek(to: time, toleranceBefore: toleranceBefore, toleranceAfter: toleranceAfter, debounceSeconds: 0.0, completionHandler: completionHandler)
    }

    override func seek(to date: Date) {
        self.seek(to: date, debounceSeconds: 0.0, completionHandler: { _ in })
    }

    override func seek(to date: Date, completionHandler: @escaping (Bool) -> Void) {
        self.seek(to: date, debounceSeconds: 0.0, completionHandler: completionHandler)
    }

    /// By using this method, the actual seek operation is debounced as long as there are more calls to this method coming in under the defined threshold.
    /// - note: `isSeeking` will be set to `true` even when the actual seek operation is still being debounced.
    func seek(to time: CMTime, debounceSeconds: Double, completionHandler: @escaping (Bool) -> Void) {
        self.seek(to: time, toleranceBefore: CMTime.positiveInfinity, toleranceAfter: CMTime.positiveInfinity, debounceSeconds: debounceSeconds, completionHandler: completionHandler)
    }

    /// By using this method, the actual seek operation is debounced as long as there are more calls to this method coming in under the defined threshold.
    /// - note: `isSeeking` will be set to `true` even when the actual seek operation is still being debounced.
    func seek(to time: CMTime, toleranceBefore: CMTime, toleranceAfter: CMTime, debounceSeconds: Double, completionHandler: @escaping (Bool) -> Void) {
        isSeeking = true
        let dateNow = Date()

        _seekingToTime = time

        seekDebouncer.minimumDelay = debounceSeconds
        seekDebouncer.debounce { [weak self] in
            guard let self = self else { return }
            self.isSeekingUpdatedAt = dateNow
            self.super_seek(to: time, toleranceBefore: toleranceBefore, toleranceAfter: toleranceAfter) { [weak self] b in
                guard let self = self else { return }
                if self.isSeekingUpdatedAt == dateNow {
                    self._seekingToTime = nil
                    self.relativeSeekAmount = 0
                    self.isSeeking = false
                }
                completionHandler(b)
            }
        }
    }

    /// By using this method, the actual seek operation is debounced as long as there are more calls to this method coming in under the defined threshold.
    /// - note: `isSeeking` will be set to `true` even when the actual seek operation is still being debounced.
    func seek(to date: Date, debounceSeconds: Double, completionHandler: @escaping (Bool) -> Void) {
        isSeeking = true
        let dateNow = Date()

        seekDebouncer.minimumDelay = debounceSeconds
        seekDebouncer.debounce { [weak self] in
            guard let self = self else { return }
            self.isSeekingUpdatedAt = dateNow
            self.super_seek(to: date) { [weak self] b in
                guard let self = self else { return }
                if self.isSeekingUpdatedAt == dateNow {
                    self.relativeSeekAmount = 0
                    self.isSeeking = false
                }
                completionHandler(b)
            }
        }
    }

    /// Seek by a relative amount of time on the currentItem.
    /// - note: `isSeeking` will be set to `true` even when the actual seek operation is still being debounced.
    func seek(by amount: Double, toleranceBefore: CMTime, toleranceAfter: CMTime, debounceSeconds: Double, completionHandler: @escaping (Bool) -> Void) {
        let currentDuration = self.currentDuration
        let currentTime = self.currentTime
        guard currentDuration > 0 else { return }

        isSeeking = true
        let dateNow = Date()

        relativeSeekAmount += amount

        _seekingToTime = CMTime(seconds: max(0, min(currentDuration - 1, currentTime + relativeSeekAmount)), preferredTimescale: 1)

        seekDebouncer.minimumDelay = debounceSeconds
        seekDebouncer.debounce { [weak self] in
            guard let self = self else { return }
            self.isSeekingUpdatedAt = dateNow

            let seekAmount = self.relativeSeekAmount
            let seekTo = CMTime(seconds: max(0, min(currentDuration - 1, currentTime + seekAmount)), preferredTimescale: 1)

            self.super_seek(to: seekTo, toleranceBefore: toleranceBefore, toleranceAfter: toleranceAfter) { [weak self] b in
                guard let self = self else { return }

                if self.isSeekingUpdatedAt == dateNow {
                    self._seekingToTime = nil
                    self.isSeeking = false
                    self.relativeSeekAmount = 0
                } else {
                    self.relativeSeekAmount -= seekAmount
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
