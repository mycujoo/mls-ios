//
// Copyright © 2020 mycujoo. All rights reserved.
//

import Foundation

public enum Action: Equatable {
    case show(Kind)
    case hide(by: ID)
}

public extension Action {
    enum ID: Equatable {
        case overlay(id: String, timestamp: TimeInterval)
        case timelineMarker(id: String, timestamp: TimeInterval)
    }
}

public extension Action {
    enum Kind: Equatable {
        case overlay(Overlay)
        case timelineMaker(TimelineMarker)
    }
}
