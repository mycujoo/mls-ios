import Foundation

class Point: Locus {

    let x: Double
    let y: Double

    static let origin = Point(0, 0)

    init(_ x: Double, _ y: Double) {
        self.x = x
        self.y = y
    }

    init(x: Double = 0, y: Double = 0) {
        self.x = x
        self.y = y
    }

    override func bounds() -> Rect {
        return Rect(x: x, y: y, w: 0.0, h: 0.0)
    }

    func add(_ point: Point) -> Point {
        return Point( x: x + point.x, y: y + point.y)
    }

    func rect(size: Size) -> Rect {
        return Rect(point: self, size: size)
    }

    func distance(to point: Point) -> Double {
        let dx = point.x - x
        let dy = point.y - y
        return sqrt(dx * dx + dy * dy)
    }

    override func toPath() -> Path {
        return MoveTo(x: x, y: y).lineTo(x: x, y: y).build()
    }
}

extension Point: Equatable {
    static func == (lhs: Point, rhs: Point) -> Bool {
        return lhs.x == rhs.x
            && lhs.y == rhs.y
    }

    static func - (lhs: Point, rhs: Point) -> Size {
        return Size(w: lhs.x - rhs.x, h: lhs.y - rhs.y)
    }
}
