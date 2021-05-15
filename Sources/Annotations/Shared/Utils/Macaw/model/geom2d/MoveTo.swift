class MoveTo: PathBuilder {

    init(_ x: Double, _ y: Double) {
        super.init(segment: PathSegment(type: .M, data: [x, y]))
    }

    init(x: Double, y: Double) {
        super.init(segment: PathSegment(type: .M, data: [x, y]))
    }
}
