protocol LocusInterpolation: Interpolable {

}

extension Locus: LocusInterpolation {
    func interpolate(_ endValue: Locus, progress: Double) -> Self {
        return self
    }
}
