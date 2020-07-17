//
// Copyright © 2020 mycujoo. All rights reserved.
//

import Foundation

// MARK: TOVStore

/// TOV (Timer Or Variable). This store contains a state of variables and timers (TOVs) defined within.
class TOVStore {
    private var timers: [String: ActionTimer] = [:]
    private var variables: [String: ActionVariable] = [:]

    private var observers: [String: [(callbackId: String, callback: (String) -> Void)]] = [:]

    /// Observe a Timer or Variable.  The observer (target) will be notified of every change to this variable in this store.
    /// - parameter tovName: The name of the variable or timer to be observed.
    /// - parameter callbackId: A string that uniquely identifies this callback. Can be used to remove observers.
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

    /// Should be called whenever a new dictionary of ActionVariables (and their names as keys) is available.
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
            lhs.capValue == rhs.capValue
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
    let startValue: Int64
    let capValue: Int64?

    var value: Int64

    init(name: String, format: Format, direction: Direction, startValue: Int64, capValue: Int64? = nil) {
        self.name = name
        self.format = format
        self.direction = direction
        self.startValue = startValue
        self.capValue = capValue

        self.value = startValue
    }

    var humanFriendlyValue: String {
        return "\(startValue)" // TODO: Adhere to formatting.
    }
}


