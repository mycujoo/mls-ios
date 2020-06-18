//
// Copyright © 2020 mycujoo. All rights reserved.
//

import Foundation

// https://medium.com/makingtuenti/indeterminate-types-with-codable-in-swift-5a1af0aa9f3d

// Read for safely decoding while being less strict on types (option 3): https://paul-samuels.com/blog/2019/03/03/handling-bad-input-with-decodable/

// MARK: - Annotation

struct Annotation: Decodable {
    var id: String
    var timelineId: String
    var offset: Int64
    var actions: [AnnotationAction]
}

extension Annotation {
    enum CodingKeys: String, CodingKey {
        case id
        case timelineId = "timeline_id"
        case offset
        case actions
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let id: String = try container.decode(String.self, forKey: .id)
        let timelineId: String = try container.decode(String.self, forKey: .timelineId)
        let offset: Int64 = try container.decode(Int64.self, forKey: .offset)
        let actions: [AnnotationAction] = try container.decode([AnnotationAction].self, forKey: .actions)

        self.init(id: id, timelineId: timelineId, offset: offset, actions: actions)
    }
}

// MARK: - AnnotationAction

// TODO: Call this Action, remove the other Action struct.
enum AnnotationAction {
    case showTimelineMarker(AnnotationActionShowTimelineMarker)
    case showOverlay(AnnotationActionShowOverlay)
    case hideOverlay(AnnotationActionHideOverlay)
    case setVariable(AnnotationActionSetVariable)
    case incrementVariable(AnnotationActionIncrementVariable)
    case createTimer(AnnotationActionCreateTimer)
    case startTimer(AnnotationActionStartTimer)
    case pauseTimer(AnnotationActionPauseTimer)
    case adjustTimer(AnnotationActionAdjustTimer)
    case unsupported
}

extension AnnotationAction: Decodable {
    private enum CodingKeys: String, CodingKey {
        case type
        case data
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let type = try container.decode(String.self, forKey: .type)
        switch type.lowercased() {
        case "show_timeline_marker":
            let data = try container.decode(AnnotationActionShowTimelineMarker.self, forKey: .data)
            self = .showTimelineMarker(data)
        case "show_overlay":
            let data = try container.decode(AnnotationActionShowOverlay.self, forKey: .data)
            self = .showOverlay(data)
        case "hide_overlay":
            let data = try container.decode(AnnotationActionHideOverlay.self, forKey: .data)
            self = .hideOverlay(data)
        case "set_variable":
            let data = try container.decode(AnnotationActionSetVariable.self, forKey: .data)
            self = .setVariable(data)
        case "increment_variable":
            let data = try container.decode(AnnotationActionIncrementVariable.self, forKey: .data)
            self = .incrementVariable(data)
        case "create_timer":
            let data = try container.decode(AnnotationActionCreateTimer.self, forKey: .data)
            self = .createTimer(data)
        case "start_timer":
            let data = try container.decode(AnnotationActionStartTimer.self, forKey: .data)
            self = .startTimer(data)
        case "pause_timer":
            let data = try container.decode(AnnotationActionPauseTimer.self, forKey: .data)
            self = .pauseTimer(data)
        case "adjust_timer":
            let data = try container.decode(AnnotationActionAdjustTimer.self, forKey: .data)
            self = .adjustTimer(data)
        default:
            self = .unsupported
        }
    }
}

// MARK: - AnnotationActionShowTimelineMarker

struct AnnotationActionShowTimelineMarker: Decodable {
    var color: String
    var label: String
}

// MARK: - AnnotationActionShowOverlay


struct AnnotationActionShowOverlay: Decodable {

}

// MARK: - AnnotationActionHideOverlay

struct AnnotationActionHideOverlay {
    var customId: String
}

extension AnnotationActionHideOverlay: Decodable {
    private enum CodingKeys: String, CodingKey {
        case customId = "custom_id"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let customId: String = try container.decode(String.self, forKey: .customId)

        self.init(customId: customId)
    }
}

// MARK: - AnnotationActionSetVariable

struct AnnotationActionSetVariable {
    var name: String
    var stringValue: String
    var numberValue: Double
    var boolValue: Bool
}

extension AnnotationActionSetVariable: Decodable {
    private enum CodingKeys: String, CodingKey {
        case name
        case stringValue = "string_value"
        case numberValue = "number_value"
        case boolValue = "bool_value"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let name: String = try container.decode(String.self, forKey: .name)
        let stringValue: String = try container.decode(String.self, forKey: .stringValue)
        let numberValue: Double = try container.decode(Double.self, forKey: .numberValue)
        let boolValue: Bool = try container.decode(Bool.self, forKey: .boolValue)

        self.init(name: name, stringValue: stringValue, numberValue: numberValue, boolValue: boolValue)
    }
}

// MARK: - AnnotationActionIncrementVariable

struct AnnotationActionIncrementVariable: Decodable {
    var name: String
    var amount: Double
}

// MARK: - AnnotationActionCreateTimer

struct AnnotationActionCreateTimer {
    enum ClockType {
        case standard
        case unsupported
    }
    enum Direction {
        case up
        case down
        case unsupported
    }

    var name: String
    var clockType: ClockType
    var direction: Direction
    var startValue: Int64
    var capValue: Int64
}

extension AnnotationActionCreateTimer.ClockType {
    init(rawValue: String?) {
        switch rawValue {
        case "standard":
            self = .standard
        default:
            self = .unsupported
        }
    }
}

extension AnnotationActionCreateTimer.Direction {
    init(rawValue: String?) {
        switch rawValue {
        case "up":
            self = .up
        case "down":
            self = .down
        default:
            self = .unsupported
        }
    }
}

extension AnnotationActionCreateTimer: Decodable {
    private enum CodingKeys: String, CodingKey {
        case name
        case clockType = "clock_type"
        case direction
        case startValue = "start_value"
        case capValue = "cap_value"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let name: String = try container.decode(String.self, forKey: .name)
        let clockType: AnnotationActionCreateTimer.ClockType = AnnotationActionCreateTimer.ClockType(rawValue: try? container.decode(String.self, forKey: .clockType))
        let direction: AnnotationActionCreateTimer.Direction = AnnotationActionCreateTimer.Direction(rawValue: try? container.decode(String.self, forKey: .name))
        let startValue: Int64 = try container.decode(Int64.self, forKey: .startValue)
        let capValue: Int64 = try container.decode(Int64.self, forKey: .capValue)

        self.init(name: name, clockType: clockType, direction: direction, startValue: startValue, capValue: capValue)
    }
}

// MARK: - AnnotationActionStartTimer

struct AnnotationActionStartTimer: Decodable {
    var name: String
}

// MARK: - AnnotationActionStartTimer

struct AnnotationActionPauseTimer: Decodable {
    var name: String
}

// MARK: - AnnotationActionStartTimer

struct AnnotationActionAdjustTimer: Decodable {
    var name: String
    var amount: Int64
}
