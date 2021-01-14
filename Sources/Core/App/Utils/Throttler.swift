//
// Copyright © 2020 mycujoo. All rights reserved.
//

import Foundation

public class Throttler {
    private var workItem: DispatchWorkItem = DispatchWorkItem(block: {})
    private var previousRun: Date = Date.distantPast
    private let queue: DispatchQueue
    public var minimumDelay: TimeInterval

    public init(minimumDelay: TimeInterval, queue: DispatchQueue = DispatchQueue.main) {
        self.minimumDelay = minimumDelay
        self.queue = queue
    }

    public func throttle(_ block: @escaping () -> Void) {
        // Cancel any existing work item if it has not yet executed
        workItem.cancel()

        // Re-assign workItem with the new block task, resetting the previousRun time when it executes
        workItem = DispatchWorkItem() { [weak self] in
            self?.previousRun = Date()
            block()
        }

        // If the time since the previous run is more than the required minimum delay
        // => execute the workItem immediately
        // else
        // => delay the workItem execution by the minimum delay time
        let delay = previousRun.timeIntervalSinceNow > minimumDelay ? 0 : minimumDelay
        queue.asyncAfter(deadline: .now() + Double(delay), execute: workItem)
    }
}

public class Debouncer {
    private var workItem: DispatchWorkItem = DispatchWorkItem(block: {})
    private let queue: DispatchQueue
    public var minimumDelay: TimeInterval

    public init(minimumDelay: TimeInterval = 0, queue: DispatchQueue = DispatchQueue.main) {
        self.minimumDelay = minimumDelay
        self.queue = queue
    }

    public func debounce(_ block: @escaping () -> Void) {
        // Cancel any existing work item if it has not yet executed
        workItem.cancel()

        // Re-assign workItem with the new block task, resetting the previousRun time when it executes
        workItem = DispatchWorkItem() { 
            block()
        }

        queue.asyncAfter(deadline: .now() + Double(minimumDelay), execute: workItem)
    }
}
