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
        case play, pause, replay, none
    }

    enum LiveState: Int {
        /// The viewer is watching a live stream AND is at the latest point in this live stream
        case liveAndLatest = 0
        /// The viewer is watching a live stream but is NOT at the latest point in this live stream
        case liveNotLatest = 1
        /// The viewer is not watching a live stream
        case notLive = 2
    }
}
