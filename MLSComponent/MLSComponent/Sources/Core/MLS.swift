//
// Copyright © 2020 mycujoo. All rights reserved.
//

import Foundation
import Moya

public struct Configuration {
    public init() { }
}

public struct Stream {

    public let urls: NonEmptyArray<URL>

    /// - Parameter urls: nonempty collection of URLs. Could be initialized with a single URL .init(streamURL)
    /// or with multiple URLs separated by coma .init(streamURL, streamURL)
    public init(urls: NonEmptyArray<URL>) {
        self.urls = urls
    }
}

public struct Event {
    public let id: String
    public let stream: Stream?

    public init(id: String, stream: Stream?) {
        self.id = id
        self.stream = stream
    }
}

public class MLS {
    public let publicKey: String
    public let configuration: Configuration
    private var moyaProvider: MoyaProvider<API>

    public init(publicKey: String, configuration: Configuration) {
        self.publicKey = publicKey
        self.configuration = configuration
        self.moyaProvider = MoyaProvider<API>(stubClosure: MoyaProvider.immediatelyStub)
    }

    public func videoPlayer(with event: Event? = nil, autoplay: Bool = true) -> VideoPlayer {
        let player = VideoPlayer()
        if let event = event {
            player.playVideo(with: event, autoplay: autoplay)

            // TODO: Should not pass eventId but timelineId
            moyaProvider.request(.annotations(event.id)) { result in
                switch result {
                case .success(let response):
                    let decoder = JSONDecoder()
                    do {
                        let annotationWrapper = try decoder.decode(AnnotationWrapper.self, from: response.data)
                        let annotations = annotationWrapper.annotations
                        print("Sterling!", annotations)
                    } catch let error {
                        if let decodingError = error as? DecodingError {
                            print("NocturalError converting", decodingError)
                        }
                    }
//                    player.updateAnnotations(annotations: annotations) // tmp disable
                    print("REsponse dadata")
                    print(response.data)
                case .failure(_):
                    // TODO: Handle this case.
                    break
                }
            }
        }



        // configuration attach
        return player
    }

    public func eventList(completionHandler: ([Event]) -> ()) {
        // server request
    }
}


















public struct AnnotationWrapper: Decodable {
    public let annotations: [Annotation]
}

public struct Annotation: Decodable {
    public let id: String
    public let timelineId: String
    public let offset: Int64
    public let actions: [AnnotationAction]
}

public extension Annotation {
    public enum CodingKeys: String, CodingKey {
        case id
        case timelineId = "timeline_id"
        case offset
        case actions
    }

    public init(from decoder: Decoder) throws {
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
public enum AnnotationAction {
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
    public enum CodingKeys: String, CodingKey {
        case type
        case data
    }

    public init(from decoder: Decoder) throws {
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

public struct AnnotationActionShowTimelineMarker: Decodable {
    public let color: String
    public let label: String
}

// MARK: - AnnotationActionShowOverlay


public struct AnnotationActionShowOverlay {
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

public extension AnnotationActionShowOverlay.AnimationinType {
    public init(rawValue: String?) {
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

public extension AnnotationActionShowOverlay.AnimationoutType {
    public init(rawValue: String?) {
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
// MARK: - AnnotationActionHideOverlay

public struct AnnotationActionHideOverlay {
    public let customId: String
}

extension AnnotationActionHideOverlay: Decodable {
    public enum CodingKeys: String, CodingKey {
        case customId = "custom_id"
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let customId: String = try container.decode(String.self, forKey: .customId)

        self.init(customId: customId)
    }
}

// MARK: - AnnotationActionSetVariable

public struct AnnotationActionSetVariable {
    public let name: String
    public let stringValue: String?
    public let numberValue: Double?
    public let boolValue: Bool?
}

extension AnnotationActionSetVariable: Decodable {
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

// MARK: - AnnotationActionIncrementVariable

public struct AnnotationActionIncrementVariable: Decodable {
    public let name: String
    public let amount: Double
}

// MARK: - AnnotationActionCreateTimer

public struct AnnotationActionCreateTimer {
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

public extension AnnotationActionCreateTimer.ClockType {
    init(rawValue: String?) {
        switch rawValue {
        case "standard":
            self = .standard
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
        case clockType = "clock_type"
        case direction
        case startValue = "start_value"
        case capValue = "cap_value"
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let name: String = try container.decode(String.self, forKey: .name)
        let clockType: AnnotationActionCreateTimer.ClockType = AnnotationActionCreateTimer.ClockType(rawValue: try? container.decode(String.self, forKey: .clockType))
        let direction: AnnotationActionCreateTimer.Direction = AnnotationActionCreateTimer.Direction(rawValue: try? container.decode(String.self, forKey: .name))
        let startValue: Int64 = (try? container.decode(Int64.self, forKey: .startValue)) ?? 0
        let capValue: Int64? = try? container.decode(Int64.self, forKey: .capValue)

        self.init(name: name, clockType: clockType, direction: direction, startValue: startValue, capValue: capValue)
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
