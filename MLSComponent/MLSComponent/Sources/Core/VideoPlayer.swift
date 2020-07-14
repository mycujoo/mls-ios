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
    /// - note: This sets `stream` to nil.
    public var event: Event? {
        didSet {
            if stream != nil {
                stream = nil
            }
            rebuild()
        }
    }

    /// Setting a Stream will automatically switch the player over to this stream.
    /// - note: This sets `event` to nil.
    public var stream: Stream? {
        didSet {
            if event != nil {
                event = nil
            }
            rebuild()
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

    /// - returns: The current time (in seconds) of the currentItem.
    public var currentTime: Double {
        return player.currentTime
    }

    /// - returns: The current time (in seconds) that is expected after all pending seek operations are done on the currentItem.
    public var optimisticCurrentTime: Double {
        return player.optimisticCurrentTime
    }

    /// - returns: The duration (in seconds) of the currentItem. If unknown, returns 0.
    public var currentDuration: Double {
        return player.currentDuration
    }

    private(set) public var annotations: [Annotation] = [] {
        didSet {
            evaluateAnnotations()
        }
    }

    // MARK: - Private properties

    private let player = MLSAVPlayer()
    private var apiService: APIServicing
    private let annotationService: AnnotationServicing
    private var timeObserver: Any?

    private lazy var controlViewDebouncer = Debouncer(minimumDelay: 4.0)
    private lazy var relativeSeekDebouncer = Debouncer(minimumDelay: 0.4)

    private lazy var youboraPlugin: YBPlugin = {
        let options = YBOptions()
        options.accountCode = "mycujoo"
        options.username = "mls"
        let plugin = YBPlugin(options: options)
        plugin.adapter = YBAVPlayerAdapterSwiftTranformer.transform(from: YBAVPlayerAdapter(player: player))
        return plugin
    }()

    // TODO: Move livestate to mlsavplayer?
    private var liveState: LiveState {
        if isLivestream {
            let optimisticCurrentTime = self.optimisticCurrentTime
            let currentDuration = self.currentDuration
            if currentDuration > 0 && optimisticCurrentTime + 15 >= currentDuration {
                return .liveAndLatest
            }
            return .liveNotLatest
        }
        return .notLive
    }

    private var activeOverlayIds: Set<String> = Set()

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

    init(apiService: APIServicing, annotationService: AnnotationServicing) {
        self.apiService = apiService
        self.annotationService = annotationService

        super.init()

        player.addObserver(self, forKeyPath: "status", options: .new, context: nil)
        player.addObserver(self, forKeyPath: "timeControlStatus", options: [.old, .new], context: nil)
        timeObserver = trackTime(with: player)

        func initPlayerView() {
            view = VideoPlayerView()
            view.setOnTimeSliderSlide(sliderUpdated)
            view.setOnTimeSliderRelease(sliderReleased)
            view.setOnPlayButtonTapped(playButtonTapped)
            view.setOnSkipBackButtonTapped(skipBackButtonTapped)
            view.setOnSkipForwardButtonTapped(skipForwardButtonTapped)
            #if os(iOS)
            view.setOnControlViewTapped(controlViewTapped)
            view.setOnLiveButtonTapped(liveButtonTapped)
            view.setOnFullscreenButtonTapped(fullscreenButtonTapped)
            #endif
            #if os(tvOS)
            view.setOnSelectPressed(selectPressed)
            view.setOnLeftArrowTapped(leftArrowTapped)
            view.setOnRightArrowTapped(rightArrowTapped)
            #endif
            view.drawPlayer(with: player)
            view.setControlViewVisibility(visible: true, animated: false)
        }

        if Thread.isMainThread {
            initPlayerView()
        } else {
            DispatchQueue.main.sync {
                initPlayerView()
            }
        }

        #if DEBUG
        player.isMuted = true
        #endif

        youboraPlugin.fireInit()

        rebuild()
    }

    deinit {
        if let timeObserver = timeObserver { player.removeTimeObserver(timeObserver) }
        player.removeObserver(self, forKeyPath: "status")
        player.removeObserver(self, forKeyPath: "timeControlStatus")
        youboraPlugin.fireStop()
    }

    /// This should be called whenever a new Event or Stream is loaded into the video player and the state of the player needs to be reset.
    /// Also should be called on init().
    private func rebuild() {
        view.controlView.isHidden = true

        // TODO: Consider how to play streams directly.
        if let event = event {
            var workItemCalled = false
            let playStreamWorkItem = DispatchWorkItem() { [weak self] in
                if !workItemCalled {
                    workItemCalled = true

                    if let stream = self?.event?.streams.first ?? self?.stream {
                        self?.replaceCurrentItem(url: stream.fullUrl) { [weak self] completed in
                            guard let self = self else { return }
                            self.view.controlView.isHidden = false
                            if completed {
                                if self.playerConfig.autoplay {
                                    self.play()
                                }
                            }
                        }
                    }
                }
            }

            // Schedule the player to start playing in 3 seconds if the API does not respond by then.
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0, execute: playStreamWorkItem)
            apiService.fetchPlayerConfig(byEventId: event.id) { [weak self] (playerConfig, _) in
                if let playerConfig = playerConfig {
                    self?.playerConfig = playerConfig
                    DispatchQueue.main.async(execute: playStreamWorkItem)
                }
            }

            // TODO: Should not pass eventId but timelineId
            apiService.fetchAnnotations(byTimelineId: "brusquevsmanaus") { [weak self] (annotations, _) in
                if let annotations = annotations {
                    self?.annotations = annotations
                }
            }
        }
    }

    /// This should be called whenever the annotations associated with this videoPlayer should be re-evaluated.
    private func evaluateAnnotations() {
        annotationService.evaluate(AnnotationService.EvaluationInput(annotations: annotations, activeOverlayIds: activeOverlayIds, currentTime: optimisticCurrentTime, currentDuration: currentDuration)) { [weak self] output in

            self?.activeOverlayIds = output.activeOverlayIds

            DispatchQueue.main.async { [weak self] in
                self?.view.setTimelineMarkers(with: output.showTimelineMarkers)
                if output.showOverlays.count > 0 {
                    self?.view.showOverlays(with: output.showOverlays)
                }
                if output.hideOverlays.count > 0 {
                    self?.view.hideOverlays(with: output.hideOverlays)
                }
            }
        }

        delegate?.playerDidUpdateAnnotations(player: self)
    }

    /// Use this method instead of calling replaceCurrentItem() directly on the AVPlayer.
    /// - parameter callback: A callback that is called when the replacement is completed (true) or failed/cancelled (false).
    private func replaceCurrentItem(url: URL, callback: @escaping (Bool) -> ()) {
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
    private func trackTime(with player: AVPlayer) -> Any {
        player
            .addPeriodicTimeObserver(
                forInterval: CMTime(value: 1, timescale: 1),
                queue: .main) { [weak self] _ in
                    guard let self = self else { return }

                    // Do not process this while the player is seeking. It especially conflicts with the slider being dragged.
                    guard !self.player.isSeeking else { return }

                    let currentDuration = self.currentDuration
                    let optimisticCurrentTime = self.optimisticCurrentTime

                    if !self.view.videoSlider.isTracking {
                        self.updatePlaytimeIndicators(optimisticCurrentTime, totalSeconds: currentDuration, liveState: self.liveState)

                        if currentDuration > 0 {
                            self.view.videoSlider.value = optimisticCurrentTime / currentDuration
                        }
                    }

                    if currentDuration > 0 && currentDuration <= optimisticCurrentTime && !self.isLivestream {
                        self.state = .ended
                        self.view.setPlayButtonTo(state: .replay)
                    }

                    self.delegate?.playerDidUpdateTime(player: self)

                    self.evaluateAnnotations()
        }
    }

    private func sliderUpdated(with fraction: Double) {
        let currentDuration = self.currentDuration
        guard currentDuration > 0 else { return }

        let elapsedSeconds = Float64(fraction) * currentDuration

        updatePlaytimeIndicators(elapsedSeconds, totalSeconds: currentDuration, liveState: self.liveState)

        setControlViewVisibility(visible: true, animated: true)
    }

    private func sliderReleased(with fraction: Double) {
        let currentDuration = self.currentDuration
        guard currentDuration > 0 else { return }

        let elapsedSeconds = Float64(fraction) * currentDuration

        updatePlaytimeIndicators(elapsedSeconds, totalSeconds: currentDuration, liveState: self.liveState)

        let seekTime = CMTime(value: Int64(min(currentDuration - 1, elapsedSeconds)), timescale: 1)
        player.seek(to: seekTime, toleranceBefore: seekTolerance, toleranceAfter: seekTolerance, debounceSeconds: 0.5, completionHandler: { _ in })

        setControlViewVisibility(visible: true, animated: true)
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

    private func setControlViewVisibility(visible: Bool, animated: Bool) {
        if visible {
            controlViewDebouncer.debounce { [weak self] in
                self?.view.setControlViewVisibility(visible: false, animated: true)
            }
        }
        view.setControlViewVisibility(visible: visible, animated: true)
    }

    private func playButtonTapped() {
        if state != .ended {
            status.toggle()
        }
        else {
            player.seek(to: .zero, toleranceBefore: .zero, toleranceAfter: .zero) { [weak self] finished in
                if finished {
                    self?.state = .readyToPlay
                    self?.play()
                }
            }
        }

        setControlViewVisibility(visible: true, animated: true)
    }

    private func relativeSeekWithDebouncer(amount: Double) {
        let currentDuration = self.currentDuration
        guard currentDuration > 0 else { return }

        player.seek(by: amount, toleranceBefore: .zero, toleranceAfter: .zero, debounceSeconds: 0.4, completionHandler: { _ in })

        let optimisticCurrentTime = self.optimisticCurrentTime

        view.videoSlider.value = optimisticCurrentTime / currentDuration
        updatePlaytimeIndicators(optimisticCurrentTime, totalSeconds: currentDuration, liveState: self.liveState)
    }

    private func skipBackButtonTapped() {
        relativeSeekWithDebouncer(amount: -10)

        setControlViewVisibility(visible: true, animated: true)
    }

    private func skipForwardButtonTapped() {
        relativeSeekWithDebouncer(amount: 10)

        setControlViewVisibility(visible: true, animated: true)
    }

    #if os(iOS)
    private func controlViewTapped() {
        setControlViewVisibility(visible: !view.controlViewHasAlpha, animated: true)
    }

    private func liveButtonTapped() {
        let currentDuration = self.currentDuration
        guard currentDuration > 0, self.liveState != .liveAndLatest else { return }

        view.videoSlider.value = 1.0
        updatePlaytimeIndicators(currentDuration, totalSeconds: currentDuration, liveState: .liveAndLatest)

        let seekTime = CMTime(value: Int64(currentDuration), timescale: 1)
        player.seek(to: seekTime, toleranceBefore: .zero, toleranceAfter: .zero) { [weak self] finished in
            if finished {
                self?.play()
            }
        }

        setControlViewVisibility(visible: true, animated: true)
    }

    private func fullscreenButtonTapped() {
        isFullscreen.toggle()

        setControlViewVisibility(visible: true, animated: true)
    }
    #endif

    #if os(tvOS)
    private func selectPressed() {
        setControlViewVisibility(visible: !view.controlViewHasAlpha, animated: true)
    }

    private func leftArrowTapped() {
        skipBackButtonTapped()
    }

    private func rightArrowTapped() {
        skipForwardButtonTapped()
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
    #if os(iOS)
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
