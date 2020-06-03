//
// Copyright © 2020 mycujoo. All rights reserved.
//

public enum VideoPlayStatus {
    
    case play
    case pause
    
    mutating func setOpposite() {
        switch self {
        case .play:
            self = .pause
        case .pause:
            self = .play
        }
    }
    public var isPlaying: Bool { self == .play }
}
