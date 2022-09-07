//
// Copyright © 2022 mycujoo. All rights reserved.
//

import Foundation


public enum DelayOptions {
    case immediate
    case constant(time: Int)
    case exponential(initial: Int, multiplier: Double, maxDelay: Int = 5000)
    case custom(closure: (Int) -> Int)
}

public extension DelayOptions {
    func make(_ attempt: Int) -> Int {
        switch self {
        case .immediate: return 0
        case .constant(let time): return time
        case .exponential(let initial, let multiplier, let maxDelay):
            // if it's first attempt, simply use initial delay, otherwise calculate delay
            let delay = attempt == 1 ? initial : initial * Int(pow(multiplier, Double(attempt - 1)))
            return min(maxDelay, delay)
        case .custom(let closure): return closure(attempt)
        }
    }
}
