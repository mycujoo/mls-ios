//
// Copyright © 2020 mycujoo. All rights reserved.
//

import Foundation

// https://medium.com/makingtuenti/indeterminate-types-with-codable-in-swift-5a1af0aa9f3d

// Read for safely decoding while being less strict on types (option 3): https://paul-samuels.com/blog/2019/03/03/handling-bad-input-with-decodable/


extension DataLayer {
    // MARK: - Annotation
    struct AnnotationActionWrapper {
        let updateId: String?
        let actions: [AnnotationAction]
    }

    // MARK: - Action

    struct AnnotationAction {
        let id: String
        private let type: String
        let offset: Int64
        let timestamp: Int64
        let data: AnnotationActionData
    }

    enum AnnotationActionData {
        case deleteAction(AnnotationActionDeleteAction)
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

    // MARK: - ActionDeleteAction

    struct AnnotationActionDeleteAction {
        let actionId: String
    }

    // MARK: - ActionShowTimelineMarker

    struct AnnotationActionShowTimelineMarker {
        let color: String
        let label: String
        let seekOffset: Int
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
        let variables: [String]?
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


extension DataLayer.AnnotationActionWrapper: Decodable {
    enum CodingKeys: String, CodingKey {
        case actions
        case updateId = "update_id"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let updateId: String? = try? container.decode(String.self, forKey: .updateId)
        let actions: [DataLayer.AnnotationAction] = try container.decode([DataLayer.AnnotationAction].self, forKey: .actions)

        self.init(updateId: updateId, actions: actions)
    }
}


extension DataLayer.AnnotationAction: Decodable {
    enum CodingKeys: String, CodingKey {
        case id
        case type
        case offset
        case timestamp
        case data
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let id = try container.decode(String.self, forKey: .id)
        let type = try container.decode(String.self, forKey: .type)
        let offset: Int64 = Int64((try? container.decode(String.self, forKey: .offset)) ?? "0") ?? 0
        let timestamp: Int64 = Int64((try? container.decode(String.self, forKey: .timestamp)) ?? "0") ?? 0
        let data: DataLayer.AnnotationActionData
        switch type.lowercased() {
        case "delete_action":
            let rawData = try container.decode(DataLayer.AnnotationActionDeleteAction.self, forKey: .data)
            data = .deleteAction(rawData)
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

        self.init(id: id, type: type, offset: offset, timestamp: timestamp, data: data)
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

extension DataLayer.AnnotationActionDeleteAction: Decodable {
    enum CodingKeys: String, CodingKey {
        case actionId = "action_id"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let actionId: String = try container.decode(String.self, forKey: .actionId)

        self.init(actionId: actionId)
    }
}

extension DataLayer.AnnotationActionShowTimelineMarker: Decodable {
    enum CodingKeys: String, CodingKey {
        case color
        case label
        case seekOffset = "seek_offset"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let color: String = try container.decode(String.self, forKey: .color)
        let label: String = try container.decode(String.self, forKey: .label)
        let seekOffset: Int = (try? container.decode(Int.self, forKey: .seekOffset)) ?? 0

        self.init(color: color, label: label, seekOffset: seekOffset)
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
        case variables = "variables"
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
        let variables: [String]? = try? container.decode([String].self, forKey: .variables)

        self.init(customId: customId, svgURL: svgURL, position: position, size: size, animateinType: animateinType, animateoutType: animateoutType, animateinDuration: animateinDuration, animateoutDuration: animateoutDuration, duration: duration, variables: variables)
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
        let data: MLSSDK.AnnotationActionData
        switch self.data {
        case .deleteAction(let d):       data = .deleteAction(d.toDomain)
        case .showTimelineMarker(let d): data = .showTimelineMarker(d.toDomain)
        case .showOverlay(let d):        data = .showOverlay(d.toDomain)
        case .hideOverlay(let d):        data = .hideOverlay(d.toDomain)
        case .setVariable(let d):        data = .setVariable(d.toDomain)
        case .incrementVariable(let d):  data = .incrementVariable(d.toDomain)
        case .createTimer(let d):        data = .createTimer(d.toDomain)
        case .startTimer(let d):         data = .startTimer(d.toDomain)
        case .pauseTimer(let d):         data = .pauseTimer(d.toDomain)
        case .adjustTimer(let d):        data = .adjustTimer(d.toDomain)
        case .skipTimer(let d):          data = .skipTimer(d.toDomain)
        case .createClock(let d):        data = .createClock(d.toDomain)
        case .unsupported:               data = .unsupported
        }
        return MLSSDK.AnnotationAction(id: self.id, type: self.type, offset: self.offset, timestamp: self.timestamp, data: data)
    }
}

extension DataLayer.AnnotationActionDeleteAction {
    var toDomain: MLSSDK.AnnotationActionDeleteAction {
        return MLSSDK.AnnotationActionDeleteAction(actionId: self.actionId)
    }
}

extension DataLayer.AnnotationActionShowTimelineMarker {
    var toDomain: MLSSDK.AnnotationActionShowTimelineMarker {
        return MLSSDK.AnnotationActionShowTimelineMarker(color: self.color, label: self.label, seekOffset: self.seekOffset)
    }
}

extension DataLayer.OverlayAnimateinType {
    var toDomain: MLSSDK.OverlayAnimateinType {
        switch self {
            case .fadeIn:          return .fadeIn
            case .slideFromTop:    return .slideFromTop
            case .slideFromBottom: return .slideFromBottom
            case .slideFromLeft:   return .slideFromLeft
            case .slideFromRight:  return .slideFromRight
            case .none:            return .none
            case .unsupported:     return .unsupported
        }
    }
}

extension DataLayer.OverlayAnimateoutType {
    var toDomain: MLSSDK.OverlayAnimateoutType {
        switch self {
            case .fadeOut:       return .fadeOut
            case .slideToTop:    return .slideToTop
            case .slideToBottom: return .slideToBottom
            case .slideToLeft:   return .slideToLeft
            case .slideToRight:  return .slideToRight
            case .none:          return .none
            case .unsupported:   return .unsupported
        }
    }
}

extension DataLayer.AnnotationActionShowOverlay.Position {
    var toDomain: MLSSDK.AnnotationActionShowOverlay.Position {
        return MLSSDK.AnnotationActionShowOverlay.Position(top: self.top, bottom: self.bottom, vcenter: self.vcenter, right: self.right, left: self.left, hcenter: self.hcenter)
    }
}

extension DataLayer.AnnotationActionShowOverlay.Size {
    var toDomain: MLSSDK.AnnotationActionShowOverlay.Size {
        return MLSSDK.AnnotationActionShowOverlay.Size(width: self.width, height: self.height)
    }
}

extension DataLayer.AnnotationActionShowOverlay {
    var toDomain: MLSSDK.AnnotationActionShowOverlay {
        return MLSSDK.AnnotationActionShowOverlay(
            customId: self.customId,
            svgURL: self.svgURL,
            position: self.position.toDomain,
            size: self.size.toDomain,
            animateinType: self.animateinType?.toDomain,
            animateoutType: self.animateoutType?.toDomain,
            animateinDuration: self.animateinDuration,
            animateoutDuration: self.animateoutDuration,
            duration: self.duration,
            variables: self.variables)
    }
}

extension DataLayer.AnnotationActionHideOverlay {
    var toDomain: MLSSDK.AnnotationActionHideOverlay {
        return MLSSDK.AnnotationActionHideOverlay(customId: self.customId, animateoutType: self.animateoutType?.toDomain, animateoutDuration: self.animateoutDuration)
    }
}

extension DataLayer.AnnotationActionSetVariable {
    var toDomain: MLSSDK.AnnotationActionSetVariable {
        return MLSSDK.AnnotationActionSetVariable(name: self.name, stringValue: self.stringValue, doubleValue: self.doubleValue, longValue: self.longValue, doublePrecision: self.doublePrecision)
    }
}

extension DataLayer.AnnotationActionIncrementVariable {
    var toDomain: MLSSDK.AnnotationActionIncrementVariable {
        return MLSSDK.AnnotationActionIncrementVariable(name: self.name, amount: self.amount)
    }
}

extension DataLayer.AnnotationActionCreateTimer.Format {
    var toDomain: MLSSDK.AnnotationActionCreateTimer.Format {
        switch self {
            case .ms:          return .ms
            case .s:           return .s
            case .unsupported: return .unsupported
        }
    }
}

extension DataLayer.AnnotationActionCreateTimer.Direction {
    var toDomain: MLSSDK.AnnotationActionCreateTimer.Direction {
        switch self {
            case .up:          return .up
            case .down:        return .down
            case .unsupported: return .unsupported
        }
    }
}

extension DataLayer.AnnotationActionCreateTimer {
    var toDomain: MLSSDK.AnnotationActionCreateTimer {
        return MLSSDK.AnnotationActionCreateTimer(name: self.name, format: self.format.toDomain, direction: self.direction.toDomain, startValue: self.startValue, capValue: self.capValue)
    }
}

extension DataLayer.AnnotationActionStartTimer {
    var toDomain: MLSSDK.AnnotationActionStartTimer {
        return MLSSDK.AnnotationActionStartTimer(name: self.name)
    }
}

extension DataLayer.AnnotationActionPauseTimer {
    var toDomain: MLSSDK.AnnotationActionPauseTimer {
        return MLSSDK.AnnotationActionPauseTimer(name: self.name)
    }
}

extension DataLayer.AnnotationActionAdjustTimer {
    var toDomain: MLSSDK.AnnotationActionAdjustTimer {
        return MLSSDK.AnnotationActionAdjustTimer(name: self.name, value: self.value)
    }
}

extension DataLayer.AnnotationActionSkipTimer {
    var toDomain: MLSSDK.AnnotationActionSkipTimer {
        return MLSSDK.AnnotationActionSkipTimer(name: self.name, value: self.value)
    }
}

extension DataLayer.AnnotationActionCreateClock.Format {
    var toDomain: MLSSDK.AnnotationActionCreateClock.Format {
        switch self {
            case .twelveHours:     return .twelveHours
            case .twentyfourHours: return .twentyfourHours
            case .unsupported:     return .unsupported
        }
    }
}

extension DataLayer.AnnotationActionCreateClock {
    var toDomain: MLSSDK.AnnotationActionCreateClock {
        return MLSSDK.AnnotationActionCreateClock(name: self.name, format: self.format.toDomain)
    }
}
