import Foundation

internal class CombineAnimation: BasicAnimation {

    let animations: [BasicAnimation]
    let toNodes: [Node]
    let duration: Double

    required init(animations: [BasicAnimation], during: Double = 1.0, delay: Double = 0.0, node: Node? = .none, toNodes: [Node] = []) {
        self.animations = animations
        self.duration = during
        self.toNodes = toNodes

        super.init()

        self.type = .combine
        self.node = node ?? animations.first?.node
        self.delay = delay
    }

    override func getDuration() -> Double {
        if let maxElement = animations.map({ $0.getDuration() }).max() {
            return maxElement
        }

        return 0.0
    }

    override func reverse() -> Animation {
        var reversedAnimations = [BasicAnimation]()
        animations.forEach { animation in
            reversedAnimations.append(animation.reverse() as! BasicAnimation)
        }

        let combineReversed = reversedAnimations.combine(delay: self.delay) as! BasicAnimation
        combineReversed.completion = completion
        combineReversed.progress = progress

        return combineReversed
    }

    override func play() {
        animations.forEach { animation in
            animation.paused = false
            animation.manualStop = false
        }

        super.play()
    }

    override func stop() {
        super.stop()

        animations.forEach { animation in
            animation.stop()
        }
    }

    override func pause() {
        super.pause()

        animations.forEach { animation in
            animation.pause()
        }
    }

    override func state() -> AnimationState {
        var result = AnimationState.initial
        for animation in animations {
            let state = animation.state()
            if state == .running {
                return .running
            }

            if state != .initial {
                result = state
            }
        }

        return result
    }
}

extension Sequence where Iterator.Element: Animation {
    func combine(delay: Double = 0.0, node: Node? = .none, toNodes: [Node] = []) -> Animation {

        var toCombine = [BasicAnimation]()
        self.forEach { animation in
            toCombine.append(animation as! BasicAnimation)
        }
        return CombineAnimation(animations: toCombine, delay: delay, node: node ?? toCombine.first?.node, toNodes: toNodes)
    }
}
