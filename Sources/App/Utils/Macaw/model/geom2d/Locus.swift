class Locus {

    init() {
    }

    func bounds() -> Rect {
        return Rect()
    }

    func stroke(with: Stroke) -> Shape {
        return Shape(form: self, stroke: with)
    }

    func fill(with: Fill) -> Shape {
        return Shape(form: self, fill: with)
    }

    func fill(_ hex: Int) -> Shape {
        return Shape(form: self, fill: Color(val: hex))
    }

    func fill(_ fill: Fill) -> Shape {
        return Shape(form: self, fill: fill)
    }

    func stroke(fill: Fill = Color.black, width: Double = 1, cap: LineCap = .butt, join: LineJoin = .miter, dashes: [Double] = []) -> Shape {
        return Shape(form: self, stroke: Stroke(fill: fill, width: width, cap: cap, join: join, dashes: dashes))
    }

    func stroke(color: Color, width: Double = 1, cap: LineCap = .butt, join: LineJoin = .miter, dashes: [Double] = []) -> Shape {
        return Shape(form: self, stroke: Stroke(fill: color, width: width, cap: cap, join: join, dashes: dashes))
    }

    func stroke(color: Int, width: Double = 1, cap: LineCap = .butt, join: LineJoin = .miter, dashes: [Double] = []) -> Shape {
        return Shape(form: self, stroke: Stroke(fill: Color(color), width: width, cap: cap, join: join, dashes: dashes))
    }

    func toPath() -> Path {
        fatalError("Unsupported locus: \(self)")
    }
}
