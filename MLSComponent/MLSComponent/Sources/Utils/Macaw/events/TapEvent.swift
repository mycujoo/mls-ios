class TapEvent: MacawEvent {

    let location: Point

    init(node: Node, location: Point) {
        self.location = location
        super.init(node: node)
    }

}
