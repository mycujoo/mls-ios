class Line: Locus {

    let x1: Double
    let y1: Double
    let x2: Double
    let y2: Double

    init(_ x1: Double, _ y1: Double, _ x2: Double, _ y2: Double) {
        self.x1 = x1
        self.y1 = y1
        self.x2 = x2
        self.y2 = y2
    }

    init(x1: Double = 0, y1: Double = 0, x2: Double = 0, y2: Double = 0) {
        self.x1 = x1
        self.y1 = y1
        self.x2 = x2
        self.y2 = y2
    }

    override func bounds() -> Rect {
        return Rect(x: min(x1, x2), y: min(y1, y2), w: abs(x1 - x2), h: abs(y1 - y2))
    }

    override func toPath() -> Path {
        return MoveTo(x: x1, y: y1).lineTo(x: x2, y: y2).build()
    }
}
