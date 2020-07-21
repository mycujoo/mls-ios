class PanEvent: MacawEvent {

    let dx: Double
    let dy: Double
    let count: Int

    init(node: Node, dx: Double, dy: Double, count: Int) {
        self.dx = dx
        self.dy = dy
        self.count = count
        super.init(node: node)
    }

}
