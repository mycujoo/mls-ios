class RoundRect: Locus {

    let rect: Rect
    let rx: Double
    let ry: Double

    init(rect: Rect, rx: Double = 0, ry: Double = 0) {
        self.rect = rect
        self.rx = rx
        self.ry = ry
    }

    override func bounds() -> Rect {
        return rect
    }
}
