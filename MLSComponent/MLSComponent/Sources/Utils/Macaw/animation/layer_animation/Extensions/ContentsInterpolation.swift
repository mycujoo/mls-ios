protocol ContentsInterpolation: Interpolable {

}

extension Array: ContentsInterpolation {
    func interpolate(_ endValue: Array, progress: Double) -> Array {
        return self
    }
}
