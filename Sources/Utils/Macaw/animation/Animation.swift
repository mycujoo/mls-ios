enum AnimationState {
    case initial
    case running
    case paused
}

class Animation {

    internal init() {
    }

    func play() {
    }

    func stop() {
    }

    func pause() {

    }

    func state() -> AnimationState {
        return .initial
    }

    func easing(_ easing: Easing) -> Animation {
        return self
    }

    func delay(_ delay: Double) -> Animation {
        return self
    }

    func cycle(_ count: Double) -> Animation {
        return self
    }

    func cycle() -> Animation {
        return self
    }

    func reverse() -> Animation {
        return self
    }

    func autoreversed() -> Animation {
        return self
    }

    @discardableResult func onComplete(_: @escaping (() -> Void)) -> Animation {
        return self
    }
}
