import Foundation

class Size {

    let w: Double
    let h: Double

    static let zero = Size(0, 0)

    init(_ w: Double, _ h: Double) {
        self.w = w
        self.h = h
    }

    init(w: Double = 0, h: Double = 0) {
        self.w = w
        self.h = h
    }

    func rect(at point: Point = Point.origin) -> Rect {
        return Rect(point: point, size: self)
    }

    func angle() -> Double {
        return atan2(h, w)
    }

}

extension Size {

    static func == (lhs: Size, rhs: Size) -> Bool {
        return lhs.w == rhs.w && lhs.h == rhs.h
    }

    static func + (lhs: Size, rhs: Size) -> Size {
        return Size(w: lhs.w + rhs.w, h: lhs.h + rhs.h)
    }

    static func - (lhs: Size, rhs: Size) -> Size {
        return Size(w: lhs.w - rhs.w, h: lhs.h - rhs.h)
    }

}
