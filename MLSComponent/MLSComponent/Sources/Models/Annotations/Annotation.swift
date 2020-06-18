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
    case showOverlay
    case hideOverlay
    case setVariable
    case incrementVariable
    case createTimer
    case startTimer
    case pauseTimer
    case adjustTimer
    case unsupported
}

extension AnnotationAction: Decodable {
    private enum CodingKeys: String, CodingKey {
        case type
        case payload
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let type = try container.decode(String.self, forKey: .type)
        switch type.lowercased() {
        case "show_timeline_marker":
            let data = try container.decode(AnnotationActionShowTimelineMarker.self, forKey: .payload)
            self = .showTimelineMarker(data)
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
