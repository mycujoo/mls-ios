//
// Copyright © 2020 mycujoo. All rights reserved.
//

import AVFoundation

public class VideoPlayer {

    // MARK: - Public properties
    public var state: State = .idle
    public weak var delegate: PlayerDelegate?
    public private(set) var view = VideoPlayerView()

    public var event: Event? {
        didSet {
            guard let stream = event?.stream else { return }
            player.replaceCurrentItem(with: AVPlayerItem(url: stream.urls.first))
        }
    }

    public var status: Status = .pause {
        didSet {
            switch status {
            case .play:
                player.play()
            case .pause:
                player.pause()
            }
            delegate?.playerDidUpdatePlaying(player: self)
        }
    }

    // MARK: - Private properties

    private var player = AVPlayer()
}

// MARK: - Public Methods
public extension VideoPlayer {

    convenience init(with event: Event?) {
        self.init()
        self.event = event
    }

    func play() {
        status = .play
    }

    func pause() {
        status = .pause
    }

    func playVideo(with event: Event, isAutoStart: Bool = true) {
        self.event = event
        if isAutoStart { play() }
    }
}

// MARK: - State
public extension VideoPlayer {
    enum State {
        /// The player does not have any media to play
        case idle
        /// The player is not able to immediately play from its current position. This state typically occurs when more data needs to be loaded
        case buffering
        /// The player is able to immediately play from its current position.
        case ready
        /// The player has finished playing the media
        case ended
        /// Indicates that the player can no longer play.
        case failed
    }
}

// MARK: - Delegate
public protocol PlayerDelegate: AnyObject {
    func playerDidUpdatePlaying(player: VideoPlayer)
    func playerDidUpdateTime(player: VideoPlayer)
}
