//
// Copyright © 2021 mycujoo. All rights reserved.
//

import Foundation
import MLSSDK
import GoogleCast
import AVFoundation


class CastPlayer: NSObject, CastPlayerProtocol {    
    var state: PlayerState = .unknown {
        didSet {
            stateObserverCallback?()
        }
    }

    // Will be updated by `updateMediaStatus`
    var isBuffering: Bool = false

    // Will be updated by `updateTimerState`
    var isLivestream: Bool = false

    var currentItemEnded: Bool {
        return currentDuration > 0 && currentDuration <= ceil(optimisticCurrentTime) && !isLivestream
    }

    var isMuted: Bool {
        get {
            return GCKCastContext.sharedInstance().sessionManager.currentSession?.currentDeviceMuted ?? false
        }
        set {
            GCKCastContext.sharedInstance().sessionManager.currentSession?.setDeviceMuted(newValue)
        }
    }

    // Will be updated by `updateTimerState`
    var currentDuration: Double = 0

    // Will be updated by `updateTimerState`
    var currentTime: Double = 0

    /// The current time (in seconds) that is expected after all pending seek operations are done on the currentItem.
    var optimisticCurrentTime: Double {
        return _seekingToTime ?? currentTime
    }

    var stateObserverCallback: (() -> Void)? = nil
    var timeObserverCallback: (() -> Void)? = nil
    var playObserverCallback: ((Bool) -> Void)? = nil // TODO: call this at the appropriate times

    private(set) var isSeeking = false
    
    private var isPlaying = false

    private static let encoder = JSONEncoder()

    private let seekDebouncer = Debouncer()

    private var isSeekingUpdatedAt = Date()

    /// A variable that keeps track of where the player is currently seeking to. Should be set to nil once a seek operation is done.
    private var _seekingToTime: Double? = nil

    private var updateTimeTimer: Timer? = nil

    /// Tells the `updateTimerState` whether it's being loaded for the first time for the currently playing item.
    /// Should be reset every time the playing item changes.
    private var isFirstTimerStateUpdate = true

    override init() {}

    func initialize() {
        self.updateMediaStatus(GCKCastContext.sharedInstance().sessionManager.currentSession?.remoteMediaClient?.mediaStatus)
    }
    
    var rate: Float {
        get {
            return isPlaying ? 1 : 0
        }
    }
    
    func setRate(_ rate: Float) {
        if rate > 0 {
            if let mediaStatus = GCKCastContext.sharedInstance().sessionManager.currentSession?.remoteMediaClient?.mediaStatus, let _ = mediaStatus.currentQueueItem {
                GCKCastContext.sharedInstance().sessionManager.currentSession?.remoteMediaClient?.play()
            }
        } else {
            GCKCastContext.sharedInstance().sessionManager.currentSession?.remoteMediaClient?.pause()
        }
    }
    
    private func startUpdatingTime() {
        isFirstTimerStateUpdate = true

        let execute: () -> () = { [weak self] () in
            self?.updateTimerState()
        }

        updateTimeTimer?.invalidate()
        DispatchQueue.global(qos: .background).async { [weak self] () in
            execute()
            let timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { _ in
                execute()
            })
            let runLoop = RunLoop.current
            runLoop.add(timer, forMode: .default)
            runLoop.run()

            self?.updateTimeTimer = timer
        }
    }

    func stopUpdatingTime() {
        updateTimeTimer?.invalidate()
        updateTimeTimer = nil
    }

    func replaceCurrentItem(publicKey: @escaping () -> String?, identityToken: @escaping () -> String?, pseudoUserId: String, event: MLSSDK.Event?, stream: MLSSDK.Stream?, completionHandler: @escaping (Bool) -> Void) {
        struct ReceiverCustomData: Codable {
            var publicKey: String? = nil
            var identityToken: String? = nil
            var pseudoUserId: String? = nil
            var eventId: String? = nil
            // This should only be sent when there is no known eventId (i.e. when non-MCLS based content is being played)
            var customPlaylistUrl: String? = nil
        }

        // The player must have a stream url. If not, it moves into a failed state and blocks the player altogether.
        guard let stream = stream, let url = stream.url else { return }

        let metadata = GCKMediaMetadata()
        metadata.setString(event?.title ?? "", forKey: kGCKMetadataKeyTitle)
        metadata.setString(event?.descriptionText ?? "", forKey: kGCKMetadataKeySubtitle)

        let mediaInfoBuilder = GCKMediaInformationBuilder()
        mediaInfoBuilder.contentURL = url
        mediaInfoBuilder.streamType = .none
        mediaInfoBuilder.contentType = "video/m3u"
        mediaInfoBuilder.metadata = metadata

        if let eventId = event?.id,
           let data = try? (CastPlayer.encoder.encode(ReceiverCustomData(publicKey: publicKey(), identityToken: identityToken(), pseudoUserId: pseudoUserId, eventId: eventId, customPlaylistUrl: stream.isNativeMLS ? nil : url))),
           let json = (try? JSONSerialization.jsonObject(with: data, options: .allowFragments)) {
            mediaInfoBuilder.customData = json
        }

        stopUpdatingTime()
        updateTimerState(forceReset: true)

        state = .unknown

        let request = GCKCastContext.sharedInstance().sessionManager.currentSession?.remoteMediaClient?.loadMedia(mediaInfoBuilder.build())
        let requestWrapper = CastGCKRequestHandler {} completionHandler: { [weak self] () in
            self?.state = .readyToPlay
            self?.startUpdatingTime()
            completionHandler(true)
        } failureHandler: { [weak self] () in
            self?.state = .failed

            GCKCastContext.sharedInstance().sessionManager.currentCastSession?.end(with: .stopCasting)

            completionHandler(false)
        } abortionHandler: {
            completionHandler(false)
        }
        request?.delegate = requestWrapper
    }

    func seek(to time: CMTime, toleranceBefore: CMTime, toleranceAfter: CMTime, completionHandler: @escaping (Bool) -> Void) {
        self.seek(to: time, toleranceBefore: toleranceBefore, toleranceAfter: toleranceAfter, debounceSeconds: 0.0, completionHandler: completionHandler)
    }

    func seek(to time: CMTime, toleranceBefore: CMTime, toleranceAfter: CMTime, debounceSeconds: Double, completionHandler: @escaping (Bool) -> Void) {
        isSeeking = true
        let dateNow = Date()

        _seekingToTime = (CMTimeGetSeconds(time) * 10).rounded() / 10

        isSeekingUpdatedAt = dateNow

        seekDebouncer.minimumDelay = debounceSeconds
        seekDebouncer.debounce { [weak self] in
            guard let self = self else { return }

            let seekOptions = GCKMediaSeekOptions()
            seekOptions.interval = CMTimeGetSeconds(time)
            seekOptions.resumeState = .unchanged

            let completionHandler_: (Bool) -> Void = {  [weak self] b in
                guard let self = self else { return }
                if self.isSeekingUpdatedAt == dateNow {
                    self._seekingToTime = nil
                    self.isSeeking = false
                }

                completionHandler(b)
            }

            let request = GCKCastContext.sharedInstance().sessionManager.currentSession?.remoteMediaClient?.seek(with: seekOptions)
            let requestWrapper = CastGCKRequestHandler {} completionHandler: {
                completionHandler_(true)
            } failureHandler: {
                completionHandler_(false)
            } abortionHandler: {
                completionHandler_(false)
            }

            // requestWrapper is not weakly retained because `CastGCKRequestHandler` statically retains it as long as needed.
            request?.delegate = requestWrapper
        }
    }

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

            let seekOptions = GCKMediaSeekOptions()
            seekOptions.interval = _seekingToTime
            seekOptions.resumeState = .unchanged

            let completionHandler_: (Bool) -> Void = {  [weak self] b in
                guard let self = self else { return }
                if self.isSeekingUpdatedAt == dateNow {
                    self._seekingToTime = nil
                    self.isSeeking = false
                }

                completionHandler(b)
            }

            let request = GCKCastContext.sharedInstance().sessionManager.currentSession?.remoteMediaClient?.seek(with: seekOptions)
            let requestWrapper = CastGCKRequestHandler {} completionHandler: {
                completionHandler_(true)
            } failureHandler: {
                completionHandler_(false)
            } abortionHandler: {
                completionHandler_(false)
            }

            // requestWrapper is not weakly retained because `CastGCKRequestHandler` statically retains it as long as needed.
            request?.delegate = requestWrapper
        }
    }

    func updateMediaStatus(_ mediaStatus: GCKMediaStatus?) {
        guard let mediaStatus = mediaStatus else { return }
        switch(mediaStatus.playerState) {
        case .buffering, .loading, .unknown:
            self.isBuffering = true
        case .playing:
            self.isBuffering = false
            self.isPlaying = true
            playObserverCallback?(true)
        case .paused:
            self.isPlaying = false
            self.isBuffering = false
            playObserverCallback?(false)
        default:
            self.isBuffering = false
        }

        updateTimerState()
    }

    /// - parameter forceReset: If true, it will send default values to the observer. Useful only for resetting whenever a new stream is about to begin.
    private func updateTimerState(forceReset: Bool = false) {
        guard !forceReset else {
            self.isLivestream = false
            self.currentDuration = 0
            self.currentTime = 0
            self._seekingToTime = nil
            self.timeObserverCallback?()
            return
        }

        if isFirstTimerStateUpdate {
            isFirstTimerStateUpdate = false

            if let duration = GCKCastContext.sharedInstance().sessionManager.currentSession?.remoteMediaClient?.mediaStatus?.mediaInformation?.streamDuration {
                self.isLivestream = duration.isInfinite || duration < 0
                self.currentDuration = self.isLivestream ? 0 : duration
            }
        }

        if let currentTime = GCKCastContext.sharedInstance().sessionManager.currentSession?.remoteMediaClient?.approximateStreamPosition() {
            self.currentTime = currentTime.isFinite ? floor(currentTime) : 0
        }

        if self.isLivestream {
            if let start = GCKCastContext.sharedInstance().sessionManager.currentSession?.remoteMediaClient?.approximateLiveSeekableRangeStart(),
            let end = GCKCastContext.sharedInstance().sessionManager.currentSession?.remoteMediaClient?.approximateLiveSeekableRangeEnd(),
            !start.isNaN, !end.isNaN {
                self.currentDuration = end - start
            }
            else {
                // Should not happen, this is just a fallback.
                self.currentDuration = self.currentTime
            }
        }

        self.timeObserverCallback?()
    }
}
