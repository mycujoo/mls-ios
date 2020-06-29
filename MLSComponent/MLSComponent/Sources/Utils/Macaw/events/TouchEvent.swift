//
//  TouchEvent.swift
//  Pods
//
//  Created by Victor Sukochev on 13/02/2017.
//
//

#if os(iOS) || os(tvOS)
import UIKit
#elseif os(OSX)
import AppKit
#endif

enum Relativity {
    case parent
    case scene
    case view
}

class NodePath {
    let node: Node
    let location: CGPoint
    let parent: NodePath?

    init(node: Node, location: CGPoint, parent: NodePath? = nil) {
        self.node = node
        self.location = location
        self.parent = parent
    }
}

struct TouchPoint {
    let id: Int
    @available(*, deprecated) var location: Point // absolute location
    { return absoluteLocation }

    private let absoluteLocation: Point
    private let relativeLocation: Point // location inside the node
    private let viewLocation: Point // location relative to containing view - no content layout or zoom transformations

    init(id: Int, location: Point, relativeToNodeLocation: Point, relativeToViewLocation: Point) {
        self.id = id
        self.absoluteLocation = location
        self.relativeLocation = relativeToNodeLocation
        self.viewLocation = relativeToViewLocation
    }

    func location(in relativity: Relativity = .parent) -> Point {
        switch relativity {
        case .parent:
            return relativeLocation
        case .scene:
            return absoluteLocation
        case .view:
            return viewLocation
        }
    }
}

class TouchEvent: MacawEvent {

    let points: [TouchPoint]

    init(node: Node, points: [TouchPoint]) {
        self.points = points

        super.init(node: node)
    }
}
