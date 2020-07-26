class GaussianBlur: Effect {

    let r: Double

    init(r: Double = 0, input: Effect? = nil) {
        self.r = r
        super.init(input: input)
    }
}
