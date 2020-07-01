//
// Copyright © 2020 mycujoo. All rights reserved.
//

public extension VideoPlayer {
    enum Status {

        case play
        case pause

        public mutating func toggle() {
            switch self {
            case .play:
                self = .pause
            case .pause:
                self = .play
            }
        }
        public var isPlaying: Bool { self == .play }
    }

    enum PlayButtonState {
        case play, pause, replay
    }

    enum LiveState {
        /// The viewer is watching a live stream AND is at the latest point in this live stream
        case liveAndLatest
        /// The viewer is watching a live stream but is NOT at the latest point in this live stream
        case liveNotLatest
        /// The viewer is not watching a live stream
        case notLive
    }
}
