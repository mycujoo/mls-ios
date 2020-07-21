class Stroke {

    let fill: Fill
    let width: Double
    let cap: LineCap
    let join: LineJoin
    let miterLimit: Double
    let dashes: [Double]
    let offset: Double

    init(fill: Fill = Color.black, width: Double = 1, cap: LineCap = .butt, join: LineJoin = .miter, miterLimit: Double = 10, dashes: [Double] = [], offset: Double = 0.0) {
        self.fill = fill
        self.width = width
        self.cap = cap
        self.join = join
        self.miterLimit = miterLimit
        self.dashes = dashes
        self.offset = offset
    }
}
