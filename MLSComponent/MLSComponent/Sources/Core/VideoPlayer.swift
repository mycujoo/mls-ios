//
// Copyright © 2020 mycujoo. All rights reserved.
//

import AVFoundation
import YouboraAVPlayerAdapter
import YouboraLib

public class VideoPlayer: NSObject {

    // MARK: - Public properties

    public weak var delegate: PlayerDelegate?
    public private(set) var view: VideoPlayerView!

    public private(set) var state: State = .unknown {
        didSet {
            delegate?.playerDidUpdateState(player: self)
        }
    }

    /// Setting an Event will automatically switch the player over to the primary stream that is associated with this Event, if one is available.
    public var event: Event? {
        didSet {
            guard let stream = event?.stream else { return }

            replaceCurrentItem(url: stream.urls.first) { [weak self] completed in
                guard let self = self else { return }
                if completed {
                    if self.playerConfig.autoplay {
                        self.play()
                    }
                }
            }
        }
    }

    /// The current status of the player, based on the current item.
    public private(set) var status: Status = .pause {
        didSet {
            var buttonState: PlayButtonState
            switch status {
            case .play:
                buttonState = .pause
                player.play()
            case .pause:
                buttonState = .play
                player.pause()
            }

            if state == .ended {
                buttonState = .replay
            }
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.view.setPlayButtonTo(state: buttonState)
            }

            if oldValue != status {
                delegate?.playerDidUpdatePlaying(player: self)
            }
        }
    }

    #if os(iOS)
    /// This property changes when the fullscreen button is tapped. SDK implementors can update this state directly, which will update the visual of the button.
    /// Any value change will call the delegate's `playerDidUpdateFullscreen` method.
    public var isFullscreen: Bool = false {
        didSet {
            if isFullscreen != oldValue {
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    self.view.setFullscreenButtonTo(fullscreen: self.isFullscreen)
                }
                delegate?.playerDidUpdateFullscreen(player: self)
            }
        }
    }
    #endif

    /// Indicates whether the current item is a live stream.
    public var isLivestream: Bool {
        guard let duration = player.currentItem?.duration else {
            return false
        }
        let seconds = CMTimeGetSeconds(duration)
        return seconds.isNaN || seconds.isInfinite
    }

    public var currentTime: Double {
        (CMTimeGetSeconds(player.currentTime()) * 10).rounded() / 10
    }

    /// - returns: The duration (in seconds) of the currentItem. If unknown, returns 0.
    public var currentDuration: Double {
        guard let duration = player.currentItem?.duration else { return 0 }
        let seconds = CMTimeGetSeconds(duration)
        guard !seconds.isNaN else {
            // Live stream
            if let items = player.currentItem?.seekableTimeRanges {
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

    private(set) public var annotations: [Annotation] = [] {
        didSet {
            annotationManager.annotations = annotations
            annotationManager.evaluate(currentTime: currentTime, currentDuration: currentDuration)
            delegate?.playerDidUpdateAnnotations(player: self)
        }
    }

    // MARK: - Private properties

    private let player = MLSAVPlayer()
    private var annotationManager: AnnotationManager!
    private var timeObserver: Any?

    /// A private counter to help the skip buttons keep track of how much to seek by after the user stops pressing
    private var relativeSeekButtonCurrentAmount: Double = 0.0
    private lazy var relativeSeekDebouncer = Debouncer(minimumDelay: 0.4)

    private lazy var youboraPlugin: YBPlugin = {
        let options = YBOptions()
        options.accountCode = "mycujoo"
        options.username = "mls"
        let plugin = YBPlugin(options: options)
        plugin.adapter = YBAVPlayerAdapterSwiftTranformer.transform(from: YBAVPlayerAdapter(player: player))
        return plugin
    }()

    private var liveState: LiveState {
        if isLivestream {
            let currentTime = self.currentTime
            let currentDuration = self.currentDuration
            if currentDuration > 0 && currentTime + 15 >= currentDuration {
                return .liveAndLatest
            }
            return .liveNotLatest
        }
        return .notLive
    }

    // MARK: - Internal properties

    /// Setting the playerConfig will automatically updates the associated views and behavior.
    /// However, this should not be exposed to the SDK user directly, since it should only be configurable through the MLS console / API.
    var playerConfig = PlayerConfig.standard() {
        didSet {
            DispatchQueue.main.async { [weak self] in
                guard let `self` = self else { return }
                self.view.primaryColor = UIColor(hex: self.playerConfig.primaryColor)
                self.view.secondaryColor = UIColor(hex: self.playerConfig.secondaryColor)
                #if os(iOS)
                self.view.skipBackButton.isHidden = !self.playerConfig.showBackForwardsButtons
                self.view.skipForwardButton.isHidden = !self.playerConfig.showBackForwardsButtons
                #endif
            }
        }
    }

    /// Configures the tolerance with which the player seeks (for both `toleranceBefore` and `toleranceAfter`).
    var seekTolerance: CMTime = .positiveInfinity

    // MARK: - Methods

    public override init() {
        super.init()
        player.addObserver(self, forKeyPath: "status", options: .new, context: nil)
        player.addObserver(self, forKeyPath: "timeControlStatus", options: [.old, .new], context: nil)
        timeObserver = trackTime(with: player)

        func initPlayerView() {
            view = VideoPlayerView()
            view.setOnTimeSliderSlide(sliderUpdated)
            view.setOnTimeSliderRelease(sliderReleased)
            view.setOnPlayButtonTapped(playButtonTapped)
            #if os(iOS)
            view.setOnSkipBackButtonTapped(skipBackButtonTapped)
            view.setOnSkipForwardButtonTapped(skipForwardButtonTapped)
            view.setOnLiveButtonTapped(liveButtonTapped)
            view.setOnFullscreenButtonTapped(fullscreenButtonTapped)
            #endif
            view.drawPlayer(with: player)

            annotationManager = AnnotationManager(delegate: view!)
        }

        if Thread.isMainThread {
            initPlayerView()
        } else {
            DispatchQueue.main.sync {
                initPlayerView()
            }
        }

        youboraPlugin.fireInit()
    }

    deinit {
        if let timeObserver = timeObserver { player.removeTimeObserver(timeObserver) }
        player.removeObserver(self, forKeyPath: "status")
        player.removeObserver(self, forKeyPath: "timeControlStatus")
        youboraPlugin.fireStop()
    }

    /// Use this method instead of calling replaceCurrentItem() directly on the AVPlayer.
    /// - parameter callback: A callback that is called when the replacement is completed (true) or failed/cancelled (false).
    private func replaceCurrentItem(url: URL, callback: @escaping (Bool) -> ()) {
        relativeSeekButtonCurrentAmount = 0
        // TODO: generate the user-agent elsewhere.
        let headerFields: [String: String] = ["user-agent": "tv.mycujoo.mls.ios-sdk"]
        let asset = AVURLAsset(url: url, options: ["AVURLAssetHTTPHeaderFieldsKey": headerFields, "AVURLAssetPreferPreciseDurationAndTimingKey": true])
        asset.loadValuesAsynchronously(forKeys: ["playable"]) { [weak self] in
            guard let `self` = self else { return }

            var error: NSError?
            let status = asset.statusOfValue(forKey: "playable", error: &error)
            switch status {
            case .loaded:
                let playerItem = AVPlayerItem(asset: asset)
                DispatchQueue.main.async { [weak self] in
                    guard let `self` = self else { return }
                    self.player.replaceCurrentItem(with: playerItem)
                    callback(true)
                }
            default:
                callback(false)
            }
        }
    }
    
    //MARK: - KVO

    public override func observeValue(
        forKeyPath keyPath: String?,
        of object: Any?,
        change: [NSKeyValueChangeKey : Any]?,
        context: UnsafeMutableRawPointer?
    ) {
        switch keyPath {
        case "status":
            state = State(rawValue: player.status.rawValue) ?? .unknown
        case "timeControlStatus":
            if let change = change, let newValue = change[NSKeyValueChangeKey.newKey] as? Int, let oldValue = change[NSKeyValueChangeKey.oldKey] as? Int {
                let oldStatus = AVPlayer.TimeControlStatus(rawValue: oldValue)
                let newStatus = AVPlayer.TimeControlStatus(rawValue: newValue)
                if newStatus != oldStatus {
                    switch newStatus {
                    case .playing:
                        self.status = .play
                    case .paused:
                        self.status = .pause
                    default:
                        break
                    }

                    DispatchQueue.main.async { [weak self] in
                        if newStatus == .playing || newStatus == .paused {
                            self?.view.setBufferIcon(visible: false)
                        } else {
                            self?.view.setBufferIcon(visible: true)
                        }
                    }
                }
            }
        default:
            break
        }
    }
}

// MARK: - Public Methods
public extension VideoPlayer {

    func play() { status = .play }

    func pause() { status = .pause }

    func playVideo(with event: Event) {
        self.event = event
    }
}

// MARK: - Private Methods
extension VideoPlayer {
    /// - note: If nil is provided, an empty array is set on the annotations property of the player.
    func updateAnnotations(annotations: [Annotation]?) {
        self.annotations = annotations ?? []
    }

    private func trackTime(with player: AVPlayer) -> Any {
        player
            .addPeriodicTimeObserver(
                forInterval: CMTime(value: 1, timescale: 1),
                queue: .main) { [weak self] (progressTime) in
                    guard let self = self else { return }

                    // Do not process this while the player is seeking. It especially conflicts with the slider being dragged.
                    guard !self.player.isSeeking else { return }

                    let durationSeconds = self.currentDuration
                    let seconds = CMTimeGetSeconds(progressTime)

                    if !self.view.videoSlider.isTracking && self.relativeSeekButtonCurrentAmount == 0 {
                        self.updatePlaytimeIndicators(seconds, totalSeconds: durationSeconds, liveState: self.liveState)

                        if durationSeconds > 0 {
                            self.view.videoSlider.value = seconds / durationSeconds
                        }
                    }

                    if durationSeconds > 0 && durationSeconds <= seconds && !self.isLivestream {
                        self.state = .ended
                        self.view.setPlayButtonTo(state: .replay)
                    }

                    self.delegate?.playerDidUpdateTime(player: self)

                    self.annotationManager.evaluate(currentTime: seconds, currentDuration: durationSeconds)
        }
    }

    private func sliderUpdated(with fraction: Double) {
        let currentDuration = self.currentDuration
        guard currentDuration > 0 else { return }

        let elapsedSeconds = Float64(fraction) * currentDuration

        updatePlaytimeIndicators(elapsedSeconds, totalSeconds: currentDuration, liveState: self.liveState)
    }

    private func sliderReleased(with fraction: Double) {
        let currentDuration = self.currentDuration
        guard currentDuration > 0 else { return }

        let elapsedSeconds = Float64(fraction) * currentDuration

        updatePlaytimeIndicators(elapsedSeconds, totalSeconds: currentDuration, liveState: self.liveState)

        let seekTime = CMTime(value: Int64(min(currentDuration - 1, elapsedSeconds)), timescale: 1)
        player.seek(to: seekTime, toleranceBefore: seekTolerance, toleranceAfter: seekTolerance, debounceSeconds: 0.5, completionHandler: { [weak self] _ in
            self?.relativeSeekButtonCurrentAmount = 0

            #if os(tvOS)
            self?.play()
            #endif
        })
    }

    private func updatePlaytimeIndicators(_ elapsedSeconds: Double, totalSeconds: Double, liveState: LiveState) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.view.setTimeIndicatorLabel(elapsedText: self.formatSeconds(elapsedSeconds), totalText: self.formatSeconds(totalSeconds))
            self.view.setLiveButtonTo(state: liveState)
        }
    }

    private func formatSeconds(_ s: Double) -> String {
        if s >= 3600 {
            let hoursString = String(format: "%d", Int(s / 3600))
            let minutesString = String(format: "%02d", Int(s.truncatingRemainder(dividingBy: 3600) / 60))
            let secondsString = String(format: "%02d", Int(s.truncatingRemainder(dividingBy: 60)))

            return "\(hoursString):\(minutesString):\(secondsString)"
        } else {
            let minutesString = String(format: "%d", Int(s / 60))
            let secondsString = String(format: "%02d", Int(s.truncatingRemainder(dividingBy: 60)))

            return "\(minutesString):\(secondsString)"
        }
    }

    private func playButtonTapped() {
        if state != .ended {
            status.toggle()
        }
        else {
            player.seek(to: .zero, toleranceBefore: .zero, toleranceAfter: .zero) { [weak self] finished in
                if finished {
                    self?.relativeSeekButtonCurrentAmount = 0
                    self?.state = .readyToPlay
                    self?.play()
                }
            }
        }
    }

    #if os(iOS)
    /// Puts a seek operation on the `relativeSeekDebouncer`. If multiple calls happen within the debounce time, `relativeSeekButtonCurrentAmount` is increased (which is used to calculate the final seek position after debounce).
    private func relativeSeekWithDebouncer(amount: Double) {
        let currentDuration = self.currentDuration
        let currentTime = self.currentTime
        guard currentDuration > 0 else { return }

        self.relativeSeekButtonCurrentAmount += amount

        let expectedSeekTo = max(0, min(currentDuration - 1, currentTime + self.relativeSeekButtonCurrentAmount))

        // TODO: This is poorly implemented, because at this point, player.isSeeking is still `false`,
        // which means we set these UI values but they may be updated between now and the start of the actual seeking operation.
        view.videoSlider.value = expectedSeekTo / currentDuration
        updatePlaytimeIndicators(expectedSeekTo, totalSeconds: currentDuration, liveState: self.liveState)

        relativeSeekDebouncer.debounce { [weak self] in
            guard let self = self else { return }

            // Do not use the currentTime from outside this closure, since it may have been updated since then.
            // However, currentDuration can be used, since it's more expensive to obtain and doesn't change radically in this timespan.

            let seekAmount = self.relativeSeekButtonCurrentAmount
            let seekTo = max(0, min(currentDuration - 1, self.currentTime + seekAmount))

            self.player.seek(to: CMTime(seconds: seekTo, preferredTimescale: 1), toleranceBefore: self.seekTolerance, toleranceAfter: self.seekTolerance) { [weak self] completed in
                guard let self = self else { return }
                // Correct relativeSeekButtonCurrentAmount by how much was being seeked.
                // Do this (rather than setting to 0) because since the last seek was initiated, the debouncer may have been
                // triggered again, so setting to 0 would lead to a wrong seek operation on that one.
                self.relativeSeekButtonCurrentAmount -= seekAmount
                if completed {
                    self.play()
                }
            }
        }
    }

    private func skipBackButtonTapped() {
        relativeSeekWithDebouncer(amount: -10)
    }

    private func skipForwardButtonTapped() {
        relativeSeekWithDebouncer(amount: 10)
    }

    private func liveButtonTapped() {
        let currentDuration = self.currentDuration
        guard currentDuration > 0, self.liveState != .liveAndLatest else { return }

        view.videoSlider.value = 1.0
        updatePlaytimeIndicators(currentDuration, totalSeconds: currentDuration, liveState: .liveAndLatest)

        let seekTime = CMTime(value: Int64(currentDuration), timescale: 1)
        player.seek(to: seekTime, toleranceBefore: .zero, toleranceAfter: .zero) { [weak self] finished in
            if finished {
                self?.relativeSeekButtonCurrentAmount = 0
                self?.play()
            }
        }
    }

    private func fullscreenButtonTapped() {
        isFullscreen.toggle()
    }
    #endif
}

// MARK: - State
public extension VideoPlayer {
    enum State: Int {
        /// Indicates that the status of the player is not yet known because it has not tried to load new media resources for playback.
        case unknown = 0
        /// Indicates that the player is ready to play AVPlayerItem instances.
        case readyToPlay = 1
        /// Indicates that the player can no longer play AVPlayerItem instances because of an error. The error is described by the value of the player's error property.
        case failed = 2
        /// The player has finished playing the media
        case ended = 3
    }
}

// MARK: - Delegate
public protocol PlayerDelegate: AnyObject {
    /// The player has updated its playing status. To access the current status, see `VideoPlayer.status`
    func playerDidUpdatePlaying(player: VideoPlayer)
    /// The player has updated the elapsed time of the player. To access the current time, see `VideoPlayer.currentTime`
    func playerDidUpdateTime(player: VideoPlayer)
    /// The player has updated its state. To access the current state, see `VideoPlayer.state`
    func playerDidUpdateState(player: VideoPlayer)
    #if os(iOS) || os(tvOS)
    /// Gets called when the user enters or exits full-screen mode. There is no associated behavior with this other than the button-image changing;
    /// SDK implementers are responsible for any other visual or behavioral changes on the player.
    /// To manually override this state, set the desired value on `VideoPlayer.isFullscreen` (which will call the delegate again!)
    /// To hide the fullscreen button entirely, set `VideoPlayer.fullscreenButtonIsHidden`
    func playerDidUpdateFullscreen(player: VideoPlayer)
    #endif
    /// The player has updated the list of known annotations. To access the current list of known annotations for the associated timeline, see `VideoPlayer.annotations`
    /// - note: This does not have any relationship with the annotations that are currently being executed. This method is only called when the datasource refreshes.
    func playerDidUpdateAnnotations(player: VideoPlayer)
}
