//
//  Easing.swift
//  Pods
//
//  Created by Yuri Strot on 9/2/16.
//
//

#if os(iOS) || os(tvOS)
import UIKit
#elseif os(OSX)
import AppKit
#endif

class Easing {

    static let ease: Easing = Easing()
    static let linear: Easing = Easing()
    static let easeIn: Easing = EaseIn()
    static let easeOut: Easing = EaseOut()
    static let easeInOut: Easing = EaseInOut()
    static let elasticOut: Easing = ElasticOut()
    static let elasticInOut: Easing = ElasticInOut()

    static func elasticOut(elasticity: Double = 10.0) -> ElasticOut {
        return ElasticOut(elasticity: elasticity)
    }
    static func elasticInOut(elasticity: Double = 10.0) -> ElasticInOut {
        return ElasticInOut(elasticity: elasticity)
    }

    func progressFor(time: Double) -> Double {
        return time
    }
}

private class EaseIn: Easing {
    override func progressFor(time t: Double) -> Double {
        return t * t
    }
}

private class EaseOut: Easing {
    override func progressFor(time t: Double) -> Double {
        return -(t * (t - 2))
    }
}

private class EaseInOut: Easing {
    override func progressFor(time t: Double) -> Double {
        if t < 0.5 {
            return 2.0 * t * t
        } else {
            return -2.0 * t * t + 4.0 * t - 1.0
        }
    }
}

class ElasticOut: Easing {
    let elasticity: Double

    init(elasticity: Double = 10.0) { // less elasticity means more springy effect
        self.elasticity = elasticity
    }

    override func progressFor(time: Double) -> Double {
        if time == 0 {
            return 0
        }
        let t = time / 0.5
        if t == 2 {
            return 1
        }
        let p = 0.3
        let s = p / 4

        let postFix = pow(2, -elasticity * t)
        return (postFix * sin((t - s) * (2 * .pi) / p ) + 1)
    }
}

class ElasticInOut: Easing {
    let elasticity: Double

    init(elasticity: Double = 10.0) { // less elasticity means more springy effect
        self.elasticity = elasticity
    }

    override func progressFor(time: Double) -> Double {
        if time == 0 {
            return 0
        }
        let t = time / 0.5 - 1
        if t == 1 {
            return 1
        }
        let p = 0.3 * 1.5
        let s = p / 4

        if t < 0 {
            let postFix = pow(2, elasticity * t)
            return (-0.5 * (postFix * sin((t - s) * (2 * .pi) / p)))
        }
        let postFix = pow(2, -elasticity * t)
        return (postFix * sin((t - s) * (2 * .pi) / p ) * 0.5 + 1)
    }
}
