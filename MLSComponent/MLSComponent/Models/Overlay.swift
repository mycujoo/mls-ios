//
// Copyright © 2020 mycujoo. All rights reserved.
//

public struct Overlay: Equatable {
    let id: String
    let kind: Kind
    let side: Side

    public init(id: String, kind: Kind, side: Side) {
        self.id = id
        self.kind = kind
        self.side = side
    }
}

public extension Overlay {
    enum Kind: Equatable {
        case singleLineText(String)
        case doubleLineText(title: String, subTitle: String)
        case scoreBoard(leftScore: String, rightScore: String)
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
