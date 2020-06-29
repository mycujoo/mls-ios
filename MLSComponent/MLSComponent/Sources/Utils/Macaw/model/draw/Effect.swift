class Effect {

    let input: Effect?

    init(input: Effect?) {
        self.input = input
    }

    static func dropShadow(dx: Double = 0, dy: Double = -3, r: Double = 3, color: Color = .black) -> Effect? {
        return OffsetEffect(dx: dx, dy: dy).setColor(to: color).blur(r: r).blend()
    }

    func offset(dx: Double, dy: Double) -> Effect {
        return OffsetEffect(dx: dx, dy: dy, input: self)
    }

    func mapColor(with matrix: ColorMatrix) -> Effect {
        return ColorMatrixEffect(matrix: matrix, input: self)
    }

    func setColor(to color: Color) -> Effect {
        return ColorMatrixEffect(matrix: ColorMatrix(color: color), input: self)
    }

    func blur(r: Double) -> Effect {
        return GaussianBlur(r: r, input: self)
    }

    func blend() -> Effect {
        return BlendEffect(input: self)
    }
}
