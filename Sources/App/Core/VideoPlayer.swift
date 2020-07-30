//
// Copyright © 2020 mycujoo. All rights reserved.
//

import AVFoundation
import YouboraAVPlayerAdapter
import YouboraLib

public class VideoPlayer: NSObject {

    // MARK: - Public properties

    public weak var delegate: PlayerDelegate?

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

    /// The view of the VideoPlayer.
    public var playerView: UIView {
        if let view = view as? UIView {
            return view
        }
        fatalError("When running unit tests, this property cannot be accessed. Use `view` directly.")
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
        guard let duration = player.currentDurationAsCMTime else {
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

    private(set) var annotationActions: [AnnotationAction] = [] {
        didSet {
            evaluateAnnotations()
        }
    }

    /// The view in which all player controls are rendered. SDK implementers can add more controls to this view, if desired.
    public var controlView: UIView {
        return view.controlView
    }
    /// The AVPlayerLayer of the associated AVPlayer
    public var playerLayer: AVPlayerLayer? {
        return view.playerLayer
    }

    #if os(iOS)
    /// This horizontal UIStackView can be used to add more custom UIButtons to (e.g. PiP).
    public var topControlsStackView: UIStackView {
        return view.topControlsStackView
    }

    /// Sets the visibility of the fullscreen button.
    public var fullscreenButtonIsHidden: Bool {
        get {
            return view.fullscreenButtonIsHidden
        }
        set {
            view.fullscreenButtonIsHidden = newValue
        }
    }
    /// The UITapGestureRecognizer that is listening to taps on the VideoPlayer's view.
    public var tapGestureRecognizer: UITapGestureRecognizer {
        return view.tapGestureRecognizer
    }
    #endif

    // MARK: - Private properties

    private let player: MLSAVPlayerProtocol
    private let getAnnotationActionsForTimelineUseCase: GetAnnotationActionsForTimelineUseCase
    private let getPlayerConfigForEventUseCase: GetPlayerConfigForEventUseCase
    private let getSVGUseCase: GetSVGUseCase
    private let annotationService: AnnotationServicing
    private var timeObserver: Any?

    private lazy var controlViewDebouncer = Debouncer(minimumDelay: 4.0)
    private lazy var relativeSeekDebouncer = Debouncer(minimumDelay: 0.4)

    private var tovStore: TOVStore? = nil

    private lazy var humanFriendlyDateFormatter: DateFormatter = {
        let df =  DateFormatter()
        df.dateStyle = .medium
        df.timeStyle = .short
        return df
    }()

    private lazy var youboraPlugin: YBPlugin? = {
        // Only add the adapter in real scenarios. When running unit tests with a mocked player, there will not be a youbora plugin.
        guard let avPlayer = self.player as? AVPlayer else { return nil }

        let options = YBOptions()
        options.accountCode = "mycujoo"
        options.username = "mls"
        let plugin = YBPlugin(options: options)
        plugin.adapter = YBAVPlayerAdapterSwiftTranformer.transform(from: YBAVPlayerAdapter(player: avPlayer))

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

    /// A dictionary of dynamic overlays currently showing within this view. Keys are the overlay identifiers.
    /// The UIView should be the outer container of the overlay, not the SVGView directly.
    private var overlays: [String: UIView] = [:]

    /// A level that indicates which actions are allowed to overwrite the state of the control view visibility.
    private var controlViewDirectiveLevel: DirectiveLevel = .none
    private var controlViewLocked: Bool = false

    /// Configures the tolerance with which the player seeks (for both `toleranceBefore` and `toleranceAfter`).
    private let seekTolerance: CMTime

    // MARK: - Internal properties

    var view: VideoPlayerViewProtocol!

    /// Setting the playerConfig will automatically updates the associated views and behavior.
    /// However, this should not be exposed to the SDK user directly, since it should only be configurable through the MLS console / API.
    var playerConfig = PlayerConfig.standard() {
        didSet {
            DispatchQueue.main.async { [weak self] in
                guard let `self` = self else { return }
                self.view.primaryColor = UIColor(hex: self.playerConfig.primaryColor)
                self.view.secondaryColor = UIColor(hex: self.playerConfig.secondaryColor)
                #if os(iOS)
                self.view.setSkipButtons(hidden: !self.playerConfig.showBackForwardsButtons)
                self.view.setInfoButtonAndView(hidden: !self.playerConfig.showEventInfoButton)
                #endif
            }
        }
    }

    // MARK: - Methods

    init(
            view: VideoPlayerViewProtocol,
            player: MLSAVPlayerProtocol,
            getAnnotationActionsForTimelineUseCase: GetAnnotationActionsForTimelineUseCase,
            getPlayerConfigForEventUseCase: GetPlayerConfigForEventUseCase,
            getSVGUseCase: GetSVGUseCase,
            annotationService: AnnotationServicing,
            seekTolerance: CMTime = .positiveInfinity) {
        self.player = player
        self.getAnnotationActionsForTimelineUseCase = getAnnotationActionsForTimelineUseCase
        self.getPlayerConfigForEventUseCase = getPlayerConfigForEventUseCase
        self.getSVGUseCase = getSVGUseCase
        self.annotationService = annotationService
        self.seekTolerance = seekTolerance

        super.init()

        player.addObserver(self, forKeyPath: "status", options: .new, context: nil)
        player.addObserver(self, forKeyPath: "timeControlStatus", options: [.old, .new], context: nil)
        timeObserver = trackTime(with: player)

        func initPlayerView() {
            self.view = view
            view.setOnTimeSliderSlide(sliderUpdated)
            view.setOnTimeSliderRelease(sliderReleased)
            view.setOnPlayButtonTapped(playButtonTapped)
            view.setOnSkipBackButtonTapped(skipBackButtonTapped)
            view.setOnSkipForwardButtonTapped(skipForwardButtonTapped)
            #if os(iOS)
            view.setOnControlViewTapped(controlViewTapped)
            view.setOnLiveButtonTapped(liveButtonTapped)
            view.setOnFullscreenButtonTapped(fullscreenButtonTapped)
            view.setOnInfoButtonTapped(infoButtonTapped)
            #endif
            #if os(tvOS)
            view.setOnSelectPressed(selectPressed)
            view.setOnLeftArrowTapped(leftArrowTapped)
            view.setOnRightArrowTapped(rightArrowTapped)
            #endif
            view.drawPlayer(with: player)
            setControlViewVisibility(visible: false, animated: false, directiveLevel: .systemInitiated, lock: true)
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

        youboraPlugin?.fireInit()

        rebuild()
    }

    deinit {
        if let timeObserver = timeObserver { player.removeTimeObserver(timeObserver) }
        player.removeObserver(self, forKeyPath: "status")
        player.removeObserver(self, forKeyPath: "timeControlStatus")
        youboraPlugin?.fireStop()
    }

    /// This should be called whenever a new Event or Stream is loaded into the video player and the state of the player needs to be reset.
    /// Also should be called on init().
    private func rebuild() {
        setControlViewVisibility(visible: false, animated: false, directiveLevel: .systemInitiated, lock: true)

        // TODO: Consider how to play streams directly.
        if let event = event {
            var workItemCalled = false
            let playStreamWorkItem = DispatchWorkItem() { [weak self] in
                if !workItemCalled {
                    workItemCalled = true

                    if let stream = self?.event?.streams.first ?? self?.stream {
                        self?.replaceCurrentItem(url: stream.fullUrl) { [weak self] completed in
                            guard let self = self else { return }

                            self.setControlViewVisibility(visible: false, animated: false, directiveLevel: .systemInitiated, lock: false)

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
            getPlayerConfigForEventUseCase.execute(eventId: event.id) { [weak self] (playerConfig, _) in
                if let playerConfig = playerConfig {
                    self?.playerConfig = playerConfig
                    DispatchQueue.main.async(execute: playStreamWorkItem)
                }
            }

            tovStore = TOVStore()

            // TODO: Should not pass eventId but timelineId
            getAnnotationActionsForTimelineUseCase.execute(timelineId: "standard") { [weak self] (actions, _) in
                if let actions = actions {
                    self?.annotationActions = actions
                }
            }

            view.infoTitleLabel.text = event.title
            view.infoDescriptionLabel.text = event.descriptionText
            if let startTime = event.startTime {
                var timeStr = humanFriendlyDateFormatter.string(from: startTime)
                if let timezone = event.timezone {
                    timeStr += " (\(timezone))"
                }
                view.infoDateLabel.text = timeStr
            } else {
                view.infoDateLabel.text = nil
            }
        }
    }

    /// This should be called whenever the annotations associated with this videoPlayer should be re-evaluated.
    private func evaluateAnnotations() {
        annotationService.evaluate(AnnotationService.EvaluationInput(actions: annotationActions, activeOverlayIds: activeOverlayIds, currentTime: optimisticCurrentTime * 1000, currentDuration: currentDuration * 1000)) { [weak self] output in

            self?.activeOverlayIds = output.activeOverlayIds

            self?.tovStore?.new(tovs: output.tovs)

            DispatchQueue.main.async { [weak self] in
                self?.view.setTimelineMarkers(with: output.showTimelineMarkers)
                if output.showOverlays.count > 0 {
                    self?.showOverlays(with: output.showOverlays)
                }
                if output.hideOverlays.count > 0 {
                    self?.hideOverlays(with: output.hideOverlays)
                }
            }
        }
    }

    /// Use this method instead of calling replaceCurrentItem() directly on the AVPlayer.
    /// - parameter callback: A callback that is called when the replacement is completed (true) or failed/cancelled (false).
    private func replaceCurrentItem(url: URL, callback: @escaping (Bool) -> ()) {
        // TODO: generate the user-agent elsewhere.
        let headerFields: [String: String] = ["user-agent": "tv.mycujoo.mls.ios-sdk"]
        player.replaceCurrentItem(with: url, headers: headerFields, callback: callback)
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
                            self?.view.setBufferIcon(hidden: true)
                        } else {
                            self?.view.setBufferIcon(hidden: false)
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
    private func showOverlays(with actions: [MLSUI.ShowOverlayAction]) {
        func svgParseAndRender(action: MLSUI.ShowOverlayAction, baseSVG: String) {
            var baseSVG = baseSVG
            // On every variable/timer change, re-place all variables and timers in the svg again
            // (because we only have the initial SVG, we don't keep its updated states with the original tokens
            // included).
            print("Got a store?", self.tovStore)
            guard let tovStore = self.tovStore else { return }
            for variableName in action.variables {
                // Fallback to the variable name if there is no variable defined.
                // The reason for this is that certain "variable-like" values might have slipped through,
                // e.g. prices that start with a dollar sign.
                let resolved = tovStore.get(by: variableName)?.humanFriendlyValue ?? variableName
                baseSVG = baseSVG.replacingOccurrences(of: variableName, with: resolved)
            }

            if let node = try? SVGParser.parse(text: baseSVG), let bounds = node.bounds {
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }

                    let imageView = SVGView(node: node, frame: CGRect(x: 0, y: 0, width: bounds.w, height: bounds.h))
                    imageView.clipsToBounds = true
                    imageView.backgroundColor = .none

                    print("Got to the point where place an overlay with actionId", action)

                    if let containerView = self.overlays[action.overlayId] {
                        print("WE HAVE THIS ALREDY!")
                        self.view.replaceOverlay(containerView: containerView, imageView: imageView)
                    } else {
                        self.overlays[action.overlayId] = self.view.placeOverlay(imageView: imageView, size: action.size, position: action.position, animateType: action.animateType, animateDuration: action.animateDuration)
                        print("STORED SOMETHING FOR action.overlayId", action.overlayId, "which is", self.overlays[action.overlayId])
                    }
                }
            }
        }

        DispatchQueue.global(qos: .background).async { [weak self] in
            guard let self = self else { return }
            for action in actions {
                // TODO: Find out if this is reading from network cache layer.
                self.getSVGUseCase.execute(url: action.overlay.svgURL) { [weak self] (baseSVG, _) in
                    guard let self = self else { return }

                    if let baseSVG = baseSVG {
                        for variableName in action.variables {
                            self.tovStore?.addObserver(tovName: variableName, callbackId: action.overlayId, callback: { val in
                                // Re-render the entire SVG (including replacing all tokens with their resolved values)
                                svgParseAndRender(action: action, baseSVG: baseSVG)
                            })
                        }
                        // Do an initial rendering as well
                        svgParseAndRender(action: action, baseSVG: baseSVG)
                    }
                }
            }
        }
    }

    private func hideOverlays(with actions: [MLSUI.HideOverlayAction]) {
        for action in actions {
            if let v = self.overlays[action.overlayId] {
                view?.removeOverlay(containerView: v, animateType: action.animateType, animateDuration: action.animateDuration) { [weak self] in
                    self?.overlays[action.overlayId] = nil
                    self?.tovStore?.removeObservers(callbackId: action.overlayId)
                }
            }
        }
    }

    private func trackTime(with player: MLSAVPlayerProtocol) -> Any {
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

    /// - parameter visible: What the new state of visibility should be
    /// - parameter animted: Whether to animate the transition
    /// - parameter directiveLevel: The level of priority with which this control view visibility should be changed.
    ///   If a higher directive level is currently in conflict with this call, it will be ignored.
    ///   For example, if the user tapped the info button, the control view should remain visible until it is actively dismissed. A call to this method with a lower priority for dismissal will be ignored.
    /// - parameter lock: Whether to set the new directive level globally (true), so that future updates need the same (or higher) directive level.
    ///   If false is provided, the directive level will be reset to `none`.
    /// - returns: Whether this request is honored (true) or not (false).
    @discardableResult
    private func setControlViewVisibility(visible: Bool, animated: Bool, directiveLevel: DirectiveLevel = .derived, lock: Bool = false) -> Bool {
        if directiveLevel.rawValue < controlViewDirectiveLevel.rawValue {
            return false
        }
        controlViewDirectiveLevel = lock ? directiveLevel : .none

        controlViewDebouncer.debounce { [weak self] in
            guard let self = self else { return }
            if visible && self.controlViewDirectiveLevel.rawValue <= DirectiveLevel.derived.rawValue {
                self.view.setControlViewVisibility(visible: false, animated: animated)
            }
        }
        view.setControlViewVisibility(visible: visible, animated: animated)

        return true
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
        if playerConfig.showBackForwardsButtons {
            relativeSeekWithDebouncer(amount: -10)

            setControlViewVisibility(visible: true, animated: true)
        }
    }

    private func skipForwardButtonTapped() {
        if playerConfig.showBackForwardsButtons {
            relativeSeekWithDebouncer(amount: 10)

            setControlViewVisibility(visible: true, animated: true)
        }
    }

    #if os(iOS)
    private func controlViewTapped() {
        if view.infoViewHasAlpha {
            view.setInfoViewVisibility(visible: false, animated: true)
            setControlViewVisibility(visible: false, animated: true, directiveLevel: .userInitiated, lock: false)
        } else {
            setControlViewVisibility(visible: !view.controlViewHasAlpha, animated: true)
        }
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

    private func infoButtonTapped() {
        let visible = !view.infoViewHasAlpha
        setControlViewVisibility(visible: false, animated: true, directiveLevel: .userInitiated, lock: visible)

        view.setInfoViewVisibility(visible: visible, animated: true)
    }
    #endif

    #if os(tvOS)
    private func selectPressed() {
        let honored = setControlViewVisibility(visible: !view.controlViewHasAlpha, animated: true, directiveLevel: .userInitiated, lock: !view.controlViewHasAlpha)
        if honored {
            view.setInfoViewVisibility(visible: !view.controlViewHasAlpha, animated: true)
        }
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

// MARK: - DirectiveLevel
extension VideoPlayer {
    enum DirectiveLevel: Int {
        /// A directive initiated by the system. This is the highest priority directive.
        case systemInitiated = 1000
        /// A directive initiated by the user. This is the highest priority directive except for `systemInitiated`
        case userInitiated = 750
        /// A directive that is derived from another action that happened within the system. This is the lowest priority, except `none`.
        case derived = 250
        case none = 0
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
}
