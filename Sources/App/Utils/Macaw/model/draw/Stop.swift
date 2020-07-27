class Stop: Equatable {

    let offset: Double
    let color: Color

    init(offset: Double = 0, color: Color) {
        self.color = color
        self.offset = max(0, min(1, offset))
    }
}

func == (lhs: Stop, rhs: Stop) -> Bool {
    return lhs.offset == rhs.offset && lhs.color == rhs.color
}
