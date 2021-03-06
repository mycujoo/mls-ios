class PathBuilder {

    let segment: PathSegment
    let rest: PathBuilder?

    init(segment: PathSegment, rest: PathBuilder? = nil) {
        self.segment = segment
        self.rest = rest
    }

    func moveTo(x: Double, y: Double) -> PathBuilder {
        return M(x, y)
    }

    func lineTo(x: Double, y: Double) -> PathBuilder {
        return L(x, y)
    }

    func cubicTo(x1: Double, y1: Double, x2: Double, y2: Double, x: Double, y: Double) -> PathBuilder {
        return C(x1, y1, x2, y2, x, y)
    }

    func quadraticTo(x1: Double, y1: Double, x: Double, y: Double) -> PathBuilder {
        return Q(x1, y1, x, y)
    }

    func arcTo(rx: Double, ry: Double, angle: Double, largeArc: Bool, sweep: Bool, x: Double, y: Double) -> PathBuilder {
        return A(rx, ry, angle, largeArc, sweep, x, y)
    }

    func close() -> PathBuilder {
        return Z()
    }

    func m(_ x: Double, _ y: Double) -> PathBuilder {
        return PathBuilder(segment: PathSegment(type: .m, data: [x, y]), rest: self)
    }

    func M(_ x: Double, _ y: Double) -> PathBuilder {
        return PathBuilder(segment: PathSegment(type: .M, data: [x, y]), rest: self)
    }

    func l(_ x: Double, _ y: Double) -> PathBuilder {
        return PathBuilder(segment: PathSegment(type: .l, data: [x, y]), rest: self)
    }

    func L(_ x: Double, _ y: Double) -> PathBuilder {
        return PathBuilder(segment: PathSegment(type: .L, data: [x, y]), rest: self)
    }

    func h(_ x: Double) -> PathBuilder {
        return PathBuilder(segment: PathSegment(type: .h, data: [x]), rest: self)
    }

    func H(_ x: Double) -> PathBuilder {
        return PathBuilder(segment: PathSegment(type: .H, data: [x]), rest: self)
    }

    func v(_ y: Double) -> PathBuilder {
        return PathBuilder(segment: PathSegment(type: .v, data: [y]), rest: self)
    }

    func V(_ y: Double) -> PathBuilder {
        return PathBuilder(segment: PathSegment(type: .V, data: [y]), rest: self)
    }

    func c(_ x1: Double, _ y1: Double, _ x2: Double, _ y2: Double, _ x: Double, _ y: Double) -> PathBuilder {
        return PathBuilder(segment: PathSegment(type: .c, data: [x1, y1, x2, y2, x, y]), rest: self)
    }

    func C(_ x1: Double, _ y1: Double, _ x2: Double, _ y2: Double, _ x: Double, _ y: Double) -> PathBuilder {
        return PathBuilder(segment: PathSegment(type: .C, data: [x1, y1, x2, y2, x, y]), rest: self)
    }

    func s(_ x2: Double, _ y2: Double, _ x: Double, _ y: Double) -> PathBuilder {
        return PathBuilder(segment: PathSegment(type: .s, data: [x2, y2, x, y]), rest: self)
    }

    func S(_ x2: Double, _ y2: Double, _ x: Double, _ y: Double) -> PathBuilder {
        return PathBuilder(segment: PathSegment(type: .S, data: [x2, y2, x, y]), rest: self)
    }

    func q(_ x1: Double, _ y1: Double, _ x: Double, _ y: Double) -> PathBuilder {
        return PathBuilder(segment: PathSegment(type: .q, data: [x1, y1, x, y]), rest: self)
    }

    func Q(_ x1: Double, _ y1: Double, _ x: Double, _ y: Double) -> PathBuilder {
        return PathBuilder(segment: PathSegment(type: .Q, data: [x1, y1, x, y]), rest: self)
    }

    func t(_ x: Double, _ y: Double) -> PathBuilder {
        return PathBuilder(segment: PathSegment(type: .t, data: [x, y]), rest: self)
    }

    func T(_ x: Double, _ y: Double) -> PathBuilder {
        return PathBuilder(segment: PathSegment(type: .T, data: [x, y]), rest: self)
    }

    func a(_ rx: Double, _ ry: Double, _ angle: Double, _ largeArc: Bool, _ sweep: Bool, _ x: Double, _ y: Double) -> PathBuilder {
        return PathBuilder(segment: PathSegment(type: .a, data: [rx, ry, angle, boolToNum(largeArc), boolToNum(sweep), x, y]), rest: self)
    }

    func A(_ rx: Double, _ ry: Double, _ angle: Double, _ largeArc: Bool, _ sweep: Bool, _ x: Double, _ y: Double) -> PathBuilder {
        return PathBuilder(segment: PathSegment(type: .A, data: [rx, ry, angle, boolToNum(largeArc), boolToNum(sweep), x, y]), rest: self)
    }

    func e(_ x: Double, _ y: Double, _ w: Double, _ h: Double, _ startAngle: Double, _ arcAngle: Double) -> PathBuilder {
        return PathBuilder(segment: PathSegment(type: .e, data: [x, y, w, h, startAngle, arcAngle]), rest: self)
    }

    func E(_ x: Double, _ y: Double, _ w: Double, _ h: Double, _ startAngle: Double, _ arcAngle: Double) -> PathBuilder {
        return PathBuilder(segment: PathSegment(type: .E, data: [x, y, w, h, startAngle, arcAngle]), rest: self)
    }

    func Z() -> PathBuilder {
        return PathBuilder(segment: PathSegment(type: .z), rest: self)
    }

    func build() -> Path {
        var segments: [PathSegment] = []
        var builder: PathBuilder? = self
        while builder != nil {
            segments.append(builder!.segment)
            builder = builder!.rest
        }
        return Path(segments: segments.reversed())
    }

    fileprivate func boolToNum(_ value: Bool) -> Double {
        return value ? 1 : 0
    }

}
