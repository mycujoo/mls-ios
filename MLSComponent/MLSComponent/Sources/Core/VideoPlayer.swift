//
// Copyright © 2020 mycujoo. All rights reserved.
//

import AVFoundation
import UIKit
import YouboraAVPlayerAdapter
import YouboraLib

public class VideoPlayer: NSObject {

    // MARK: - Public properties

    public weak var delegate: PlayerDelegate?
    public private(set) var view = VideoPlayerView()

    public private(set) var state: State = .unknown {
        didSet {
            delegate?.playerDidUpdateState(player: self)
        }
    }

    public var event: Event? {
        didSet {
            guard let stream = event?.stream else { return }

            player.replaceCurrentItem(with: AVPlayerItem(url: stream.urls.first))
            view.drawPlayer(with: player)
        }
    }

    public private(set) var status: Status = .pause {
        didSet {
            switch status {
            case .play:
                player.play()
            case .pause:
                player.pause()
            }
            if #available(iOS 13.0, tvOS 13.0, *) {
                let image = status.isPlaying ? UIImage(systemName: "pause.fill") : UIImage(systemName: "play.fill")
                view.playButton.setImage(image, for: .normal)
            }
            delegate?.playerDidUpdatePlaying(player: self)
        }
    }

    public var currentTime: Double {
        (CMTimeGetSeconds(player.currentTime()) * 10).rounded() / 10
    }

    /// - returns: The duration of the currentItem. If unknown, returns 0.
    public var currentDuration: Double {
        guard let duration = player.currentItem?.duration else { return 0 }
        let seconds = CMTimeGetSeconds(duration)
        guard !seconds.isNaN else { return 0 }

        return seconds
    }

    private(set) public var annotations: [Annotation] = [] {
        didSet {
            evaluateAnnotations()
            delegate?.playerDidUpdateAnnotations(player: self)
        }
    }

    // MARK: - Private properties

    private let player = AVPlayer()
    private let seekThrottler = Throttler(minimumDelay: 0.3)
    /// Indicates whether the player is currently seeking (or will shortly be seeking, if it is being throttled).
    private var isSeeking = false
    private var timeObserver: Any?
    private lazy var youboraPlugin: YBPlugin = {
        let options = YBOptions()
        options.accountCode = "mycujoo"
        options.username = "mls"
        let plugin = YBPlugin(options: options)
        plugin.adapter = YBAVPlayerAdapterSwiftTranformer.transform(from: YBAVPlayerAdapter(player: player))
        return plugin
    }()

    // MARK: - Methods

    public override init() {
        super.init()
        player.addObserver(self, forKeyPath: "currentItem.loadedTimeRanges", options: .new, context: nil)
        player.addObserver(self, forKeyPath: "status", options: .new, context: nil)
        timeObserver = trackTime(with: player)
        view.onTimeSliderSlide(sliderUpdated)
        view.onPlayButtonTapped(playButtonTapped)
        youboraPlugin.fireInit()
    }

    deinit {
        if let timeObserver = timeObserver { player.removeTimeObserver(timeObserver) }
        player.removeObserver(self, forKeyPath: "currentItem.loadedTimeRanges")
        player.removeObserver(self, forKeyPath: "status")
        youboraPlugin.fireStop()
    }
    
    //MARK: - KVO

    public override func observeValue(
        forKeyPath keyPath: String?,
        of object: Any?,
        change: [NSKeyValueChangeKey : Any]?,
        context: UnsafeMutableRawPointer?
    ) {
        switch keyPath {
        case "currentItem.loadedTimeRanges":
            handleNewLoadedTimeRanges()
        case "status":
            state = State(rawValue: player.status.rawValue) ?? .unknown
        default:
            break
        }
    }

    private func handleNewLoadedTimeRanges() {
        view.activityIndicatorView?.stopAnimating()
        let seconds = self.currentDuration
        guard seconds > 0 else { return }
        let secondsText = String(format: "%02d", Int(seconds.truncatingRemainder(dividingBy: 60)))
        let minutesText = String(format: "%02d", Int(seconds) / 60)
        view.videoLengthLabel.text = "\(minutesText):\(secondsText)"
    }
}

// MARK: - Public Methods
public extension VideoPlayer {

    func play() { status = .play }

    func pause() { status = .pause }

    func playVideo(with event: Event, autoplay: Bool = true) {
        self.event = event
        if autoplay { play() }
    }

    #if os(iOS)
    func placePlayerView(in view: UIView) {
        view.addSubview(self.view)
        self.view.translatesAutoresizingMaskIntoConstraints = false
        self.view.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        self.view.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        self.view.heightAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 9 / 16).isActive = true
        self.view.bottomAnchor.constraint(lessThanOrEqualTo: view.bottomAnchor).isActive = true

        let leading = self.view.leadingAnchor.constraint(equalTo: view.leadingAnchor)
        leading.priority = .defaultHigh
        leading.isActive = true

        let trailing = self.view.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        trailing.priority = .defaultHigh
        trailing.isActive = true
    }
    #endif
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
                    guard !self.isSeeking else { return }

                    let durationSeconds = self.currentDuration
                    let seconds = CMTimeGetSeconds(progressTime)

                    if !self.view.videoSlider.isTracking {
                        let secondsString = String(format: "%02d", Int(seconds.truncatingRemainder(dividingBy: 60)))
                        let minutesString = String(format: "%02d", Int(seconds / 60))

                        self.view.currentTimeLabel.text = "\(minutesString):\(secondsString)"

                        if durationSeconds > 0 {
                            self.view.videoSlider.value = seconds / durationSeconds
                        }
                    }

                    if durationSeconds > 0 && durationSeconds <= seconds {
                        self.state = .ended
                    }

                    self.delegate?.playerDidUpdateTime(player: self)

                    self.evaluateAnnotations()

        }
    }

    private func sliderUpdated(with value: Double) {
        let totalSeconds = self.currentDuration
        guard totalSeconds > 0 else { return }

        seekThrottler.throttle { [weak self] in
            let seekTime = CMTime(value: Int64(Float64(value) * totalSeconds), timescale: 1)
            self?.seek(to: seekTime, completionHandler: { _ in })
        }
    }

    private func playButtonTapped() {
        status.toggle()
    }

    /// Use this method to seek instead of calling it on the player directly, to ensure the `isSeeking` property stays correct.
    private func seek(to time: CMTime, completionHandler: @escaping (Bool) -> Void) {
        isSeeking = true
        player.seek(to: time) { [weak self] b in
            self?.isSeeking = false
            completionHandler(b)
        }
    }
}

extension VideoPlayer {
    private func evaluateAnnotations() {
        // TODO: Run this on a background thread.

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

        // TODO: Do this on the main thread
        self.view.videoSlider.setTimelineMarkers(with: showTimelineMarkers)
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
    /// The player has updated the list of known annotations. To access the current list of known annotations for the associated timeline, see `VideoPlayer.annotations`
    /// - note: This does not have any relationship with the annotations that are currently being executed. This method is only called when the datasource refreshes.
    func playerDidUpdateAnnotations(player: VideoPlayer)
}
