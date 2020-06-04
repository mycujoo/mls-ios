//
// Copyright © 2020 mycujoo. All rights reserved.
//

public class VideoPlayer {

    // MARK: - Public properties

    public var status: Status = .pause
    public var state: State = .idle
    public weak var delegate: PlayerDelegate?
    public private(set) var view = VideoPlayerView()
}

// MARK: - Public Methods
public extension VideoPlayer {
    func play() {

    }

    func pause() {

    }

    func playVideo(with event: Event) {

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
