//
// Copyright © 2020 mycujoo. All rights reserved.
//

import Foundation
import AVFoundation

/// A subclass of AVPlayer to improve visibility of such things as seeking states.
class MLSPlayer: AVPlayer, MLSPlayerProtocol {
    private(set) var isSeeking = false

    private(set) var isBuffering = false

    private let resourceLoaderQueue = DispatchQueue.global(qos: .background)

    private(set) var state: PlayerState = .unknown {
        didSet {
            stateObserverCallback?()
        }
    }

    /// The current time (in seconds) of the currentItem.
    var currentTime: Double {
        return (CMTimeGetSeconds(currentTime()) * 10).rounded() / 10
    }

    /// The current time (in seconds) that is expected after all pending seek operations are done on the currentItem.
    var optimisticCurrentTime: Double {
        return _seekingToTime ?? currentTime
    }

    var stateObserverCallback: (() -> Void)? = nil
    var timeObserverCallback: (() -> Void)? = nil
    var playObserverCallback: ((Bool) -> Void)? = nil

    /// A variable that keeps track of where the player is currently seeking to. Should be set to nil once a seek operation is done.
    private var _seekingToTime: Double? = nil

    /// A variable that keeps track of the highest duration that has been seen on this currentItem. This is needed because on live-streams,
    /// the player sometimes cannot calculate an accurate duration and the currentTime ends up being higher. In that scenario, the currentDuration
    /// assumes the value of currentTime (since that is the highest known value), which is fine, except when the user seeks back to a slightly earlier moment,
    /// in which case the duration magically jumps back to a lower value. To avoid this, this value stores the highest value seen by the user,
    /// and that is always assumed as a fallback.
    /// - important: This value should be reset whenever currentItem is replaced.
    private var _currentDurationMaximum: Double = 0.0 {
        didSet {
            _currentDurationMaximumObtainedOnItem = currentItem
        }
    }

    /// A helper to determine the highest maximum duration achieved on the currentItem.
    /// - seeAlso: `_currentDurationMaximum`
    private var _currentDurationMaximumObtainedOnItem: AVPlayerItem? = nil

    /// The duration (in seconds) of the currentItem. If unknown, returns 0.
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

                    // We must determine the currentDuration based on the known seekable range, but also fallback to the
                    // currentTime (which is sometimes higher on live streams). In that case, we must also consider previous
                    // currentTimes, which are sometimes higher (i.e. when the user seeked back).
                    // For more documentation on this, see `_currentDurationMaximum`
                    let v: Double = (currentItem != nil && currentItem!.isEqual(_currentDurationMaximumObtainedOnItem)) ? _currentDurationMaximum : 0.0

                    _currentDurationMaximum = max(v, max(currentTime, Double(startSeconds + durationSeconds)))

                    return _currentDurationMaximum
                }
            }
            return 0
        }

        return seconds
    }

    /// Indicates whether the current item is a live stream.
    var isLivestream: Bool {
        guard let duration = currentItem?.duration else {
            return false
        }
        let seconds = CMTimeGetSeconds(duration)
        return seconds.isNaN || seconds.isInfinite
    }

    /// Indicates whether the item that is currently loaded into the player has ended.
    var currentItemEnded: Bool {
        return currentDuration > 0 && currentDuration <= ceil(optimisticCurrentTime) && !isLivestream
    }

    var rawSegmentPlaylist: String? = nil

    private var isSeekingUpdatedAt = Date()

    private let seekDebouncer = Debouncer()

    private var timeObserver: Any?
    
    private weak var videoPlayer: VideoPlayer?

    override init() {
        super.init()

        addObserver(self, forKeyPath: "status", options: .new, context: nil)
        addObserver(self, forKeyPath: "timeControlStatus", options: [.old, .new], context: nil)
        timeObserver = trackTime(with: self)
    }
    
    /// This should be called by the VideoPlayer init method. This can be used to loop certain AVPlayer controls (e.g. play and pause) through the VideoPlayer.
    /// This is needed to make AVPlayerViewController work with our own VideoPlayer.
    func inject(_ videoPlayer: VideoPlayer) {
        self.videoPlayer = videoPlayer
    }
    
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

        _seekingToTime = (CMTimeGetSeconds(time) * 10).rounded() / 10

        isSeekingUpdatedAt = dateNow

        seekDebouncer.minimumDelay = debounceSeconds
        seekDebouncer.debounce { [weak self] in
            guard let self = self else { return }
            self.super_seek(to: time, toleranceBefore: toleranceBefore, toleranceAfter: toleranceAfter) { [weak self] b in
                guard let self = self else { return }
                if self.isSeekingUpdatedAt == dateNow {
                    self._seekingToTime = nil
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

        isSeekingUpdatedAt = dateNow

        seekDebouncer.minimumDelay = debounceSeconds
        seekDebouncer.debounce { [weak self] in
            guard let self = self else { return }
            self.super_seek(to: date) { [weak self] b in
                guard let self = self else { return }
                if self.isSeekingUpdatedAt == dateNow {
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
        guard currentDuration > 0 else { return }

        isSeeking = true
        let dateNow = Date()

        _seekingToTime = max(0, min(currentDuration - 1, optimisticCurrentTime + amount))

        isSeekingUpdatedAt = dateNow

        seekDebouncer.minimumDelay = debounceSeconds
        seekDebouncer.debounce { [weak self] in
            guard let self = self, let _seekingToTime = self._seekingToTime else { return }

            let seekTo = CMTime(seconds: _seekingToTime, preferredTimescale: 1)

            self.super_seek(to: seekTo, toleranceBefore: toleranceBefore, toleranceAfter: toleranceAfter) { [weak self] b in
                guard let self = self else { return }

                if self.isSeekingUpdatedAt == dateNow {
                    self._seekingToTime = nil
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
    
    private var loopingRateThroughVideoPlayer = false
    override var rate: Float {
        get {
            return super.rate
        }
        set {
            // The setter should be looped through the VideoPlayer, so that playback commands are always run through
            // VideoPlayer. This is needed e.g. in case AVPlayerViewController is used on tvOS, which has a play/pause
            // button that ties directly into AVPlayer. These commands should still land on VideoPlayer.
            if let videoPlayer = videoPlayer, !loopingRateThroughVideoPlayer {
                loopingRateThroughVideoPlayer = true
                videoPlayer.rate = newValue
            } else {
                setRate(newValue)
            }
        }
    }
    
    func setRate(_ rate: Float) {
        loopingRateThroughVideoPlayer = false
        super.rate = rate
    }

    /// Replace a current item with another AVPlayerItem that is asynchronously built from a URL.
    /// - parameter item: The item to play. If nil is provided, the current item is removed.
    /// - parameter headers: The headers to attach to the network requests when playing this item.
    /// - parameter resourceLoaderDelegate: The delegate for the asset's resourceLoader.
    /// - parameter callback: A callback that is called when the replacement is completed (true) or failed/cancelled (false).
    func replaceCurrentItem(with assetUrl: URL?, headers: [String: String], resourceLoaderDelegate: AVAssetResourceLoaderDelegate?, callback: @escaping (Bool) -> ()) {
        guard let assetUrl = assetUrl else {
            self.replaceCurrentItem(with: nil)
            callback(true)
            return
        }

        // Always clear the old item immediately, and update the state downstream.
        self.replaceCurrentItem(with: nil)
        timeObserverCallback?()
        stateObserverCallback?()
        playObserverCallback?(false)

        MLSPlayerNetworkInterceptor.register(withDelegate: self)

        let asset = AVURLAsset(url: MLSPlayerNetworkInterceptor.prepare(assetUrl), options: ["AVURLAssetHTTPHeaderFieldsKey": headers, "AVURLAssetPreferPreciseDurationAndTimingKey": true])
        asset.resourceLoader.setDelegate(resourceLoaderDelegate, queue: resourceLoaderQueue)
        
        asset.loadValuesAsynchronously(forKeys: ["playable"]) { [weak self] in
            guard let `self` = self else { return }

            var error: NSError?
            let status = asset.statusOfValue(forKey: "playable", error: &error)
            switch status {
            case .loaded:
                let playerItem = AVPlayerItem(asset: asset)
                DispatchQueue.main.async { [weak self] in
                    guard let `self` = self else { return }
                    self.replaceCurrentItem(with: playerItem)
                    callback(true)
                }
            default:
                callback(false)
            }
        }
    }

    private func trackTime(with player: MLSPlayerProtocol) -> Any {
        addPeriodicTimeObserver(forInterval: CMTimeMakeWithSeconds(1, preferredTimescale: 600), queue: .main) { [weak self] _ in
            guard let self = self else { return }

            self.timeObserverCallback?()
        }
    }

    override func observeValue(
        forKeyPath keyPath: String?,
        of object: Any?,
        change: [NSKeyValueChangeKey : Any]?,
        context: UnsafeMutableRawPointer?
    ) {
        switch keyPath {
        case "status":
            state = PlayerState(rawValue: status.rawValue) ?? .unknown
        case "timeControlStatus":
            if let change = change, let newValue = change[NSKeyValueChangeKey.newKey] as? Int, let oldValue = change[NSKeyValueChangeKey.oldKey] as? Int {
                let oldStatus = AVPlayer.TimeControlStatus(rawValue: oldValue)
                let newStatus = AVPlayer.TimeControlStatus(rawValue: newValue)
                if newStatus != oldStatus {
                    switch newStatus {
                    case .playing:
                        self.playObserverCallback?(true)
                    case .paused:
                        self.playObserverCallback?(false)
                    default:
                        break
                    }

                    if newStatus == .waitingToPlayAtSpecifiedRate && self.currentItem != nil {
                        self.isBuffering = true
                    } else {
                        self.isBuffering = false
                    }

                    self.timeObserverCallback?()
                }
            }
        default:
            break
        }
    }

    deinit {
        if let timeObserver = timeObserver { removeTimeObserver(timeObserver) }
        removeObserver(self, forKeyPath: "status")
        removeObserver(self, forKeyPath: "timeControlStatus")
    }
}

extension MLSPlayer: MLSPlayerNetworkInterceptorDelegate {
    func received(response: String, forRequestURL: URL?) {
        guard let lastPathComponent = forRequestURL?.lastPathComponent, lastPathComponent != "master.m3u8" else { return }
        self.rawSegmentPlaylist = response
    }
}
