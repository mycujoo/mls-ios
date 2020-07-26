//
// Copyright © 2020 mycujoo. All rights reserved.
//

import Foundation

// https://medium.com/makingtuenti/indeterminate-types-with-codable-in-swift-5a1af0aa9f3d

// Read for safely decoding while being less strict on types (option 3): https://paul-samuels.com/blog/2019/03/03/handling-bad-input-with-decodable/


extension DataLayer {
    // MARK: - Annotation
    struct AnnotationActionWrapper: Decodable {
        let actions: [AnnotationAction]
    }

    // MARK: - Action

    struct AnnotationAction: Hashable {
        let id: String
        private let type: String
        let offset: Int64
        let data: AnnotationActionData

        static func == (lhs: AnnotationAction, rhs: AnnotationAction) -> Bool {
            return lhs.id == rhs.id
        }

        func hash(into hasher: inout Hasher) {
            hasher.combine(id)
        }
    }

    enum AnnotationActionData {
        case showTimelineMarker(AnnotationActionShowTimelineMarker)
        case showOverlay(AnnotationActionShowOverlay)
        case hideOverlay(AnnotationActionHideOverlay)
        case setVariable(AnnotationActionSetVariable)
        case incrementVariable(AnnotationActionIncrementVariable)
        case createTimer(AnnotationActionCreateTimer)
        case startTimer(AnnotationActionStartTimer)
        case pauseTimer(AnnotationActionPauseTimer)
        case adjustTimer(AnnotationActionAdjustTimer)
        case skipTimer(AnnotationActionSkipTimer)
        case createClock(AnnotationActionCreateClock)
        case unsupported
    }

    // MARK: - ActionShowTimelineMarker

    struct AnnotationActionShowTimelineMarker: Decodable {
        let color: String
        let label: String
    }

    // MARK: - AnnotationActionShowOverlay

    enum OverlayAnimateinType {
        case fadeIn, slideFromTop, slideFromBottom, slideFromLeft, slideFromRight, none, unsupported
    }

    enum OverlayAnimateoutType {
        case fadeOut, slideToTop, slideToBottom, slideToLeft, slideToRight, none, unsupported
    }

    struct AnnotationActionShowOverlay {
        struct Position: Decodable {
            let top: Double?
            let bottom: Double?
            let vcenter: Double?
            let right: Double?
            let left: Double?
            let hcenter: Double?
        }

        struct Size: Decodable {
            let width: Double?
            let height: Double?
        }

        let customId: String?
        let svgURL: URL
        let position: Position
        let size: Size
        let animateinType: OverlayAnimateinType?
        let animateoutType: OverlayAnimateoutType?
        let animateinDuration: Double?
        let animateoutDuration: Double?
        let duration: Double?
        let variablePositions: [String: String]?
    }

    // MARK: - AnnotationActionHideOverlay

    struct AnnotationActionHideOverlay {
        let customId: String
        let animateoutType: OverlayAnimateoutType?
        let animateoutDuration: Double?
    }

    // MARK: - AnnotationActionSetVariable

    struct AnnotationActionSetVariable {
        let name: String
        var stringValue: String?
        var doubleValue: Double?
        var longValue: Int64?
        var doublePrecision: Int?
    }

    // MARK: - AnnotationActionIncrementVariable

    struct AnnotationActionIncrementVariable: Decodable {
        let name: String
        let amount: Double
    }

    // MARK: - AnnotationActionCreateTimer

    struct AnnotationActionCreateTimer {
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
        let startValue: Double
        let capValue: Double?
    }

    // MARK: - AnnotationActionStartTimer

    struct AnnotationActionStartTimer: Decodable {
        let name: String
    }

    // MARK: - AnnotationActionStartTimer

    struct AnnotationActionPauseTimer: Decodable {
        let name: String
    }

    // MARK: - AnnotationActionStartTimer

    struct AnnotationActionAdjustTimer: Decodable {
        let name: String
        let value: Double
    }

    // MARK: - AnnotationActionSkipTimer

    struct AnnotationActionSkipTimer: Decodable {
        let name: String
        let value: Double
    }

    // MARK: - AnnotationActionCreateClock

    struct AnnotationActionCreateClock {
        enum Format {
            case twelveHours
            case twentyfourHours
            case unsupported
        }

        let name: String
        let format: Format
    }
}



extension DataLayer.AnnotationAction: Decodable {
    enum CodingKeys: String, CodingKey {
        case id
        case type
        case offset
        case data
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let id = try container.decode(String.self, forKey: .id)
        let type = try container.decode(String.self, forKey: .type)
        let offset: Int64 = (try? container.decode(Int64.self, forKey: .offset)) ?? 0
        let data: DataLayer.AnnotationActionData
        switch type.lowercased() {
        case "show_timeline_marker":
            let rawData = try container.decode(DataLayer.AnnotationActionShowTimelineMarker.self, forKey: .data)
            data = .showTimelineMarker(rawData)
        case "show_overlay":
            let rawData = try container.decode(DataLayer.AnnotationActionShowOverlay.self, forKey: .data)
            data = .showOverlay(rawData)
        case "hide_overlay":
            let rawData = try container.decode(DataLayer.AnnotationActionHideOverlay.self, forKey: .data)
            data = .hideOverlay(rawData)
        case "set_variable":
            let rawData = try container.decode(DataLayer.AnnotationActionSetVariable.self, forKey: .data)
            data = .setVariable(rawData)
        case "increment_variable":
            let rawData = try container.decode(DataLayer.AnnotationActionIncrementVariable.self, forKey: .data)
            data = .incrementVariable(rawData)
        case "create_timer":
            let rawData = try container.decode(DataLayer.AnnotationActionCreateTimer.self, forKey: .data)
            data = .createTimer(rawData)
        case "start_timer":
            let rawData = try container.decode(DataLayer.AnnotationActionStartTimer.self, forKey: .data)
            data = .startTimer(rawData)
        case "pause_timer":
            let rawData = try container.decode(DataLayer.AnnotationActionPauseTimer.self, forKey: .data)
            data = .pauseTimer(rawData)
        case "adjust_timer":
            let rawData = try container.decode(DataLayer.AnnotationActionAdjustTimer.self, forKey: .data)
            data = .adjustTimer(rawData)
        case "skip_timer":
            let rawData = try container.decode(DataLayer.AnnotationActionSkipTimer.self, forKey: .data)
            data = .skipTimer(rawData)
        case "create_clock":
            let rawData = try container.decode(DataLayer.AnnotationActionCreateClock.self, forKey: .data)
            data = .createClock(rawData)
        default:
            data = .unsupported
        }

        self.init(id: id, type: type, offset: offset, data: data)
    }
}



extension DataLayer.OverlayAnimateinType {
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

extension DataLayer.OverlayAnimateoutType {
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

extension DataLayer.AnnotationActionShowOverlay: Decodable {
    enum CodingKeys: String, CodingKey {
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

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let customId: String? = try? container.decode(String.self, forKey: .customId)
        let svgURL: URL = try container.decode(URL.self, forKey: .svgURL)
        let position: Position = try container.decode(Position.self, forKey: .position)
        let size: Size = try container.decode(Size.self, forKey: .size)
        let animateinType: DataLayer.OverlayAnimateinType = DataLayer.OverlayAnimateinType(rawValue: try? container.decode(String.self, forKey: .animateinType))
        let animateoutType: DataLayer.OverlayAnimateoutType = DataLayer.OverlayAnimateoutType(rawValue: try? container.decode(String.self, forKey: .animateoutType))
        let animateinDuration: Double? = try? container.decode(Double.self, forKey: .animateinDuration)
        let animateoutDuration: Double? = try? container.decode(Double.self, forKey: .animateoutDuration)
        let duration: Double? = try? container.decode(Double.self, forKey: .duration)
        let variablePositions: [String: String]? = try? container.decode([String: String].self, forKey: .variablePositions)

        self.init(customId: customId, svgURL: svgURL, position: position, size: size, animateinType: animateinType, animateoutType: animateoutType, animateinDuration: animateinDuration, animateoutDuration: animateoutDuration, duration: duration, variablePositions: variablePositions)
    }
}
extension DataLayer.AnnotationActionHideOverlay: Decodable {
    enum CodingKeys: String, CodingKey {
        case customId = "custom_id"
        case animateoutType = "animateout_type"
        case animateoutDuration = "animateout_duration"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let customId: String = try container.decode(String.self, forKey: .customId)
        let animateoutType: DataLayer.OverlayAnimateoutType = DataLayer.OverlayAnimateoutType(rawValue: try? container.decode(String.self, forKey: .animateoutType))
        let animateoutDuration: Double? = try? container.decode(Double.self, forKey: .animateoutDuration)

        self.init(customId: customId, animateoutType: animateoutType, animateoutDuration: animateoutDuration)
    }
}


extension DataLayer.AnnotationActionSetVariable: Decodable {
    enum CodingKeys: String, CodingKey {
        case name
        case value
        case type
        case doublePrecision = "double_precision"
    }

    init(from decoder: Decoder) throws {
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
                doublePrecision = (try? container.decode(Int.self, forKey: .doublePrecision)) ?? 2
            case "int", "long":
                longValue = try? container.decode(Int64.self, forKey: .value)
            default:
                break
            }
        }

        self.init(name: name, stringValue: stringValue, doubleValue: doubleValue, longValue: longValue, doublePrecision: doublePrecision)
    }
}

extension DataLayer.AnnotationActionCreateTimer.Format {
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

extension DataLayer.AnnotationActionCreateTimer.Direction {
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

extension DataLayer.AnnotationActionCreateTimer: Decodable {
    enum CodingKeys: String, CodingKey {
        case name
        case format
        case direction
        case startValue = "start_value"
        case capValue = "cap_value"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let name: String = try container.decode(String.self, forKey: .name)
        let format: DataLayer.AnnotationActionCreateTimer.Format = DataLayer.AnnotationActionCreateTimer.Format(rawValue: try? container.decode(String.self, forKey: .format))
        let direction: DataLayer.AnnotationActionCreateTimer.Direction = DataLayer.AnnotationActionCreateTimer.Direction(rawValue: try? container.decode(String.self, forKey: .direction))
        let startValue: Double = (try? container.decode(Double.self, forKey: .startValue)) ?? 0
        let capValue: Double? = try? container.decode(Double.self, forKey: .capValue)

        self.init(name: name, format: format, direction: direction, startValue: startValue, capValue: capValue)
    }
}

extension DataLayer.AnnotationActionCreateClock.Format {
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

extension DataLayer.AnnotationActionCreateClock: Decodable {
    enum CodingKeys: String, CodingKey {
        case name
        case format
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let name: String = try container.decode(String.self, forKey: .name)
        let format: DataLayer.AnnotationActionCreateClock.Format = DataLayer.AnnotationActionCreateClock.Format(rawValue: try? container.decode(String.self, forKey: .format))

        self.init(name: name, format: format)
    }
}

// MARK: - Mappers

extension DataLayer.AnnotationAction {
    var toDomain: MLSSDK.AnnotationAction {
        let data = MLSSDK.AnnotationActionData.unsupported // tmp
        return MLSSDK.AnnotationAction(id: self.id, type: self.type, offset: self.offset, data: data)
    }
}

//extension DataLayer
