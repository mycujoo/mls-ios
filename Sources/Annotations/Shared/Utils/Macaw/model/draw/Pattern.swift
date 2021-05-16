class Pattern: Fill {

    let content: Node
    let bounds: Rect
    let userSpace: Bool

    init(content: Node, bounds: Rect, userSpace: Bool = false) {
        self.content = content
        self.bounds = bounds
        self.userSpace = userSpace
    }
}
