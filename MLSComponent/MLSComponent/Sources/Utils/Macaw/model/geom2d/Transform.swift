import Foundation

final class Transform {

    let m11: Double
    let m12: Double
    let m21: Double
    let m22: Double
    let dx: Double
    let dy: Double

    static let identity = Transform()

    init(_ m11: Double, _ m12: Double, _ m21: Double, _ m22: Double, _ dx: Double, _ dy: Double) {
        self.m11 = m11
        self.m12 = m12
        self.m21 = m21
        self.m22 = m22
        self.dx = dx
        self.dy = dy
    }

    init(m11: Double = 1, m12: Double = 0, m21: Double = 0, m22: Double = 1, dx: Double = 0, dy: Double = 0) {
        self.m11 = m11
        self.m12 = m12
        self.m21 = m21
        self.m22 = m22
        self.dx = dx
        self.dy = dy
    }

    func move(_ dx: Double, _ dy: Double) -> Transform {
        return move(dx: dx, dy: dy)
    }

    func move(dx: Double = 0, dy: Double = 0) -> Transform {
        return Transform(m11: m11, m12: m12, m21: m21, m22: m22,
                         dx: dx * m11 + dy * m21 + self.dx,
                         dy: dx * m12 + dy * m22 + self.dy)
    }

    func scale(sx: Double = 0, sy: Double = 0) -> Transform {
        return Transform(m11: m11 * sx, m12: m12 * sx, m21: m21 * sy, m22: m22 * sy, dx: dx, dy: dy)
    }

    func scale(_ sx: Double, _ sy: Double) -> Transform {
        return scale(sx: sx, sy: sy)
    }

    func shear(shx: Double = 0, shy: Double = 0) -> Transform {
        return Transform(m11: m11 + m21 * shy, m12: m12 + m22 * shy,
                         m21: m11 * shx + m21, m22: m12 * shx + m22, dx: dx, dy: dy)
    }

    func shear(_ shx: Double, _ shy: Double) -> Transform {
        return shear(shx: shx, shy: shy)
    }

    func rotate(angle: Double) -> Transform {
        let asin = sin(angle)
        let acos = cos(angle)
        return Transform(m11: acos * m11 + asin * m21, m12: acos * m12 + asin * m22,
                         m21: -asin * m11 + acos * m21, m22: -asin * m12 + acos * m22,
                         dx: dx, dy: dy)
    }

    func rotate(_ angle: Double) -> Transform {
        return rotate(angle: angle)
    }

    func rotate(angle: Double, x: Double = 0, y: Double = 0) -> Transform {
        return move(dx: x, dy: y).rotate(angle: angle).move(dx: -x, dy: -y)
    }

    func rotate(_ angle: Double, _ x: Double, _ y: Double) -> Transform {
        return rotate(angle: angle, x: x, y: y)
    }

    class func move(dx: Double = 0, dy: Double = 0) -> Transform {
        return Transform(dx: dx, dy: dy)
    }

    class func move(_ dx: Double, _ dy: Double) -> Transform {
        return Transform(dx: dx, dy: dy)
    }

    class func scale(sx: Double = 0, sy: Double = 0) -> Transform {
        return Transform(m11: sx, m22: sy)
    }

    class func scale(_ sx: Double, _ sy: Double) -> Transform {
        return Transform(m11: sx, m22: sy)
    }

    class func shear(shx: Double = 0, shy: Double = 0) -> Transform {
        return Transform(m12: shy, m21: shx)
    }

    class func shear(_ shx: Double, _ shy: Double) -> Transform {
        return Transform(m12: shy, m21: shx)
    }

    class func rotate(angle: Double) -> Transform {
        let asin = sin(angle); let acos = cos(angle)
        return Transform(m11: acos, m12: asin, m21: -asin, m22: acos)
    }

    class func rotate(_ angle: Double) -> Transform {
        return rotate(angle: angle)
    }

    class func rotate(angle: Double, x: Double = 0, y: Double = 0) -> Transform {
        return Transform.move(dx: x, dy: y).rotate(angle: angle).move(dx: -x, dy: -y)
    }

    class func rotate(_ angle: Double, _ x: Double, _ y: Double) -> Transform {
        return rotate(angle: angle, x: x, y: y)
    }

    func concat(with: Transform) -> Transform {
        let nm11 = with.m11 * m11 + with.m12 * m21
        let nm21 = with.m21 * m11 + with.m22 * m21
        let ndx = with.dx * m11 + with.dy * m21 + dx
        let nm12 = with.m11 * m12 + with.m12 * m22
        let nm22 = with.m21 * m12 + with.m22 * m22
        let ndy = with.dx * m12 + with.dy * m22 + dy
        return Transform(m11: nm11, m12: nm12, m21: nm21, m22: nm22, dx: ndx, dy: ndy)
    }

    func apply(to: Point) -> Point {
        let x = m11 * to.x + m12 * to.y + dx
        let y = m21 * to.x + m22 * to.y + dy
        return Point(x: x, y: y)
    }

    func invert() -> Transform? {
        if m11 == 1 && m12 == 0 && m21 == 0 && m22 == 1 {
            return .move(dx: -dx, dy: -dy)
        }

        let det = self.m11 * self.m22 - self.m12 * self.m21
        if det == 0 {
            return nil
        }
        return Transform(m11: m22 / det, m12: -m12 / det,
                         m21: -m21 / det, m22: m11 / det,
                         dx: (m21 * dy - m22 * dx) / det,
                         dy: (m12 * dx - m11 * dy) / det)
    }
}
