class Group: Node {

    var contentsVar: AnimatableVariable<[Node]>
    var contents: [Node] {
        get { return contentsVar.value }
        set(val) {
            contentsVar.value = val
        }
    }

    init(contents: [Node] = [], place: Transform = Transform.identity, opaque: Bool = true, opacity: Double = 1, clip: Locus? = nil, mask: Node? = nil, effect: Effect? = nil, visible: Bool = true, tag: [String] = []) {
        self.contentsVar = AnimatableVariable<[Node]>(contents)
        super.init(
            place: place,
            opaque: opaque,
            opacity: opacity,
            clip: clip,
            mask: mask,
            effect: effect,
            visible: visible,
            tag: tag
        )

        self.contents = contents
        self.contentsVar.node = self
    }

    // Searching

    override func nodeBy(tag: String) -> Node? {
        if let node = super.nodeBy(tag: tag) {
            return node
        }

        for child in contents {
            if let node = child.nodeBy(tag: tag) {
                return node
            }
        }

        return .none
    }

    override func nodesBy(tag: String) -> [Node] {
        var result = [Node]()
        contents.forEach { child in
            result.append(contentsOf: child.nodesBy(tag: tag))
        }

        if let node = super.nodeBy(tag: tag) {
            result.append(node)
        }

        return result
    }

    override var bounds: Rect? {
        let bounds = BoundsUtils.getNodesBounds(contents)
        if let bounds = bounds?.toCG(),
            let clip = self.clip?.bounds().toCG() {
            let newX = max(bounds.minX, clip.minX)
            let newY = max(bounds.minY, clip.minY)
            return Rect(Double(newX), Double(newY),
                        Double(min(bounds.maxX, clip.maxX) - newX),
                        Double(min(bounds.maxY, clip.maxY) - newY))
        }
        return bounds
    }

    override func shouldCheckForPressed() -> Bool {
        if super.shouldCheckForPressed() {
            return true
        }
        return contents.contains { $0.shouldCheckForPressed() }
    }

    override func shouldCheckForMoved() -> Bool {
        if super.shouldCheckForMoved() {
            return true
        }
        return contents.contains { $0.shouldCheckForMoved() }
    }

    override func shouldCheckForReleased() -> Bool {
        if super.shouldCheckForReleased() {
            return true
        }
        return contents.contains { $0.shouldCheckForReleased() }
    }

    override func shouldCheckForTap() -> Bool {
        if super.shouldCheckForTap() {
            return true
        }
        return contents.contains { $0.shouldCheckForTap() }
    }

    override func shouldCheckForLongTap() -> Bool {
        if super.shouldCheckForLongTap() {
            return true
        }
        return contents.contains { $0.shouldCheckForLongTap() }
    }

    override func shouldCheckForPan() -> Bool {
        if super.shouldCheckForPan() {
            return true
        }
        return contents.contains { $0.shouldCheckForPan() }
    }

    override func shouldCheckForPinch() -> Bool {
        if super.shouldCheckForPinch() {
            return true
        }

        return contents.contains { $0.shouldCheckForPinch() }
    }

    override func shouldCheckForRotate() -> Bool {
        if super.shouldCheckForRotate() {
            return true
        }
        return contents.contains { $0.shouldCheckForRotate() }
    }
}

extension Array where Element: Node {
    func group( place: Transform = Transform.identity, opaque: Bool = true, opacity: Double = 1, clip: Locus? = nil, effect: Effect? = nil, visible: Bool = true, tag: [String] = []) -> Group {
        return Group(contents: self, place: place, opaque: opaque, opacity: opacity, clip: clip, effect: effect, visible: visible, tag: tag)
    }
}
