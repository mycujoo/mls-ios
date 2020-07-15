//
// Copyright © 2020 mycujoo. All rights reserved.
//

import Foundation

// https://medium.com/makingtuenti/indeterminate-types-with-codable-in-swift-5a1af0aa9f3d

// Read for safely decoding while being less strict on types (option 3): https://paul-samuels.com/blog/2019/03/03/handling-bad-input-with-decodable/

// MARK: - Annotation


public struct AnnotationActionWrapper: Decodable {
    public let actions: [AnnotationAction]
}

// MARK: - Action

public struct AnnotationAction: Hashable {
    let id: String
    private let type: String
    let offset: Int64
    let data: AnnotationActionData

    public static func == (lhs: AnnotationAction, rhs: AnnotationAction) -> Bool {
        return lhs.id == rhs.id
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

extension AnnotationAction: Decodable {
    public enum CodingKeys: String, CodingKey {
        case id
        case type
        case offset
        case data
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let id = try container.decode(String.self, forKey: .id)
        let type = try container.decode(String.self, forKey: .type)
        let offset: Int64 = (try? container.decode(Int64.self, forKey: .offset)) ?? 0
        let data: AnnotationActionData
        switch type.lowercased() {
        case "show_timeline_marker":
            let rawData = try container.decode(AnnotationActionShowTimelineMarker.self, forKey: .data)
            data = .showTimelineMarker(rawData)
        case "show_overlay":
            let rawData = try container.decode(AnnotationActionShowOverlay.self, forKey: .data)
            data = .showOverlay(rawData)
        case "hide_overlay":
            let rawData = try container.decode(AnnotationActionHideOverlay.self, forKey: .data)
            data = .hideOverlay(rawData)
        case "set_variable":
            let rawData = try container.decode(AnnotationActionSetVariable.self, forKey: .data)
            data = .setVariable(rawData)
        case "increment_variable":
            let rawData = try container.decode(AnnotationActionIncrementVariable.self, forKey: .data)
            data = .incrementVariable(rawData)
        case "create_timer":
            let rawData = try container.decode(AnnotationActionCreateTimer.self, forKey: .data)
            data = .createTimer(rawData)
        case "start_timer":
            let rawData = try container.decode(AnnotationActionStartTimer.self, forKey: .data)
            data = .startTimer(rawData)
        case "pause_timer":
            let rawData = try container.decode(AnnotationActionPauseTimer.self, forKey: .data)
            data = .pauseTimer(rawData)
        case "adjust_timer":
            let rawData = try container.decode(AnnotationActionAdjustTimer.self, forKey: .data)
            data = .adjustTimer(rawData)
        case "create_clock":
            let rawData = try container.decode(AnnotationActionCreateClock.self, forKey: .data)
            data = .createClock(rawData)
        default:
            data = .unsupported
        }

        self.init(id: id, type: type, offset: offset, data: data)
    }
}

public enum AnnotationActionData {
    case showTimelineMarker(AnnotationActionShowTimelineMarker)
    case showOverlay(AnnotationActionShowOverlay)
    case hideOverlay(AnnotationActionHideOverlay)
    case setVariable(AnnotationActionSetVariable)
    case incrementVariable(AnnotationActionIncrementVariable)
    case createTimer(AnnotationActionCreateTimer)
    case startTimer(AnnotationActionStartTimer)
    case pauseTimer(AnnotationActionPauseTimer)
    case adjustTimer(AnnotationActionAdjustTimer)
    case createClock(AnnotationActionCreateClock)
    case unsupported
}


// MARK: - ActionShowTimelineMarker

public struct AnnotationActionShowTimelineMarker: Decodable {
    public let color: String
    public let label: String
}

// MARK: - AnnotationActionShowOverlay

public enum OverlayAnimateinType {
    case fadeIn, slideFromTop, slideFromBottom, slideFromLeft, slideFromRight, none, unsupported
}

public enum OverlayAnimateoutType {
    case fadeOut, slideToTop, slideToBottom, slideToLeft, slideToRight, none, unsupported
}

public struct AnnotationActionShowOverlay {
    public struct Position: Decodable {
        public let top: Double?
        public let bottom: Double?
        public let vcenter: Double?
        public let right: Double?
        public let left: Double?
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

public extension OverlayAnimateoutType {
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

extension AnnotationActionShowOverlay: Decodable {
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
// MARK: - AnnotationActionHideOverlay

public struct AnnotationActionHideOverlay {
    public let customId: String
    public let animateoutType: OverlayAnimateoutType?
    public let animateoutDuration: Double?
}

extension AnnotationActionHideOverlay: Decodable {
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

// MARK: - AnnotationActionSetVariable

public struct AnnotationActionSetVariable {
    public let name: String
    public var stringValue: String?
    public var doubleValue: Double?
    public var longValue: Int64?
    public var doublePrecision: Int?
}

extension AnnotationActionSetVariable: Decodable {
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

// MARK: - AnnotationActionIncrementVariable

public struct AnnotationActionIncrementVariable: Decodable {
    public let name: String
    public let amount: Double
}

// MARK: - AnnotationActionCreateTimer

public struct AnnotationActionCreateTimer {
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

public extension AnnotationActionCreateTimer.Format {
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

public extension AnnotationActionCreateTimer.Direction {
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
        let format: AnnotationActionCreateTimer.Format = AnnotationActionCreateTimer.Format(rawValue: try? container.decode(String.self, forKey: .format))
        let direction: AnnotationActionCreateTimer.Direction = AnnotationActionCreateTimer.Direction(rawValue: try? container.decode(String.self, forKey: .name))
        let startValue: Int64 = (try? container.decode(Int64.self, forKey: .startValue)) ?? 0
        let capValue: Int64? = try? container.decode(Int64.self, forKey: .capValue)

        self.init(name: name, format: format, direction: direction, startValue: startValue, capValue: capValue)
    }
}

// MARK: - AnnotationActionStartTimer

public struct AnnotationActionStartTimer: Decodable {
    public let name: String
}

// MARK: - AnnotationActionStartTimer

public struct AnnotationActionPauseTimer: Decodable {
    public let name: String
}

// MARK: - AnnotationActionStartTimer

public struct AnnotationActionAdjustTimer: Decodable {
    public let name: String
    public let value: Int64
}

// MARK: - AnnotationActionCreateClock


public struct AnnotationActionCreateClock {
    public enum Format {
        case twelveHours
        case twentyfourHours
        case unsupported
    }

    public let name: String
    public let format: Format
}

public extension AnnotationActionCreateClock.Format {
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

extension AnnotationActionCreateClock: Decodable {
    public enum CodingKeys: String, CodingKey {
        case name
        case format
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let name: String = try container.decode(String.self, forKey: .name)
        let format: AnnotationActionCreateClock.Format = AnnotationActionCreateClock.Format(rawValue: try? container.decode(String.self, forKey: .format))

        self.init(name: name, format: format)
    }
}
