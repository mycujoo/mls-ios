//
// Copyright © 2020 mycujoo. All rights reserved.
//

import Foundation

// https://medium.com/makingtuenti/indeterminate-types-with-codable-in-swift-5a1af0aa9f3d

// Read for safely decoding while being less strict on types (option 3): https://paul-samuels.com/blog/2019/03/03/handling-bad-input-with-decodable/


// MARK: - Action

public struct AnnotationAction: Hashable {
    public let id: String
    public let offset: Int64
    /// A UNIX timestamp (in milliseconds) of the absolute time at which this action happened.
    /// Can be used to calculate the video offset against HLS playlists in cases where the video length exceeds the DVR window.
    public let timestamp: Int64
    public let data: AnnotationActionData

    /// A priority indicates what the order of actions should be when they happen at the same offset. A higher priority means it should go first.
    public var priority: Int {
        switch data {
        case .deleteAction:
            return 2000
        case .setVariable, .createTimer:
            return 1000
        case .startTimer:
            return 500
        case .pauseTimer:
            return 400
        case .adjustTimer:
            return 300
        case .showOverlay:
            return 100
        default:
            return 0
        }
    }

    public init(id: String, offset: Int64, timestamp: Int64, data: AnnotationActionData) {
        self.id = id
        self.offset = offset
        self.timestamp = timestamp
        self.data = data
    }

    static public func == (lhs: AnnotationAction, rhs: AnnotationAction) -> Bool {
        return lhs.id == rhs.id
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

public enum AnnotationActionData {
    case deleteAction(AnnotationActionDeleteAction)
    case showTimelineMarker(AnnotationActionShowTimelineMarker)
    case showOverlay(AnnotationActionShowOverlay)
    case hideOverlay(AnnotationActionHideOverlay)
    case reshowOverlay(AnnotationActionReshowOverlay)
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

public struct AnnotationActionDeleteAction {
    public let actionId: String

    public init(actionId: String) {
        self.actionId = actionId
    }
}

// MARK: - ActionShowTimelineMarker

public struct AnnotationActionShowTimelineMarker {
    public let color: String
    public let label: String
    public let seekOffset: Int

    public init(color: String, label: String, seekOffset: Int) {
        self.color = color
        self.label = label
        self.seekOffset = seekOffset
    }
}

// MARK: - AnnotationActionShowOverlay

public enum OverlayAnimateinType {
    case fadeIn, slideFromTop, slideFromBottom, slideFromLeft, slideFromRight, none, unsupported
}

public enum OverlayAnimateoutType {
    case fadeOut, slideToTop, slideToBottom, slideToLeft, slideToRight, none, unsupported
}

public struct AnnotationActionShowOverlay {
    public struct Position {
        public let top: Double?
        public let bottom: Double?
        public let vcenter: Double?
        public let right: Double?
        public let left: Double?
        public let hcenter: Double?

        public init(top: Double?, bottom: Double?, vcenter: Double?, right: Double?, left: Double?, hcenter: Double?) {
            self.top = top
            self.bottom = bottom
            self.vcenter = vcenter
            self.right = right
            self.left = left
            self.hcenter = hcenter
        }
    }

    public struct Size {
        public let width: Double?
        public let height: Double?

        public init(width: Double?, height: Double?) {
            self.width = width
            self.height = height
        }
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
    public let variables: [String]?

    public init(
            customId: String?,
            svgURL: URL,
            position: Position,
            size: Size,
            animateinType: OverlayAnimateinType?,
            animateoutType: OverlayAnimateoutType?,
            animateinDuration: Double?,
            animateoutDuration: Double?,
            duration: Double?,
            variables: [String]?
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
        self.variables = variables
    }
}

// MARK: - AnnotationActionHideOverlay

public struct AnnotationActionHideOverlay {
    public let customId: String
    public let animateoutType: OverlayAnimateoutType?
    public let animateoutDuration: Double?

    public init(customId: String, animateoutType: OverlayAnimateoutType?, animateoutDuration: Double?) {
        self.customId = customId
        self.animateoutType = animateoutType
        self.animateoutDuration = animateoutDuration
    }
}

// MARK: - AnnotationActionHideOverlay

public struct AnnotationActionReshowOverlay {
    public let customId: String

    public init(customId: String) {
        self.customId = customId
    }
}

// MARK: - AnnotationActionSetVariable

public struct AnnotationActionSetVariable {
    public let name: String
    public var stringValue: String?
    public var doubleValue: Double?
    public var longValue: Int64?
    public var doublePrecision: Int?

    public init(
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

public struct AnnotationActionIncrementVariable {
    public let name: String
    public let amount: Double

    public init(name: String, amount: Double) {
        self.name = name
        self.amount = amount
    }
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
    public let startValue: Double
    public let capValue: Double?

    public init(
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

public struct AnnotationActionStartTimer {
    public let name: String

    public init(name: String) {
        self.name = name
    }
}

// MARK: - AnnotationActionStartTimer

public struct AnnotationActionPauseTimer {
    public let name: String

    public init(name: String) {
        self.name = name
    }
}

// MARK: - AnnotationActionStartTimer

public struct AnnotationActionAdjustTimer {
    public let name: String
    public let value: Double

    public init(name: String, value: Double) {
        self.name = name
        self.value = value
    }
}

// MARK: - AnnotationActionSkipTimer

public struct AnnotationActionSkipTimer {
    public let name: String
    public let value: Double

    public init(name: String, value: Double) {
        self.name = name
        self.value = value
    }
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

    public init(name: String, format: Format) {
        self.name = name
        self.format = format
    }
}
