//
// Copyright © 2020 mycujoo. All rights reserved.
//

import Foundation

// MARK: TOVStore

/// TOV (Timer Or Variable). This store contains a state of variables and timers (TOVs) defined within.
class TOVStore {
    private var timers: [String: ActionTimer] = [:]
    private var variables: [String: ActionVariable] = [:]

    func get(by name: String) -> TOVObject? {
        return variables[name] ?? timers[name]
    }

    func createTimer(name: String, format: ActionTimer.Format, direction: ActionTimer.Direction = .up, startValue: Int64 = 0, capValue: Int64? = nil) {
        timers[name] = ActionTimer(name: name, format: format, direction: direction, startValue: startValue, capValue: capValue)
    }

    func adjustTimer(name: String, newValue value: Int64) {
        timers[name]?.value = value
    }

    func setVariable(name: String, stringValue: String?, doubleValue: Double?, longValue: Int64?, doublePrecision: Int?) {
        variables[name] = ActionVariable(name: name, stringValue: stringValue, doubleValue: doubleValue, longValue: longValue, doublePrecision: doublePrecision)
    }

    func incrementVariable(name: String, amount: Double) {
        guard let variable = variables[name] else { return }

        if variable.longValue != nil {
            variable.longValue! += Int64(amount)
        } else if variable.doubleValue != nil {
            variable.doubleValue! += amount
        }
    }
}

// MARK: TOVObject protocol

protocol TOVObject {
    var name: String { get }
    var humanFriendlyValue: String { get }
}

// MARK: ActionVariable

class ActionVariable: TOVObject {
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

class ActionTimer: TOVObject {
    enum Format {
        case ms
        case s
        case unsupported
    }
    enum Direction {
        case up
        case down
        case unsupported
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


