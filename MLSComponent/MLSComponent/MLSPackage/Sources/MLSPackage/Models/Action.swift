//
// Copyright © 2020 mycujoo. All rights reserved.
//

import Foundation

public enum Action: Equatable {
    case hide(by: ID)
    case show(Kind)
    case update(Kind)
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
