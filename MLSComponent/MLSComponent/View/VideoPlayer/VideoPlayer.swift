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

    // MARK: - Private properties

    private let player = AVPlayer()
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
        guard let duration = player.currentItem?.duration else { return }
        let seconds = CMTimeGetSeconds(duration)

        guard !seconds.isNaN else { return }
        let secondsText = String(format: "%02d", Int(seconds.truncatingRemainder(dividingBy: 60)))
        let minutesText = String(format: "%02d", Int(seconds) / 60)
        view.videoLengthLabel.text = "\(minutesText):\(secondsText)"
    }
}

// MARK: - Public Methods
public extension VideoPlayer {

    func play() { status = .play }

    func pause() { status = .pause }

    func playVideo(with event: Event, isAutoStart: Bool = true) {
        self.event = event
        if isAutoStart { play() }
    }
}

// MARK: - Private Methods
extension VideoPlayer {
    private func trackTime(with player: AVPlayer) -> Any {
        player
            .addPeriodicTimeObserver(
                forInterval: CMTime(value: 1, timescale: 2),
                queue: .main) { (progressTime) in
                    let seconds = CMTimeGetSeconds(progressTime)
                    let secondsString = String(format: "%02d", Int(seconds.truncatingRemainder(dividingBy: 60)))
                    let minutesString = String(format: "%02d", Int(seconds / 60))

                    self.view.currentTimeLabel.text = "\(minutesString):\(secondsString)"
                    self.delegate?.playerDidUpdateTime(player: self)

                    if let duration = player.currentItem?.duration, duration.value != 0 {

                        let durationSeconds = CMTimeGetSeconds(duration)
                        self.view.videoSlider.value = seconds / durationSeconds

                        if durationSeconds <= seconds {
                            self.state = .ended
                        }
                    }
        }
    }

    private func sliderUpdated(with value: Double) {
        guard let duration = player.currentItem?.duration, duration.value != 0 else { return }
        let totalSeconds = CMTimeGetSeconds(duration)
        let seekTime = CMTime(value: Int64(Float64(value) * totalSeconds), timescale: 1)
        player.seek(to: seekTime, completionHandler: { _ in })
    }

    private func playButtonTapped() {
        status.toggle()
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
    func playerDidUpdatePlaying(player: VideoPlayer)
    func playerDidUpdateTime(player: VideoPlayer)
    func playerDidUpdateState(player: VideoPlayer)
}
