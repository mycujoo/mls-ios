class OffsetEffect: Effect {

    let dx: Double
    let dy: Double

    init(dx: Double = 0, dy: Double = 0, input: Effect? = nil) {
        self.dx = dx
        self.dy = dy
        super.init(input: input)
    }
}
