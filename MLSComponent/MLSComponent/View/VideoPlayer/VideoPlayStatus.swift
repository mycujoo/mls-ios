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
}
