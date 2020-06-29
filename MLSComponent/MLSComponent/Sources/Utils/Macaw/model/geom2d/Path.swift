enum FillRule {
    case nonzero, evenodd
}

class Path: Locus {

    let segments: [PathSegment]
    let fillRule: FillRule

    init(segments: [PathSegment] = [], fillRule: FillRule = .nonzero) {
        self.segments = segments
        self.fillRule = fillRule
    }

    override func bounds() -> Rect {
        return toCGPath().boundingBoxOfPath.toMacaw()
    }

    override func toPath() -> Path {
        return self
    }
}
