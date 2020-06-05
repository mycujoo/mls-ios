//
// Copyright © 2020 mycujoo. All rights reserved.
//

import UIKit

public struct Overlay: Hashable {
    let id: String
    let kind: Kind
    let side: Side
    let timestamp: TimeInterval

    public init(id: String, kind: Kind, side: Side, timestamp: TimeInterval) {
        self.id = id
        self.kind = kind
        self.side = side
        self.timestamp = timestamp
    }
}

public extension Overlay {
    enum Kind: Hashable {
        case singleLineText(String)
    }
}

public extension Overlay {
    enum Side {
        case topLeft
        case bottomLeft
        case topRight
        case bottomRight
    }
}
