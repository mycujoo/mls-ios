//
// Copyright © 2020 mycujoo. All rights reserved.
//

import Foundation

enum VideoPlayStatus {
    
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
    
    var isPlaying: Bool {
        return self == .play
    }
    
}
