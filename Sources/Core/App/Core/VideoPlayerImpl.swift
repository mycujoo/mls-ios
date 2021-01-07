//
// Copyright © 2020 mycujoo. All rights reserved.
//

import AVFoundation
import UIKit


internal class VideoPlayerImpl: NSObject, VideoPlayer {

    weak var delegate: PlayerDelegate?

    var imaIntegration: IMAIntegration? {
        didSet {
            guard let avPlayer = self.player as? AVPlayer else { return }
            imaIntegration?.setAVPlayer(avPlayer)
        }
    }

    var castIntegration: CastIntegration? {
        didSet {
            castIntegration?.initialize(self)
        }
    }

    private(set) var state: VideoPlayerState = .unknown {
        didSet {
            delegate?.playerDidUpdateState(player: self)

            if state == .ended && oldValue != .ended {
                // TODO: Find out if playing a postroll clashes with other actions that may happen as a result of the `.ended` state.
                imaIntegration?.playPostroll()
            }
        }
    }

    /// Setting an Event will automatically switch the player over to the primary stream that is associated with this Event, if one is available.
    /// - note: This sets `stream` to nil.
    var event: Event? {
        didSet {
            if stream != nil {
                stream = nil
            }
            let new = event?.id != oldValue?.id
            if new, let oldEvent = oldValue {
                cleanup(oldEvent: oldEvent)
            }
            rebuild(new: new)
        }
    }

    /// Setting a Stream will automatically switch the player over to this stream.
    /// - note: This sets `event` to nil.
    var stream: Stream? {
        didSet {
            if event != nil {
                event = nil
            }
            let new = stream?.id != oldValue?.id
            if new, let oldStream = oldValue {
                cleanup(oldStream: oldStream)
            }
            rebuild(new: new)
        }
    }

    /// The current status of the player, based on the current item.
    private(set) var status: VideoPlayerStatus = .pause {
        didSet {
            var buttonState: VideoPlayerPlayButtonState
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
                #if os(iOS)
                self.view.setPlayButtonTo(state: self.playerConfig.showPlayAndPause ? buttonState : .none)
                #else
                self.view.setPlayButtonTo(state: buttonState)
                #endif
            }

            if oldValue != status {
                delegate?.playerDidUpdatePlaying(player: self)
            }
        }
    }

    /// The view of the VideoPlayer.
    var playerView: UIView {
        if let view = view as? UIView {
            return view
        }
        fatalError("When running unit tests, this property cannot be accessed. Use `view` directly.")
    }

    #if os(iOS)
    /// This property changes when the fullscreen button is tapped. SDK implementors can update this state directly, which will update the visual of the button.
    /// Any value change will call the delegate's `playerDidUpdateFullscreen` method.
    var isFullscreen: Bool = false {
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

    /// Get or set the `isMuted` property of the underlying AVPlayer.
    var isMuted: Bool {
        get {
            return player.isMuted
        }
        set {
            player.isMuted = newValue
        }
    }

    /// Indicates whether the current item is a live stream.
    var isLivestream: Bool {
        guard let duration = player.currentDurationAsCMTime else {
            return false
        }
        let seconds = CMTimeGetSeconds(duration)
        return seconds.isNaN || seconds.isInfinite
    }

    /// - returns: The current time (in seconds) of the currentItem.
    var currentTime: Double {
        return player.currentTime
    }

    /// - returns: The current time (in seconds) that is expected after all pending seek operations are done on the currentItem.
    var optimisticCurrentTime: Double {
        return player.optimisticCurrentTime
    }

    /// - returns: The duration (in seconds) of the currentItem. If unknown, returns 0.
    var currentDuration: Double {
        return player.currentDuration
    }

    /// The view in which all player controls are rendered. SDK implementers can add more controls to this view, if desired.
    var controlView: UIView {
        return view.controlView
    }
    /// The AVPlayerLayer of the associated AVPlayer
    var playerLayer: AVPlayerLayer? {
        return view.playerLayer
    }

    #if os(iOS)
    var topLeadingControlsStackView: UIStackView {
        return view.topLeadingControlsStackView
    }

    var topTrailingControlsStackView: UIStackView {
        return view.topTrailingControlsStackView
    }

    /// The UITapGestureRecognizer that is listening to taps on the VideoPlayer's view.
    var tapGestureRecognizer: UITapGestureRecognizer {
        return view.tapGestureRecognizer
    }
    #endif

    /// Seek to a position within the currentItem.
    /// - parameter to: The number of seconds within the currentItem to seek to.
    /// - parameter completionHandler: A closure that is called upon a completed seek operation.
    /// - note: The seek tolerance can be configured through the `playerConfig` property on this `VideoPlayer` and is used for all seek operations by this player.
    func seek(to: Double, completionHandler: @escaping (Bool) -> Void) {
        let seekTime = CMTimeMakeWithSeconds(max(0, min(currentDuration - 1, to)), preferredTimescale: 600)
        player.seek(to: seekTime, toleranceBefore: seekTolerance, toleranceAfter: seekTolerance, completionHandler: completionHandler)
    }

    func showEventInfoOverlay() {
        setInfoViewTo(visible: true)
    }

    func hideEventInfoOverlay() {
        setInfoViewTo(visible: false)
    }

    // MARK: - Private properties

    private let player: MLSAVPlayerProtocol
    private let getEventUpdatesUseCase: GetEventUpdatesUseCase
    private let getTimelineActionsUpdatesUseCase: GetTimelineActionsUpdatesUseCase
    private let getPlayerConfigUseCase: GetPlayerConfigUseCase
    private let getSVGUseCase: GetSVGUseCase
    private let getCertificateDataUseCase: GetCertificateDataUseCase
    private let getLicenseDataUseCase: GetLicenseDataUseCase
    private let annotationService: AnnotationServicing
    private let videoAnalyticsService: VideoAnalyticsServicing
    private let hlsInspectionService: HLSInspectionServicing
    private var timeObserver: Any?

    private lazy var controlViewDebouncer = Debouncer(minimumDelay: 8.0)
    private lazy var relativeSeekDebouncer = Debouncer(minimumDelay: 0.4)

    private var tovStore: TOVStore? = nil

    /// The stream that is currently represented on-screen. Different from the `stream` property because it is used internally for state-keeping.
    private var currentStream: Stream? = nil {
        didSet {
            if currentStream == nil || currentStream?.id != oldValue?.id {
                // A different stream should be played.
                // Note: also trigger when nil is being set again, because this will trigger secondary actions like updating info layer visibility.
                placeCurrentStream()
            } else if let currentStream = currentStream, let oldValue = oldValue, currentStream.id == oldValue.id, oldValue.url == nil && currentStream.url != nil {
                // This is still the same stream, but the url was previously not known and now it is.
                // This is relevant in cases like PPV, where previously a user may not have been entitled but now they are.
                placeCurrentStream()
            }
        }
    }

    /// The DRM request url for this current stream. This can be used to track and prevent multiple calls to the license server for the same license request.
    private var currentStreamDRMRequestUrl: URL? = nil
    /// A helper to indicate whether play has been called already since the `currentStream` was first loaded into the video player through `placeCurrentStream()`
    /// This can be used to determine if a call to `play()` should first call the imaIntegration for a preroll ad.
    private var currentStreamPlayHasBeenCalled = false

    private lazy var humanFriendlyDateFormatter: DateFormatter = {
        let df =  DateFormatter()
        df.dateStyle = .medium
        df.timeStyle = .short
        return df
    }()

    // TODO: Move livestate to mlsavplayer?
    private var liveState: VideoPlayerLiveState {
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

    // Note: In the future this perhaps should be a Timeline object instead of just an identifier.
    private var timeline: String? {
        didSet {
            let new = timeline != oldValue
            if new, let oldTimeline = oldValue {
                cleanup(oldTimeline: oldTimeline)
            }
            rebuildTimeline(new: new)
        }
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

    /// A string that uniquely identifies this user.
    private let pseudoUserId: String

    /// A identifier that is used in requests to the MCLS api that represents this organization.
    private let publicKey: String

    // MARK: - Internal properties

    var view: VideoPlayerViewProtocol!

    /// Setting the playerConfig will automatically updates the associated views and behavior.
    var playerConfig: PlayerConfig! {
        didSet {
            DispatchQueue.main.async { [weak self] in
                guard let `self` = self else { return }
                self.view.setControlView(hidden: !self.playerConfig.enableControls)
                self.view.primaryColor = UIColor(hex: self.playerConfig.primaryColor)
                self.view.secondaryColor = UIColor(hex: self.playerConfig.secondaryColor)
                self.view.setSeekbar(hidden: !self.playerConfig.showSeekbar)
                self.view.setTimeIndicatorLabel(hidden: !self.playerConfig.showTimers)
                #if os(iOS)
                self.view.fullscreenButtonIsHidden = !self.playerConfig.showFullscreen
                self.view.setSkipButtons(hidden: !self.playerConfig.showBackForwardsButtons)
                self.view.setInfoButton(hidden: !self.playerConfig.showEventInfoButton)

                // To reset the state of the play/pause button, trigger a new didSet on the player status.
                // This could be more elegant...
                let status = self.status
                self.status = status
                #endif

                self.imaIntegration?.setAdUnit(self.playerConfig.imaAdUnit)
            }
        }
    }

    private(set) var annotationActions: [AnnotationAction] = [] {
        didSet {
            evaluateAnnotations()
        }
    }

    var localAnnotationActions: [AnnotationAction] = [] {
        didSet {
            evaluateAnnotations()
        }
    }

    // MARK: - Methods

    init(
            view: VideoPlayerViewProtocol,
            player: MLSAVPlayerProtocol,
            getEventUpdatesUseCase: GetEventUpdatesUseCase,
            getTimelineActionsUpdatesUseCase: GetTimelineActionsUpdatesUseCase,
            getPlayerConfigUseCase: GetPlayerConfigUseCase,
            getSVGUseCase: GetSVGUseCase,
            getCertificateDataUseCase: GetCertificateDataUseCase,
            getLicenseDataUseCase: GetLicenseDataUseCase,
            annotationService: AnnotationServicing,
            videoAnalyticsService: VideoAnalyticsServicing,
            hlsInspectionService: HLSInspectionServicing,
            seekTolerance: CMTime = .positiveInfinity,
            pseudoUserId: String,
            publicKey: String) {
        self.player = player
        self.getEventUpdatesUseCase = getEventUpdatesUseCase
        self.getTimelineActionsUpdatesUseCase = getTimelineActionsUpdatesUseCase
        self.getPlayerConfigUseCase = getPlayerConfigUseCase
        self.getSVGUseCase = getSVGUseCase
        self.getCertificateDataUseCase = getCertificateDataUseCase
        self.getLicenseDataUseCase = getLicenseDataUseCase
        self.annotationService = annotationService
        self.videoAnalyticsService = videoAnalyticsService
        self.hlsInspectionService = hlsInspectionService
        self.seekTolerance = seekTolerance
        self.pseudoUserId = pseudoUserId
        self.publicKey = publicKey

        super.init()

        player.addObserver(self, forKeyPath: "status", options: .new, context: nil)
        player.addObserver(self, forKeyPath: "timeControlStatus", options: [.old, .new], context: nil)
        timeObserver = trackTime(with: player)

        videoAnalyticsService.create(with: player)

        func initPlayerView() {
            self.view = view
            view.setOnTimeSliderSlide({ [weak self] fraction in self?.sliderUpdated(with: fraction) })
            view.setOnTimeSliderRelease({ [weak self] fraction in self?.sliderReleased(with: fraction) })
            view.setOnPlayButtonTapped({ [weak self] () in self?.playButtonTapped() })
            view.setOnSkipBackButtonTapped({ [weak self] () in self?.skipBackButtonTapped() })
            view.setOnSkipForwardButtonTapped({ [weak self] () in self?.skipForwardButtonTapped() })
            #if os(iOS)
            view.setOnControlViewTapped({ [weak self] () in self?.controlViewTapped() })
            view.setOnLiveButtonTapped({ [weak self] () in self?.liveButtonTapped() })
            view.setOnFullscreenButtonTapped({ [weak self] () in self?.fullscreenButtonTapped() })
            view.setOnInfoButtonTapped({ [weak self] () in self?.infoButtonTapped() })
            #endif
            #if os(tvOS)
            view.setOnSelectPressed({ [weak self] () in self?.selectPressed() })
            view.setOnLeftArrowTapped({ [weak self] () in self?.leftArrowTapped() })
            view.setOnRightArrowTapped({ [weak self] () in self?.rightArrowTapped() })
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
    }

    deinit {
        if let timeObserver = timeObserver { player.removeTimeObserver(timeObserver) }
        player.removeObserver(self, forKeyPath: "status")
        player.removeObserver(self, forKeyPath: "timeControlStatus")

        NotificationCenter.default.removeObserver(self)

        if let event = event {
            cleanup(oldEvent: event)
        }
        if let stream = stream {
            cleanup(oldStream: stream)
        }

        videoAnalyticsService.stop()

        print("Video player was deinitialized.")
    }

    /// This should be called whenever a new Event or Stream is loaded into the video player and the state of the player needs to be reset.
    /// Also should be called on init().
    /// - parameter new: Boolean that indicates whether the newly loaded Event or Stream has a different id than the current one.
    ///   If false, only some VideoPlayer changes are applied.
    private func rebuild(new: Bool) {
        currentStream = event?.streams.first ?? stream

        updateInfo()
        updateYouboraMetadata()

        if new {
            tovStore = TOVStore()

            if let event = event, event.isMLS {
                getEventUpdatesUseCase.start(id: event.id) { [weak self] update in
                    guard let self = self else { return }
                    switch update {
                    case .eventLiveViewers(let amount):
                        if !self.playerConfig.showLiveViewers || !self.isLivestream || amount < 2 {
                            self.view.setNumberOfViewersTo(amount: nil)
                        } else {
                            self.view.setNumberOfViewersTo(amount: self.formatLiveViewers(amount))
                        }
                    case .eventUpdate(let updatedEvent):
                        if updatedEvent.id == event.id {
                            self.event = updatedEvent
                        }
                    }
                }
            } else {
                view.setNumberOfViewersTo(amount: nil)
            }
            imaIntegration?.setBasicCustomParameters(eventId: event?.id, streamId: currentStream?.id)
        }

        timeline = event?.timelineIds.first
    }

    /// This should get called whenever a new Timeline is loaded into the video player.
    private func rebuildTimeline(new: Bool) {
        if new, let timelineId = timeline {
            getTimelineActionsUpdatesUseCase.start(id: timelineId) { [weak self] update in
                switch update {
                case .actionsUpdated(let actions):
                    self?.annotationActions = actions
                }
            }
        }
    }

    /// This method should not be called except when absolutely sure that the `currentStream` should be reloaded into the VideoPlayer.
    /// Also calls the callback when it actually removes the currentItem because there is no appropriate stream to play.
    /// - parameter callback: A callback with a boolean that is indicates whether the replacement is completed (true) or failed/cancelled (false).
    private func placeCurrentStream(callback: ((Bool) -> ())? = nil) {
        let url = currentStream?.url
        let added = url != nil

        if added {
            currentStreamPlayHasBeenCalled = false
        }

        if let castIntegration = castIntegration, castIntegration.isCasting() {
            castIntegration.setEventMetadata(publicKey: publicKey, pseudoUserId: pseudoUserId, event: event, stream: currentStream)

            // Make sure to unlock the controls.
            setControlViewVisibility(visible: false, animated: false, directiveLevel: .systemInitiated, lock: !added)
        } else {
            setControlViewVisibility(visible: false, animated: false, directiveLevel: .systemInitiated, lock: true)
            view.setBufferIcon(hidden: true)

            if !added {
                // TODO: Show the info layer or the thumbnail view.
                self.view.setInfoViewVisibility(visible: true, animated: false)
            } else {
                // TODO: Remove info layer and thumbnail view.
                self.view.setInfoViewVisibility(visible: false, animated: false)
            }

            let headerFields: [String: String] = ["user-agent": "tv.mycujoo.mls.ios-sdk"]
            player.replaceCurrentItem(with: url, headers: headerFields, resourceLoaderDelegate: self) { [weak self] completed in
                guard let self = self else { return }
                self.setControlViewVisibility(visible: false, animated: false, directiveLevel: .systemInitiated, lock: !added)

                if added && completed {
                    if self.playerConfig.autoplay {
                        self.play()
                    }
                }
                callback?(completed)
            }
        }

    }

    /// Should get called when the VideoPlayer switches to a different Event or Stream. Ensures that all resources are being cleaned up and networking is halted.
    /// - parameter oldEvent: The Event that was previously associated with the VideoPlayer.
    private func cleanup(oldEvent: Event) {
        getEventUpdatesUseCase.stop(id: oldEvent.id)
    }

    /// Should get called when the VideoPlayer switches to a different Event or Stream. Ensures that all resources are being cleaned up and networking is halted.
    /// - parameter oldStream: The Stream that was previously associated with the VideoPlayer.
    private func cleanup(oldStream: Stream) {}

    private func cleanup(oldTimeline: String) {
        getTimelineActionsUpdatesUseCase.stop(id: oldTimeline)
    }

    /// Sets the correct labels on the info layer.
    private func updateInfo() {
        // TODO: Refactor this method so these UILabels are not directly manipulated from here.

        view.infoTitleLabel.text = event?.title

        if let errorCode = currentStream?.error?.code {
            let error: String
            switch errorCode {
            case .geoblocked:
                error = L10n.Localizable.geoblockedError
            case .missingEntitlement:
                error = L10n.Localizable.missingEntitlementError
            case .internalError:
                error = L10n.Localizable.internalError
            }

            view.infoDescriptionLabel.text = error
            view.infoDescriptionLabel.textColor = .red
            view.infoDateLabel.text = nil
        } else {
            view.infoDescriptionLabel.text = event?.descriptionText
            view.infoDescriptionLabel.textColor = .white

            if let event = event {
                if let startTime = event.startTime {
                    let timeStr = humanFriendlyDateFormatter.string(from: startTime)
                    view.infoDateLabel.text = timeStr
                } else {
                    view.infoDateLabel.text = nil
                }
            } else {
                view.infoDateLabel.text = nil
            }
        }
    }

    private func updateYouboraMetadata() {
        videoAnalyticsService.currentItemTitle = event?.title
        videoAnalyticsService.currentItemEventId = event?.id
        videoAnalyticsService.currentItemStreamId = currentStream?.id
        videoAnalyticsService.currentItemStreamURL = currentStream?.url
        videoAnalyticsService.isNativeMLS = event?.isMLS ?? true

        // Note: "currentItemIsLive" is updated elsewhere, since that is a more dynamic property.
    }

    /// This should be called whenever the annotations associated with this videoPlayer should be re-evaluated.
    private func evaluateAnnotations() {
        let allAnnotationActions = annotationActions + localAnnotationActions

        // If the video is (roughly) as long as the total DVR window, then that means that it is dropping segments.
        // Because of this, we need to start calculating action offsets against the video ourselves.
        let offsetMappings: [String: (videoOffset: Int64, inGap: Bool)?]?
        if Int(currentDuration) + 20 > (currentStream?.dvrWindowSize ?? Int.max) / 1000 {
            let map = hlsInspectionService.map(hlsPlaylist: player.rawSegmentPlaylist, absoluteTimes: allAnnotationActions.map { $0.timestamp })
            offsetMappings = Dictionary(allAnnotationActions.map { (k: $0.id, v: map[$0.timestamp] ?? nil) }) { _, last in last }
        } else {
            offsetMappings = nil
        }

        annotationService.evaluate(AnnotationService.EvaluationInput(actions: allAnnotationActions, offsetMappings: offsetMappings, activeOverlayIds: activeOverlayIds, currentTime: optimisticCurrentTime * 1000, currentDuration: currentDuration * 1000)) { [weak self] output in

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
    
    //MARK: - KVO

    override func observeValue(
        forKeyPath keyPath: String?,
        of object: Any?,
        change: [NSKeyValueChangeKey : Any]?,
        context: UnsafeMutableRawPointer?
    ) {
        switch keyPath {
        case "status":
            state = VideoPlayerState(rawValue: player.status.rawValue) ?? .unknown
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
                        guard let self = self else { return }
                        if newStatus == .waitingToPlayAtSpecifiedRate && self.currentStream?.url != nil {
                            self.view.setBufferIcon(hidden: false)
                        } else {
                            self.view.setBufferIcon(hidden: true)
                        }
                    }
                }
            }
        default:
            break
        }
    }
}

// MARK: - Methods
extension VideoPlayerImpl {
    func play() {
        if !currentStreamPlayHasBeenCalled {
            currentStreamPlayHasBeenCalled = true

            if let imaIntegration = imaIntegration {
                imaIntegration.playPreroll()
                return
            }
        }

        if imaIntegration?.isShowingAd() == true {
            imaIntegration?.resume()
        } else {
            status = .play
        }
    }

    func pause() {
        if imaIntegration?.isShowingAd() == true {
            imaIntegration?.pause()
        } else {
            status = .pause
        }
    }

    func playVideo(with event: Event) {
        self.event = event
    }
}

// MARK: - Private Methods
extension VideoPlayerImpl {
    private func svgParseAndRender(action: MLSUI.ShowOverlayAction, baseSVG: String) {
        var baseSVG = baseSVG
        // On every variable/timer change, re-place all variables and timers in the svg again
        // (because we only have the initial SVG, we don't keep its updated states with the original tokens
        // included).
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

                if let containerView = self.overlays[action.overlayId] {
                    self.view.replaceOverlay(containerView: containerView, imageView: imageView)
                } else {
                    self.overlays[action.overlayId] = self.view.placeOverlay(imageView: imageView, size: action.size, position: action.position, animateType: action.animateType, animateDuration: action.animateDuration)
                }
            }
        }
    }

    private func showOverlays(with actions: [MLSUI.ShowOverlayAction]) {
        DispatchQueue.global(qos: .background).async { [weak self] in
            guard let self = self else { return }
            for action in actions {
                // TODO: Find out if this is reading from network cache layer.
                self.getSVGUseCase.execute(url: action.overlay.svgURL) { [weak self] (baseSVG, _) in
                    guard let self = self else { return }

                    if let baseSVG = baseSVG {
                        for variableName in action.variables {
                            self.tovStore?.addObserver(tovName: variableName, callbackId: action.overlayId, callback: { [weak self] val in
                                // Re-render the entire SVG (including replacing all tokens with their resolved values)
                                self?.svgParseAndRender(action: action, baseSVG: baseSVG)
                            })
                        }
                        // Do an initial rendering as well
                        self.svgParseAndRender(action: action, baseSVG: baseSVG)
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
                forInterval: CMTimeMakeWithSeconds(1, preferredTimescale: 600),
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

                    let isLivestream = self.isLivestream
                    if currentDuration > 0 && currentDuration <= optimisticCurrentTime && !isLivestream {
                        self.state = .ended
                        #if os(iOS)
                        self.view.setPlayButtonTo(state: self.playerConfig.showPlayAndPause ? .replay : .none)
                        #else
                        self.view.setPlayButtonTo(state: .replay)
                        #endif
                    }

                    self.videoAnalyticsService.currentItemIsLive = isLivestream

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

        let seekTime = CMTimeMakeWithSeconds(max(0, min(currentDuration - 1, elapsedSeconds)), preferredTimescale: 600)
        player.seek(to: seekTime, toleranceBefore: seekTolerance, toleranceAfter: seekTolerance, debounceSeconds: 0.5, completionHandler: { _ in })

        setControlViewVisibility(visible: true, animated: true)
    }

    private func updatePlaytimeIndicators(_ elapsedSeconds: Double, totalSeconds: Double, liveState: VideoPlayerLiveState) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }

            if liveState == .liveAndLatest {
                self.view.setTimeIndicatorLabel(elapsedText: nil, totalText: nil)
                self.view.setLiveButtonTo(state: .liveAndLatest)
            } else if elapsedSeconds.isNaN {
                self.view.setTimeIndicatorLabel(elapsedText: nil, totalText: nil)
                self.view.setLiveButtonTo(state: .notLive)
            } else {
                self.view.setTimeIndicatorLabel(elapsedText: self.formatSeconds(elapsedSeconds), totalText: self.formatSeconds(totalSeconds))
                self.view.setLiveButtonTo(state: liveState)
            }
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

    private func formatLiveViewers(_ n: Int) -> String {
        if n < 1000 { return String(describing: n) }
        if n >= 1000 && n < 1000000 { return String(describing: round(Double(n) / 100) / 10) + "K" }
        return String(describing: round(Double(n) / 100000) / 10) + "M"
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
            status.isPlaying ? pause() : play()
        }
        else {
            player.seek(to: .zero, toleranceBefore: .zero, toleranceAfter: .zero) { [weak self] finished in
                if finished {
                    self?.state = .readyToPlay
                    self?.play()
                }
            }
        }

        if playerConfig.enableControls {
            setControlViewVisibility(visible: true, animated: true)
        }
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

            if playerConfig.enableControls {
                setControlViewVisibility(visible: true, animated: true)
            }
        }
    }

    private func skipForwardButtonTapped() {
        if playerConfig.showBackForwardsButtons {
            relativeSeekWithDebouncer(amount: 10)

            if playerConfig.enableControls {
                setControlViewVisibility(visible: true, animated: true)
            }
        }
    }

    private func setInfoViewTo(visible: Bool) {
        #if os(tvOS)
        let honored = setControlViewVisibility(visible: !view.controlViewHasAlpha, animated: true, directiveLevel: .userInitiated, lock: !view.controlViewHasAlpha)
        if honored {
            view.setInfoViewVisibility(visible: !view.controlViewHasAlpha, animated: true)
        }
        #else
        setControlViewVisibility(visible: false, animated: true, directiveLevel: .userInitiated, lock: visible)
        view.setInfoViewVisibility(visible: visible, animated: true)
        #endif
    }

    #if os(iOS)
    private func controlViewTapped() {
        // Do not register taps on the control view when there is no stream url.
        guard currentStream?.url != nil else { return }

        if playerConfig.enableControls {
            if view.infoViewHasAlpha {
                view.setInfoViewVisibility(visible: false, animated: true)
                setControlViewVisibility(visible: false, animated: true, directiveLevel: .userInitiated, lock: false)
            } else {
                setControlViewVisibility(visible: !view.controlViewHasAlpha, animated: true)
            }
        }
    }

    private func liveButtonTapped() {
        let currentDuration = self.currentDuration
        guard currentDuration > 0, self.liveState != .liveAndLatest else { return }

        view.videoSlider.value = 1.0
        updatePlaytimeIndicators(currentDuration, totalSeconds: currentDuration, liveState: .liveAndLatest)

        let seekTime = CMTimeMakeWithSeconds(currentDuration, preferredTimescale: 600)
        player.seek(to: seekTime, toleranceBefore: .zero, toleranceAfter: .zero) { [weak self] finished in
            if finished {
                self?.play()
            }
        }

        if playerConfig.enableControls {
            setControlViewVisibility(visible: true, animated: true)
        }
    }

    private func fullscreenButtonTapped() {
        isFullscreen.toggle()

        if playerConfig.enableControls {
            setControlViewVisibility(visible: true, animated: true)
        }
    }

    private func infoButtonTapped() {
        let visible = !view.infoViewHasAlpha
        setInfoViewTo(visible: visible)
    }
    #endif

    #if os(tvOS)
    private func selectPressed() {
        let visible = !view.controlViewHasAlpha
        setInfoViewTo(visible: visible)
    }

    private func leftArrowTapped() {
        skipBackButtonTapped()
    }

    private func rightArrowTapped() {
        skipForwardButtonTapped()
    }
    #endif
}

extension VideoPlayerImpl: AVAssetResourceLoaderDelegate {
    func resourceLoader(_ resourceLoader: AVAssetResourceLoader, shouldWaitForLoadingOfRequestedResource loadingRequest: AVAssetResourceLoadingRequest) -> Bool {
        guard let requestUrl = loadingRequest.request.url else {
            return false
        }

        if !["http", "https", "skd"].contains(requestUrl.scheme?.lowercased()) {
            // This is likely because of the `MLSAVPlayerNetworkInterceptor`. We always want to return false for that.
            // See that class for more information.
            if requestUrl.pathExtension == "ts" {
                // This triggers only when the m3u8 playlist internally defines relative paths, rather than absolute ones (which it only does for the legacy streaming platform). The way to handle this is inspired by: https://developer.apple.com/forums/thread/113063
                let redirect = URLRequest(url: MLSAVPlayerNetworkInterceptor.unprepare(requestUrl))
                loadingRequest.redirect = redirect
                loadingRequest.response = HTTPURLResponse(url: redirect.url!, statusCode: 302, httpVersion: nil, headerFields: nil)
                loadingRequest.finishLoading()
                return true
            } else {
                return false
            }
        }

        guard let _ = currentStream?.url,
              let licenseUrl = currentStream?.fairplay?.licenseUrl,
              let certificateUrl = currentStream?.fairplay?.certificateUrl else {
            loadingRequest.finishLoading(with: NSError(domain: "tv.mycujoo.mls", code: -10, userInfo: nil))
            return false
        }

        guard requestUrl.absoluteURL != currentStreamDRMRequestUrl else {
            // Prevent the resourceLoader from ending up in a (potentially infinite) loop.
            // This seems to happen when the loadingRequest finishes with an error (it just retries instantly).
            loadingRequest.finishLoading(with: NSError(domain: "tv.mycujoo.mls", code: -20, userInfo: nil))
            return false
        }

        currentStreamDRMRequestUrl = requestUrl

        getCertificateDataUseCase.execute(url: certificateUrl) { [weak self] (certificateData, error) in
            guard let certificateData = certificateData, error == nil else {
                loadingRequest.finishLoading(with: NSError(domain: "tv.mycujoo.mls", code: -30, userInfo: nil))
                return
            }

            // Request the Server Playback Context.
            let contentId = "mls.mycujoo.tv" // TODO: Establish whether this is the most appropriate contentId.
            guard let contentIdData = contentId.data(using: String.Encoding.utf8),
                  let spcData = try? loadingRequest.streamingContentKeyRequestData(forApp: certificateData, contentIdentifier: contentIdData, options: nil),
                  let dataRequest = loadingRequest.dataRequest else {
                loadingRequest.finishLoading(with: NSError(domain: "tv.mycujoo.mls", code: -40, userInfo: nil))
                return
            }

            self?.getLicenseDataUseCase.execute(url: licenseUrl, spcData: spcData) { (licenseData, error) in
                if let licenseData = licenseData, error == nil {
                    // The CKC is correctly returned and is now send to the `AVPlayer` instance so we
                    // can continue to play the stream.
                    dataRequest.respond(with: licenseData)
                    loadingRequest.finishLoading()
                } else {
                    loadingRequest.finishLoading(with: NSError(domain: "tv.mycujoo.mls", code: -50, userInfo: nil))
                }
            }
        }

        return true
    }
}

extension VideoPlayerImpl: CastIntegrationVideoPlayerDelegate {
    func isCastingStateUpdated() {
        guard let castIntegration = castIntegration else { return }

        if castIntegration.isCasting() {
            placeCurrentStream()
        }
        else {
        }
    }
}


// MARK: - DirectiveLevel
enum DirectiveLevel: Int {
    /// A directive initiated by the system. This is the highest priority directive.
    case systemInitiated = 1000
    /// A directive initiated by the user. This is the highest priority directive except for `systemInitiated`
    case userInitiated = 750
    /// A directive that is derived from another action that happened within the system. This is the lowest priority, except `none`.
    case derived = 250
    case none = 0
}

enum VideoPlayerPlayButtonState {
    case play, pause, replay, none
}

enum VideoPlayerLiveState: Int {
    /// The viewer is watching a live stream AND is at the latest point in this live stream
    case liveAndLatest = 0
    /// The viewer is watching a live stream but is NOT at the latest point in this live stream
    case liveNotLatest = 1
    /// The viewer is not watching a live stream
    case notLive = 2
}
