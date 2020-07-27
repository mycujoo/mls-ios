//
// Copyright © 2020 mycujoo. All rights reserved.
//

import Foundation

// https://medium.com/makingtuenti/indeterminate-types-with-codable-in-swift-5a1af0aa9f3d

// Read for safely decoding while being less strict on types (option 3): https://paul-samuels.com/blog/2019/03/03/handling-bad-input-with-decodable/


// MARK: - Action

struct AnnotationAction: Hashable {
    let id: String
    private let type: String
    let offset: Int64
    let data: AnnotationActionData

    /// A priority indicates what the order of actions should be when they happen at the same offset. A higher priority means it should go first.
    var priority: Int {
        switch type {
        case "set_variable", "create_timer":
            return 1000
        case "start_timer":
            return 500
        case "pause_timer":
            return 400
        case "adjust_timer":
            return 300
        default:
            return 0
        }
    }

    init(id: String, type: String, offset: Int64, data: AnnotationActionData) {
        self.id = id
        self.type = type
        self.offset = offset
        self.data = data
    }

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

struct AnnotationActionShowTimelineMarker {
    let color: String
    let label: String

    init(color: String, label: String) {
        self.color = color
        self.label = label
    }
}

// MARK: - AnnotationActionShowOverlay

enum OverlayAnimateinType {
    case fadeIn, slideFromTop, slideFromBottom, slideFromLeft, slideFromRight, none, unsupported
}

enum OverlayAnimateoutType {
    case fadeOut, slideToTop, slideToBottom, slideToLeft, slideToRight, none, unsupported
}

struct AnnotationActionShowOverlay {
    struct Position {
        let top: Double?
        let bottom: Double?
        let vcenter: Double?
        let right: Double?
        let left: Double?
        let hcenter: Double?

        init(top: Double?, bottom: Double?, vcenter: Double?, right: Double?, left: Double?, hcenter: Double?) {
            self.top = top
            self.bottom = bottom
            self.vcenter = vcenter
            self.right = right
            self.left = left
            self.hcenter = hcenter
        }
    }

    struct Size {
        let width: Double?
        let height: Double?

        init(width: Double?, height: Double?) {
            self.width = width
            self.height = height
        }
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

    init(
            customId: String?,
            svgURL: URL,
            position: Position,
            size: Size,
            animateinType: OverlayAnimateinType?,
            animateoutType: OverlayAnimateoutType?,
            animateinDuration: Double?,
            animateoutDuration: Double?,
            duration: Double?,
            variablePositions: [String: String]?
    ) {
        self.customId = customId
        self.svgURL = svgURL
        self.position = position
        self.size = size
        self.animateinType = animateinType
        self.animateoutType = animateoutType
        self.animateinDuration = animateinDuration
        self.animateoutDuration = animateoutDuration
        self.duration = duration
        self.variablePositions = variablePositions
    }
}

// MARK: - AnnotationActionHideOverlay

struct AnnotationActionHideOverlay {
    let customId: String
    let animateoutType: OverlayAnimateoutType?
    let animateoutDuration: Double?

    init(customId: String, animateoutType: OverlayAnimateoutType?, animateoutDuration: Double?) {
        self.customId = customId
        self.animateoutType = animateoutType
        self.animateoutDuration = animateoutDuration
    }
}

// MARK: - AnnotationActionSetVariable

struct AnnotationActionSetVariable {
    let name: String
    var stringValue: String?
    var doubleValue: Double?
    var longValue: Int64?
    var doublePrecision: Int?

    init(
            name: String,
            stringValue: String?,
            doubleValue: Double?,
            longValue: Int64?,
            doublePrecision: Int?
    ) {
        self.name = name
        self.stringValue = stringValue
        self.doubleValue = doubleValue
        self.longValue = longValue
        self.doublePrecision = doublePrecision
    }
}

// MARK: - AnnotationActionIncrementVariable

struct AnnotationActionIncrementVariable {
    let name: String
    let amount: Double

    init(name: String, amount: Double) {
        self.name = name
        self.amount = amount
    }
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

    init(
            name: String,
            format: Format,
            direction: Direction,
            startValue: Double,
            capValue: Double?
    ) {
        self.name = name
        self.format = format
        self.direction = direction
        self.startValue = startValue
        self.capValue = capValue
    }
}

// MARK: - AnnotationActionStartTimer

struct AnnotationActionStartTimer {
    let name: String

    init(name: String) {
        self.name = name
    }
}

// MARK: - AnnotationActionStartTimer

struct AnnotationActionPauseTimer {
    let name: String

    init(name: String) {
        self.name = name
    }
}

// MARK: - AnnotationActionStartTimer

struct AnnotationActionAdjustTimer {
    let name: String
    let value: Double

    init(name: String, value: Double) {
        self.name = name
        self.value = value
    }
}

// MARK: - AnnotationActionSkipTimer

struct AnnotationActionSkipTimer {
    let name: String
    let value: Double

    init(name: String, value: Double) {
        self.name = name
        self.value = value
    }
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

    init(name: String, format: Format) {
        self.name = name
        self.format = format
    }
}
