protocol DoubleInterpolation: Interpolable {

}

extension Double: DoubleInterpolation {
    func interpolate(_ endValue: Double, progress: Double) -> Double {
        return self + (endValue - self) * progress
    }
}
