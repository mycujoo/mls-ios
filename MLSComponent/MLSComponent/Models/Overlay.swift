//
// Copyright © 2020 mycujoo. All rights reserved.
//

public struct Overlay: Equatable {
    let id: String
    let kind: Kind
    let side: Side
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
