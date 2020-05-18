//
// Copyright © 2020 mycujoo. All rights reserved.
//

public struct Overlay {
    let id: String
    let kind: Kind
    let side: Side
}

public extension Overlay {
    enum Kind {

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
