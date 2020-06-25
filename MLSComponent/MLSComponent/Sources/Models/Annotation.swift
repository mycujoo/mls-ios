//
// Copytrailing © 2020 mycujoo. All trailings reserved.
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

public struct Action {
    let id: String
    private let type: String
    let data: ActionData
}

extension Action: Decodable {
    public enum CodingKeys: String, CodingKey {
        case id
        case type
        case data
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let id = try container.decode(String.self, forKey: .id)
        let type = try container.decode(String.self, forKey: .type)
        let data: ActionData
        switch type.lowercased() {
        case "show_timeline_marker":
            let rawData = try container.decode(ActionShowTimelineMarker.self, forKey: .data)
            data = .showTimelineMarker(rawData)
        case "show_overlay":
            let rawData = try container.decode(ActionShowOverlay.self, forKey: .data)
            data = .showOverlay(rawData)
        case "hide_overlay":
            let rawData = try container.decode(ActionHideOverlay.self, forKey: .data)
            data = .hideOverlay(rawData)
        case "set_variable":
            let rawData = try container.decode(ActionSetVariable.self, forKey: .data)
            data = .setVariable(rawData)
        case "increment_variable":
            let rawData = try container.decode(ActionIncrementVariable.self, forKey: .data)
            data = .incrementVariable(rawData)
        case "create_timer":
            let rawData = try container.decode(ActionCreateTimer.self, forKey: .data)
            data = .createTimer(rawData)
        case "start_timer":
            let rawData = try container.decode(ActionStartTimer.self, forKey: .data)
            data = .startTimer(rawData)
        case "pause_timer":
            let rawData = try container.decode(ActionPauseTimer.self, forKey: .data)
            data = .pauseTimer(rawData)
        case "adjust_timer":
            let rawData = try container.decode(ActionAdjustTimer.self, forKey: .data)
            data = .adjustTimer(rawData)
        case "create_clock":
            let rawData = try container.decode(ActionCreateClock.self, forKey: .data)
            data = .createClock(rawData)
        default:
            data = .unsupported
        }

        self.init(id: id, type: type, data: data)
    }
}

public enum ActionData {
    case showTimelineMarker(ActionShowTimelineMarker)
    case showOverlay(ActionShowOverlay)
    case hideOverlay(ActionHideOverlay)
    case setVariable(ActionSetVariable)
    case incrementVariable(ActionIncrementVariable)
    case createTimer(ActionCreateTimer)
    case startTimer(ActionStartTimer)
    case pauseTimer(ActionPauseTimer)
    case adjustTimer(ActionAdjustTimer)
    case createClock(ActionCreateClock)
    case unsupported
}


// MARK: - ActionShowTimelineMarker

public struct ActionShowTimelineMarker: Decodable {
    public let color: String
    public let label: String
}

// MARK: - ActionShowOverlay

public enum OverlayAnimateinType {
    case fadeIn, slideFromTop, slideFromBottom, slideFromleading, slideFromtrailing, none, unsupported
}

public enum OverlayAnimateoutType {
    case fadeOut, slideToTop, slideToBottom, slideToLeading, slideToTrailing, none, unsupported
}

public struct ActionShowOverlay {
    public struct Position: Decodable {
        public let top: Double?
        public let bottom: Double?
        public let vcenter: Double?
        public let trailing: Double?
        public let leading: Double?
        public let hcenter: Double?
    }

    public struct Size: Decodable {
        public let width: Double?
        public let height: Double?
    }

    public let customId: String?
    public let svgURL: URL
    public let position: Position
    public let size: Size
    public let animateinType: OverlayAnimateinType?
    public let animateoutType: OverlayAnimateoutType?
    public let animateinDuration: Double?
    public let animateoutDuration: Double?
    public let duration: Double?
    public let variablePositions: [String: String]?
}

public extension OverlayAnimateinType {
    init(rawValue: String?) {
        switch rawValue {
        case "fade_in":
            self = .fadeIn
        case "slide_from_top":
            self = .slideFromTop
        case "slide_from_bottom":
            self = .slideFromBottom
        case "slide_from_leading":
            self = .slideFromleading
        case "slide_from_trailing":
            self = .slideFromtrailing
        case "none":
            self = .none
        default:
            self = .unsupported
        }
    }
}

public extension OverlayAnimateoutType {
    init(rawValue: String?) {
        switch rawValue {
        case "fade_out":
            self = .fadeOut
        case "slide_to_top":
            self = .slideToTop
        case "slide_to_bottom":
            self = .slideToBottom
        case "slide_to_leading":
            self = .slideToLeading
        case "slide_to_trailing":
            self = .slideToTrailing
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
        case animateinType = "animatein_type"
        case animateoutType = "animateout_type"
        case animateinDuration = "animatein_duration"
        case animateoutDuration = "animateout_duration"
        case duration
        case variablePositions = "variable_positions"
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let customId: String? = try? container.decode(String.self, forKey: .customId)
        let svgURL: URL = try container.decode(URL.self, forKey: .svgURL)
        let position: Position = try container.decode(Position.self, forKey: .position)
        let size: Size = try container.decode(Size.self, forKey: .size)
        let animateinType: OverlayAnimateinType = OverlayAnimateinType(rawValue: try? container.decode(String.self, forKey: .animateinType))
        let animateoutType: OverlayAnimateoutType = OverlayAnimateoutType(rawValue: try? container.decode(String.self, forKey: .animateoutType))
        let animateinDuration: Double? = try? container.decode(Double.self, forKey: .animateinDuration)
        let animateoutDuration: Double? = try? container.decode(Double.self, forKey: .animateoutDuration)
        let duration: Double? = try? container.decode(Double.self, forKey: .duration)
        let variablePositions: [String: String]? = try? container.decode([String: String].self, forKey: .variablePositions)

        self.init(customId: customId, svgURL: svgURL, position: position, size: size, animateinType: animateinType, animateoutType: animateoutType, animateinDuration: animateinDuration, animateoutDuration: animateoutDuration, duration: duration, variablePositions: variablePositions)
    }
}
// MARK: - ActionHideOverlay

public struct ActionHideOverlay {
    public let customId: String
    public let animateoutType: OverlayAnimateoutType?
    public let animateoutDuration: Double?
}

extension ActionHideOverlay: Decodable {
    public enum CodingKeys: String, CodingKey {
        case customId = "custom_id"
        case animateoutType = "animateout_type"
        case animateoutDuration = "animateout_duration"
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let customId: String = try container.decode(String.self, forKey: .customId)
        let animateoutType: OverlayAnimateoutType = OverlayAnimateoutType(rawValue: try? container.decode(String.self, forKey: .animateoutType))
        let animateoutDuration: Double? = try? container.decode(Double.self, forKey: .animateoutDuration)

        self.init(customId: customId, animateoutType: animateoutType, animateoutDuration: animateoutDuration)
    }
}

// MARK: - ActionSetVariable

public struct ActionSetVariable {
    public let name: String
    public var stringValue: String?
    public var doubleValue: Double?
    public var longValue: Int64?
    public var doublePrecision: Int?
}

extension ActionSetVariable: Decodable {
    public enum CodingKeys: String, CodingKey {
        case name
        case value
        case type
        case doublePrecision = "double_precision"
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let name: String = try container.decode(String.self, forKey: .name)
        var stringValue: String? = nil
        var doubleValue: Double? = nil
        var longValue: Int64? = nil
        var doublePrecision: Int? = nil
        if let type = try? container.decode(String.self, forKey: .type) {
            switch type {
            case "string":
                stringValue = try? container.decode(String.self, forKey: .value)
            case "float", "double":
                doubleValue = try? container.decode(Double.self, forKey: .value)
                doublePrecision = try container.decode(Int.self, forKey: .doublePrecision)
            case "int", "long":
                longValue = try? container.decode(Int64.self, forKey: .value)
            default:
                break
            }
        }

        self.init(name: name, stringValue: stringValue, doubleValue: doubleValue, longValue: longValue, doublePrecision: doublePrecision)
    }
}

// MARK: - ActionIncrementVariable

public struct ActionIncrementVariable: Decodable {
    public let name: String
    public let amount: Double
}

// MARK: - ActionCreateTimer

public struct ActionCreateTimer {
    public enum Format {
        case ms
        case s
        case unsupported
    }
    public enum Direction {
        case up
        case down
        case unsupported
    }

    public let name: String
    public let format: Format
    public let direction: Direction
    public let startValue: Int64
    public let capValue: Int64?
}

public extension ActionCreateTimer.Format {
    init(rawValue: String?) {
        switch rawValue {
        case "ms":
            self = .ms
        case "s":
            self = .s
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
        case format
        case direction
        case startValue = "start_value"
        case capValue = "cap_value"
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let name: String = try container.decode(String.self, forKey: .name)
        let format: ActionCreateTimer.Format = ActionCreateTimer.Format(rawValue: try? container.decode(String.self, forKey: .format))
        let direction: ActionCreateTimer.Direction = ActionCreateTimer.Direction(rawValue: try? container.decode(String.self, forKey: .name))
        let startValue: Int64 = (try? container.decode(Int64.self, forKey: .startValue)) ?? 0
        let capValue: Int64? = try? container.decode(Int64.self, forKey: .capValue)

        self.init(name: name, format: format, direction: direction, startValue: startValue, capValue: capValue)
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

// MARK: - ActionCreateClock


public struct ActionCreateClock {
    public enum Format {
        case twelveHours
        case twentyfourHours
        case unsupported
    }

    public let name: String
    public let format: Format
}

public extension ActionCreateClock.Format {
    init(rawValue: String?) {
        switch rawValue {
        case "12h":
            self = .twelveHours
        case "24h":
            self = .twentyfourHours
        default:
            self = .unsupported
        }
    }
}

extension ActionCreateClock: Decodable {
    public enum CodingKeys: String, CodingKey {
        case name
        case format
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let name: String = try container.decode(String.self, forKey: .name)
        let format: ActionCreateClock.Format = ActionCreateClock.Format(rawValue: try? container.decode(String.self, forKey: .format))

        self.init(name: name, format: format)
    }
}
