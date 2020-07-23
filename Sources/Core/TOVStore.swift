//
// Copyright © 2020 mycujoo. All rights reserved.
//

import Foundation

// MARK: TOVStore

/// TOV (Timer Or Variable). This store contains a state of variables and timers (TOVs) defined within.
/// A single instance of a TOVStore should be tied to a single timeline.
class TOVStore {
    private var timers: [String: ActionTimer] = [:]
    private var variables: [String: ActionVariable] = [:]

    private var observers: [String: [(callbackId: String, callback: (String) -> Void)]] = [:]

    func get(by name: String) -> TOVObject? {
        return variables[name] ?? timers[name]
    }

    /// Observe Timer or Variable changes.  The observer (target) will be notified of every change to this variable in this store.
    /// `get(by:)` can then be used to obtain the new value.
    /// - parameter tovName: The name of the variable or timer to be observed.
    /// - parameter callbackId: A string that uniquely identifies this callback in the context of this tovName. Can be used to remove observers.
    /// - parameter callback: A closure that is called whenever a change occurs.
    func addObserver(tovName: String, callbackId: String, callback: @escaping (String) -> Void) {
        if let arr_ = observers[tovName] {
            var arr = arr_
            if arr.contains(where: { tuple -> Bool in
                tuple.callbackId == callbackId
            }) {
                arr = arr.filter { $0.callbackId != callbackId }
            }
            observers[tovName] = arr + [(callbackId: callbackId, callback: callback)]
        } else {
            observers[tovName] = [(callbackId: callbackId, callback: callback)]
        }
    }

    /// - parameter tovName: The name of the variable or timer to be observed.
    /// - parameter callbackId: The identifier of the callback that should be removed.
    func removeObserver(tovName: String, callbackId: String) {
        guard let arr = observers[tovName] else { return }

        observers[tovName] = arr.filter { $0.callbackId != callbackId }
    }

    /// Unlike `removeObserver(tovName:callbackId:)`, this method removes all observers with this callbackId from all tovNames.
    func removeObservers(callbackId: String) {
        for (tovName, _) in observers {
            removeObserver(tovName: tovName, callbackId: callbackId)
        }
    }

    /// Should be called whenever a new dictionary of ActionVariables (and their names as keys) is available.
    /// The store will internally call any observer whenever a difference with a previous state is detected.
    func new(variables newVariables: [String: ActionVariable]) {
        var oldVariables = self.variables

        var differentVariableNames: [String] = []

        for (name, newVariable) in newVariables {
            if let oldVariable = oldVariables[name] {
                if oldVariable != newVariable {
                    differentVariableNames.append(name)
                }
                oldVariables[name] = nil
            } else {
                differentVariableNames.append(name)
            }
        }

        differentVariableNames += oldVariables.map { $0.key }

        self.variables = newVariables

        callObservers(names: differentVariableNames)
    }

    /// Should be called whenever a new dictionary of ActionTimer (and their names as keys) is available.
    /// The store will internally call any observer whenever a difference with a previous state is detected.
    func new(timers newTimers: [String: ActionTimer]) {
        var oldTimers = self.timers

        var differentTimerNames: [String] = []

        for (name, newTimer) in newTimers {
            if let oldTimer = oldTimers[name] {
                if oldTimer != newTimer {
                    differentTimerNames.append(name)
                }
                oldTimers[name] = nil
            } else {
                differentTimerNames.append(name)
            }
        }

        differentTimerNames += oldTimers.map { $0.key }

        self.timers = newTimers

        callObservers(names: differentTimerNames)
    }

    /// Notifies observers of changes to the variables or timers that they are referenced in the `names` parameter.
    private func callObservers(names: [String]) {
        for name in names {
            guard let observers = self.observers[name] else { continue }
            for observer in observers {
                observer.callback(name)
            }
        }
    }
}

// MARK: TOVObject protocol

protocol TOVObject {
    var name: String { get }
    var humanFriendlyValue: String { get }
}

// MARK: ActionVariable

class ActionVariable: TOVObject, Equatable {
    static func == (lhs: ActionVariable, rhs: ActionVariable) -> Bool {
        return
            lhs.name == rhs.name &&
            lhs.stringValue == rhs.stringValue &&
            lhs.doubleValue == rhs.doubleValue &&
            lhs.longValue == rhs.longValue &&
            lhs.doublePrecision == rhs.doublePrecision
    }

    let name: String
    var stringValue: String?
    var doubleValue: Double?
    var longValue: Int64?
    var doublePrecision: Int?

    init(name: String, stringValue: String?, doubleValue: Double?, longValue: Int64?, doublePrecision: Int?) {
        self.name = name
        self.stringValue = stringValue
        self.doubleValue = doubleValue
        self.longValue = longValue
        self.doublePrecision = doublePrecision
    }

    var humanFriendlyValue: String {
        if let stringValue = stringValue {
            return stringValue
        }
        else if let longValue = longValue {
            return String(describing: longValue)
        }
        else if let doubleValue = doubleValue {
            return String(format: "%.\(min(15, doublePrecision ?? 2))f", doubleValue)
        }
        return ""
    }
}

// MARK: ActionTimer

class ActionTimer: TOVObject, Equatable {
    static func == (lhs: ActionTimer, rhs: ActionTimer) -> Bool {
        return
            lhs.name == rhs.name &&
            lhs.format == rhs.format &&
            lhs.direction == rhs.direction &&
            lhs.startValue == rhs.startValue &&
            lhs.capValue == rhs.capValue &&
            lhs.isRunning == rhs.isRunning &&
            // Do not include lastUpdatedAtOffset, since that unnecessary makes this seem like a different timer.
            lhs.value == rhs.value
    }

    enum Format: String {
        case ms = "ms"
        case s = "s"
        case unsupported = "unsupported"
    }
    enum Direction: String {
        case up = "up"
        case down = "down"
        case unsupported = "unsupported"
    }

    let name: String
    let format: Format
    let direction: Direction
    let startValue: Double
    let capValue: Double?

    private var value: Double
    private(set) var isRunning = false
    private var lastUpdatedAtOffset: Double? = nil

    init(name: String, format: Format, direction: Direction, startValue: Double, capValue: Double? = nil) {
        self.name = name
        self.format = format
        self.direction = direction
        self.startValue = (startValue / 1000)
        self.capValue = capValue != nil ? (capValue! / 1000) : nil

        self.value = (startValue / 1000)
    }

    var humanFriendlyValue: String {
        switch format {
        case .ms:
            let seconds = value.truncatingRemainder(dividingBy: 60)
            let minutes = (value - seconds) / 60
            return String(format: "%02.0f:%02.0f", minutes, seconds)
        case .s, .unsupported:
            return String(format: "%.0f", value)
        }
    }

    /// Should be called whenever the state of the timer changes. This internally updates the `value` property.
    func update(isRunning: Bool, at offset: Double) {
        materialize(at: offset)
        self.isRunning = isRunning
    }

    /// Forces the timer to take on a new absolute value, regardless of anything that happened previously.
    func forceAdjustTo(value: Double, at offset: Double) {
        updateValueWithRulesApplied(v: value, absolute: true)
        self.lastUpdatedAtOffset = offset
    }

    /// Forces the timer to be adjusted by a relative value.
    func forceAdjustBy(value: Double, at offset: Double) {
        materialize(at: offset)
        updateValueWithRulesApplied(v: value, absolute: false)
    }

    /// Should be called to materialize the value of this timer at a specific offset. This internally updates the `value` property.
    func materialize(at offset: Double) {
        if isRunning {
            switch direction {
            case .down:
                self.value = self.value - (offset - (lastUpdatedAtOffset ?? 0))
                if let capValue = capValue {
                    value = max(capValue, value)
                }
            case .up, .unsupported:
            self.value = self.value + (offset - (lastUpdatedAtOffset ?? 0))
                if let capValue = capValue {
                    value = min(capValue, value)
                }
            }
        }
        self.lastUpdatedAtOffset = offset
    }

    /// Manipulates the `value` variable based while respecting the direction and capValue.
    /// - parameter v: The value that `value` should have if `absolute` is true, or the value that `value` should be updated by if `absolute` is false.
    /// - parameter absolute: Whether the value is being replaced (true) or added (false).
    private func updateValueWithRulesApplied(v: Double, absolute: Bool) {
        switch direction {
        case .down:
            if absolute {
                self.value = v
            } else {
                self.value -= v
            }
            if let capValue = capValue {
                self.value = max(capValue, self.value)
            }
        case .up, .unsupported:
            if absolute {
                self.value = v
            } else {
                self.value += v
            }
            if let capValue = capValue {
                self.value = min(capValue, self.value)
            }
        }
    }
}


