//
// Copyright © 2020 mycujoo. All rights reserved.
//

import Foundation

// https://medium.com/makingtuenti/indeterminate-types-with-codable-in-swift-5a1af0aa9f3d

// Read for safely decoding while being less strict on types (option 3): https://paul-samuels.com/blog/2019/03/03/handling-bad-input-with-decodable/

// MARK: - Annotation


public struct AnnotationWrapper: Decodable {
    public let annotations: [Annotation]
}

public struct Annotation: Decodable {
    public let id: String
    public let timelineId: String
    public let offset: Int64
    public let actions: [Action]
}

public extension Annotation {
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
        let actions: [Action] = try container.decode([Action].self, forKey: .actions)

        self.init(id: id, timelineId: timelineId, offset: offset, actions: actions)
    }
}

// MARK: - Action

// TODO: Call this Action, remove the other Action struct.
public enum Action {
    case showTimelineMarker(ActionShowTimelineMarker)
    case showOverlay(ActionShowOverlay)
    case hideOverlay(ActionHideOverlay)
    case setVariable(ActionSetVariable)
    case incrementVariable(ActionIncrementVariable)
    case createTimer(ActionCreateTimer)
    case startTimer(ActionStartTimer)
    case pauseTimer(ActionPauseTimer)
    case adjustTimer(ActionAdjustTimer)
    case unsupported
}

extension Action: Decodable {
    public enum CodingKeys: String, CodingKey {
        case type
        case data
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let type = try container.decode(String.self, forKey: .type)
        switch type.lowercased() {
        case "show_timeline_marker":
            let data = try container.decode(ActionShowTimelineMarker.self, forKey: .data)
            self = .showTimelineMarker(data)
        case "show_overlay":
            let data = try container.decode(ActionShowOverlay.self, forKey: .data)
            self = .showOverlay(data)
        case "hide_overlay":
            let data = try container.decode(ActionHideOverlay.self, forKey: .data)
            self = .hideOverlay(data)
        case "set_variable":
            let data = try container.decode(ActionSetVariable.self, forKey: .data)
            self = .setVariable(data)
        case "increment_variable":
            let data = try container.decode(ActionIncrementVariable.self, forKey: .data)
            self = .incrementVariable(data)
        case "create_timer":
            let data = try container.decode(ActionCreateTimer.self, forKey: .data)
            self = .createTimer(data)
        case "start_timer":
            let data = try container.decode(ActionStartTimer.self, forKey: .data)
            self = .startTimer(data)
        case "pause_timer":
            let data = try container.decode(ActionPauseTimer.self, forKey: .data)
            self = .pauseTimer(data)
        case "adjust_timer":
            let data = try container.decode(ActionAdjustTimer.self, forKey: .data)
            self = .adjustTimer(data)
        default:
            self = .unsupported
        }
    }
}

// MARK: - ActionShowTimelineMarker

public struct ActionShowTimelineMarker: Decodable {
    public let color: String
    public let label: String
}

// MARK: - ActionShowOverlay


public struct ActionShowOverlay {
    public struct Position: Decodable {
        public let top: Float?
        public let bottom: Float?
        public let vcenter: Float?
        public let right: Float?
        public let left: Float?
        public let hcenter: Float?
    }

    public struct Size: Decodable {
        public let width: Float?
        public let height: Float?
    }

    public enum AnimationinType {
        case fadeIn, slideFromTop, slideFromBottom, slideFromLeft, slideFromRight, none, unsupported
    }

    public enum AnimationoutType {
        case fadeOut, slideToTop, slideToBottom, slideToLeft, slideToRight, none, unsupported
    }

    public let customId: String?
    public let svgURL: URL
    public let position: Position
    public let size: Size
    public let animationinType: AnimationinType?
    public let animationoutType: AnimationoutType?
    public let duration: Float?
    public let variablePositions: [String: String]?
}

public extension ActionShowOverlay.AnimationinType {
    init(rawValue: String?) {
        switch rawValue {
        case "fade_in":
            self = .fadeIn
        case "slide_from_top":
            self = .slideFromTop
        case "slide_from_bottom":
            self = .slideFromBottom
        case "slide_from_left":
            self = .slideFromLeft
        case "slide_from_right":
            self = .slideFromRight
        case "none":
            self = .none
        default:
            self = .unsupported
        }
    }
}

public extension ActionShowOverlay.AnimationoutType {
    init(rawValue: String?) {
        switch rawValue {
        case "fade_out":
            self = .fadeOut
        case "slide_to_top":
            self = .slideToTop
        case "slide_to_bottom":
            self = .slideToBottom
        case "slide_to_left":
            self = .slideToLeft
        case "slide_to_right":
            self = .slideToRight
        case "none":
            self = .none
        default:
            self = .unsupported
        }
    }
}

extension ActionShowOverlay: Decodable {
    public enum CodingKeys: String, CodingKey {
        case customId = "custom_id"
        case svgURL = "svg_url"
        case position
        case size
        case animationinType = "animationinType"
        case animationoutType = "animationoutType"
        case duration
        case variablePositions = "variable_positions"
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let customId: String? = try? container.decode(String.self, forKey: .customId)
        let svgURL: URL = try container.decode(URL.self, forKey: .svgURL)
        let position: Position = try container.decode(Position.self, forKey: .position)
        let size: Size = try container.decode(Size.self, forKey: .size)
        let animationinType: AnimationinType = AnimationinType(rawValue: try? container.decode(String.self, forKey: .animationinType))
        let animationoutType: AnimationoutType = AnimationoutType(rawValue: try? container.decode(String.self, forKey: .animationoutType))
        let duration: Float? = try? container.decode(Float.self, forKey: .duration)
        let variablePositions: [String: String]? = try? container.decode([String: String].self, forKey: .variablePositions)

        self.init(customId: customId, svgURL: svgURL, position: position, size: size, animationinType: animationinType, animationoutType: animationoutType, duration: duration, variablePositions: variablePositions)
    }
}
// MARK: - ActionHideOverlay

public struct ActionHideOverlay {
    public let customId: String
}

extension ActionHideOverlay: Decodable {
    public enum CodingKeys: String, CodingKey {
        case customId = "custom_id"
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let customId: String = try container.decode(String.self, forKey: .customId)

        self.init(customId: customId)
    }
}

// MARK: - ActionSetVariable

public struct ActionSetVariable {
    public let name: String
    public let stringValue: String?
    public let numberValue: Double?
    public let boolValue: Bool?
}

extension ActionSetVariable: Decodable {
    public enum CodingKeys: String, CodingKey {
        case name
        case stringValue = "string_value"
        case numberValue = "number_value"
        case boolValue = "bool_value"
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let name: String = try container.decode(String.self, forKey: .name)
        let stringValue: String? = try? container.decode(String.self, forKey: .stringValue)
        let numberValue: Double? = try? container.decode(Double.self, forKey: .numberValue)
        let boolValue: Bool? = try? container.decode(Bool.self, forKey: .boolValue)

        self.init(name: name, stringValue: stringValue, numberValue: numberValue, boolValue: boolValue)
    }
}

// MARK: - ActionIncrementVariable

public struct ActionIncrementVariable: Decodable {
    public let name: String
    public let amount: Double
}

// MARK: - ActionCreateTimer

public struct ActionCreateTimer {
    public enum ClockType {
        case standard
        case unsupported
    }
    public enum Direction {
        case up
        case down
        case unsupported
    }

    public let name: String
    public let clockType: ClockType
    public let direction: Direction
    public let startValue: Int64
    public let capValue: Int64?
}

public extension ActionCreateTimer.ClockType {
    init(rawValue: String?) {
        switch rawValue {
        case "standard":
            self = .standard
        default:
            self = .unsupported
        }
    }
}

public extension ActionCreateTimer.Direction {
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

extension ActionCreateTimer: Decodable {
    public enum CodingKeys: String, CodingKey {
        case name
        case clockType = "clock_type"
        case direction
        case startValue = "start_value"
        case capValue = "cap_value"
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let name: String = try container.decode(String.self, forKey: .name)
        let clockType: ActionCreateTimer.ClockType = ActionCreateTimer.ClockType(rawValue: try? container.decode(String.self, forKey: .clockType))
        let direction: ActionCreateTimer.Direction = ActionCreateTimer.Direction(rawValue: try? container.decode(String.self, forKey: .name))
        let startValue: Int64 = (try? container.decode(Int64.self, forKey: .startValue)) ?? 0
        let capValue: Int64? = try? container.decode(Int64.self, forKey: .capValue)

        self.init(name: name, clockType: clockType, direction: direction, startValue: startValue, capValue: capValue)
    }
}

// MARK: - ActionStartTimer

public struct ActionStartTimer: Decodable {
    public let name: String
}

// MARK: - ActionStartTimer

public struct ActionPauseTimer: Decodable {
    public let name: String
}

// MARK: - ActionStartTimer

public struct ActionAdjustTimer: Decodable {
    public let name: String
    public let value: Int64
}
