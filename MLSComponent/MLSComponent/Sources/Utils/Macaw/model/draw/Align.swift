class Align {

    static let min: Align = Align()
    static let mid: Align = MidAlign()
    static let max: Align = MaxAlign()

    func align(outer: Double, inner: Double) -> Double {
        return 0
    }

    func align(size: Double) -> Double {
        return align(outer: size, inner: 0)
    }

}

private class MidAlign: Align {

    override func align(outer: Double, inner: Double) -> Double {
        return (outer - inner) / 2
    }
}

private class MaxAlign: Align {

    override func align(outer: Double, inner: Double) -> Double {
        return outer - inner
    }
}
