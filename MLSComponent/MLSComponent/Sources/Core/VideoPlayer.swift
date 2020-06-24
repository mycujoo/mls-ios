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

            replaceCurrentItem(url: stream.urls.first)
        }
    }

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
            delegate?.playerDidUpdatePlaying(player: self)
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

    /// - returns: The duration of the currentItem. If unknown, returns 0.
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
            evaluateAnnotations()
            delegate?.playerDidUpdateAnnotations(player: self)
        }
    }

    // MARK: - Private properties

    private let player = MLSAVPlayer()
    private var timeObserver: Any?
    private lazy var youboraPlugin: YBPlugin = {
        let options = YBOptions()
        options.accountCode = "mycujoo"
        options.username = "mls"
        let plugin = YBPlugin(options: options)
        plugin.adapter = YBAVPlayerAdapterSwiftTranformer.transform(from: YBAVPlayerAdapter(player: player))
        return plugin
    }()

    private lazy var annotationsQueue = DispatchQueue(label: "tv.mycujoo.mls.annotations-queue")

    // MARK: - Internal properties

    /// Setting the playerConfig will automatically updates the associated views and behavior.
    /// However, this should not be exposed to the SDK user directly, since it should only be configurable through the MLS console / API.
    var playerConfig = PlayerConfig.standard() {
        didSet {
            DispatchQueue.main.async { [weak self] in
                guard let `self` = self else { return }
                self.view.primaryColor = UIColor(hex: self.playerConfig.primaryColor)
                // TODO: Reconfigure other options as well.
            }
        }
    }

    // MARK: - Methods

    public override init() {
        super.init()
        player.addObserver(self, forKeyPath: "status", options: .new, context: nil)
        player.addObserver(self, forKeyPath: "timeControlStatus", options: [.old, .new], context: nil)
        timeObserver = trackTime(with: player)

        func initPlayerView() {
            view = VideoPlayerView()
            view.setOnTimeSliderSlide(sliderUpdated)
            view.setOnPlayButtonTapped(playButtonTapped)
            #if os(iOS)
            view.setOnFullscreenButtonTapped(fullscreenButtonTapped)
            #endif
            view.drawPlayer(with: player)
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
    private func replaceCurrentItem(url: URL) {
        // TODO: generate the user-agent elsewhere.
        let headerFields: [String: String] = ["user-agent": "tv.mycujoo.mls.ios-sdk"]
        let asset = AVURLAsset(url: url, options: ["AVURLAssetHTTPHeaderFieldsKey": headerFields])
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
                }
            default:
                // TODO: Handle failed/cancelled cases.
                break
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
        if playerConfig.autoplay {
            play()
        }
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

                    if !self.view.videoSlider.isTracking {
                        self.updatetimeIndicatorLabel(seconds, totalSeconds: durationSeconds)

                        if durationSeconds > 0 {
                            self.view.videoSlider.value = seconds / durationSeconds
                        }
                    }

                    if durationSeconds > 0 && durationSeconds <= seconds && !self.isLivestream {
                        self.state = .ended
                        self.view.setPlayButtonTo(state: .replay)
                    }

                    self.delegate?.playerDidUpdateTime(player: self)

                    self.evaluateAnnotations()
        }
    }

    private func sliderUpdated(with fraction: Double) {
        let totalSeconds = self.currentDuration
        guard totalSeconds > 0 else { return }

        let elapsedSeconds = Float64(fraction) * totalSeconds

        updatetimeIndicatorLabel(elapsedSeconds, totalSeconds: totalSeconds)

        let seekTime = CMTime(value: Int64(elapsedSeconds), timescale: 1)
        player.seek(to: seekTime, debounceSeconds: 0.5, completionHandler: { _ in })
    }

    private func updatetimeIndicatorLabel(_ elapsedSeconds: Double, totalSeconds: Double) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.view.setTimeIndicatorLabel(elapsedText: self.formatSeconds(elapsedSeconds), totalText: self.formatSeconds(totalSeconds))
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
            player.seek(to: .zero) { [weak self] finished in
                if finished {
                    self?.state = .readyToPlay
                    self?.play()
                }
            }
        }
    }

    #if os(iOS)
    private func fullscreenButtonTapped() {
        isFullscreen.toggle()
    }
    #endif
}

extension VideoPlayer {
    private func evaluateAnnotations() {
        annotationsQueue.async { [weak self] in
            guard let self = self else { return }

            let duration = self.currentDuration
            guard duration > 0 else { return }

            let currentTime = self.currentTime
            let annotations = self.annotations

            var showTimelineMarkers: [(position: Double, marker: TimelineMarker)] = []
            for annotation in annotations {
                for action in annotation.actions {
                    switch action {
                    case .showTimelineMarker(let data):
                        let color = UIColor(hex: data.color) ?? UIColor.gray
                        // There should not be multiple timeline markers for a single annotation, so reuse annotation id on the timeline marker.
                        let timelineMarker = TimelineMarker(id: annotation.id, kind: .singleLineText(text: data.label), markerColor: color, timestamp: TimeInterval(annotation.offset / 1000))
                        showTimelineMarkers.append((position: min(1.0, max(0.0, timelineMarker.timestamp / duration)), marker: timelineMarker))
    //                case .showOverlay(let data):
    //                    break
    //                case .hideOverlay(let data):
    //                    break
    //                case .setVariable(let data):
    //                    break
    //                case .incrementVariable(let data):
    //                    break
    //                case .createTimer(let data):
    //                    break
    //                case .startTimer(let data):
    //                    break
    //                case .pauseTimer(let data):
    //                    break
    //                case .adjustTimer(let data):
    //                    break
    //                case .unsupported:
    //                    break
                    default:
                        break
                    }
                }
            }

            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.view.videoSlider.setTimelineMarkers(with: showTimelineMarkers)
            }
        }

    }


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
