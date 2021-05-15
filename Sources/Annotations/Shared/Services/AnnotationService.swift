//
// Copyright © 2021 mycujoo. All rights reserved.
//

import Foundation
import UIKit
import MLSSDK


class AnnotationService: AnnotationServicing {
    struct EvaluationInput {
        /// The annotations being evaluated
        var actions: [AnnotationAction]
        /// (OPTIONAL) a list of mappings between an AnnotationAction id and the videoOffset that should be used.
        /// Should only be applied if the videoOffset to be used is different than the offset stored on the annotation itself.
        /// This is primarily the case when the video length exceeds the DVR window.
        /// `inGap` Indicates that this action happened within a video gap, i.e. a moment in real time for which there is no video available. This will have an affect on how the action is evaluated (e.g. it may be ignored).
        var offsetMappings: [String: (videoOffset: Int64, inGap: Bool)?]?
        /// A Set of overlayIds that are currently active (i.e. on-screen). This is obtained through a previous evaluation. Should initially be an empty set.
        var activeOverlayIds: Set<String>
        /// The elapsed time (in milliseconds) of the currently playing item of the video player.
        var currentTime: Double
        /// The total duration (in milliseconds) of the currently playing item of the video player (this changes for live streams).
        var currentDuration: Double
    }

    struct EvaluationOutput {
        /// Will often contain the same ShowTimelineMarker actions compared to the previous EvaluationOutput. It is up to the downstream to interpret which ones are new.
        var showTimelineMarkers: [MLSUI.ShowTimelineMarkerAction] = []
        /// Contains only those actions for which an overlay needs to be shown. Unlike `setTimelineMarkers`,
        /// this will only contain actions that are new and can therefore be executed immediately.
        var showOverlays: [MLSUI.ShowOverlayAction] = []
        /// Contains only those actions for which an overlay needs to be hidden. Unlike `setTimelineMarkers`,
        /// this will only contain actions that are new and can therefore be executed immediately.
        var hideOverlays: [MLSUI.HideOverlayAction] = []
        /// A Set of overlayIds that are currently active (i.e. on-screen). This should be passed on as input to the next evaluation.
        var activeOverlayIds: Set<String>
        /// A dictionary of ActionVariables as they are defined at the current point of evaluation. The keys are the names of these variables.
        var tovs: [String: TOVStore.TOV]
    }

    private lazy var annotationsQueue = DispatchQueue(label: "tv.mycujoo.mls.annotations-queue")

    init() {}

    /// Evaluates all the known annotations and tells the AnnotationServiceDelegate to perform certain actions.
    ///
    func evaluate(_ input: EvaluationInput, callback: @escaping (EvaluationOutput) -> ()) {
        annotationsQueue.async { [weak self] in
            guard let self = self, input.currentDuration > 0 else { return }

            // MARK: Final output

            var showTimelineMarkers: [MLSUI.ShowTimelineMarkerAction] = []
            var showOverlays: [MLSUI.ShowOverlayAction] = []
            var hideOverlays: [MLSUI.HideOverlayAction] = []
            var variables: [String: AnnotationService.Variable] = [:]
            var timers: [String: AnnotationService.Timer] = [:]

            // MARK:  Helpers

            var activeOverlayIds = input.activeOverlayIds
            var inRangeOverlayActions: [String: MLSUIOverlayAction] = [:]
            /// An array of action ids that should get deleted.
            var deletedActionIds: [String] = []
            /// A dictionary with keys being custom ids and values being the show overlay data.
            var showOverlayActionData: [String: AnnotationActionShowOverlay] = [:]

            // MARK: Preprocessing actions

            let sortedActions = input.actions
                .sorted(by: { (lhs, rhs) -> Bool in
                    lhs.offset < rhs.offset || (lhs.offset == rhs.offset && lhs.priority >= rhs.priority)
                })

            for action in sortedActions {
                switch action.data {
                case .deleteAction(let d):
                    deletedActionIds.append(d.actionId)
                case .showOverlay(let d):
                    if let customId = d.customId {
                        showOverlayActionData[customId] = d
                    }
                default:
                    continue
                }
            }

            // MARK: Processing actions

            for action in sortedActions
                .filter({ !deletedActionIds.contains($0.id) })
                .map ({ action -> AnnotationAction? in
                    switch action.data {
                    case .reshowOverlay(let d):
                        // Map this reshowOverlay to a showOverlay action.
                        if let showOverlayData = showOverlayActionData[d.customId] {
                            return AnnotationAction(id: action.id, offset: action.offset, timestamp: action.timestamp, data: AnnotationActionData.showOverlay(showOverlayData))
                        }
                        return nil
                    default:
                        return action
                    }
                })
                .compactMap ({ $0 })
            {
                let offsetMapping = input.offsetMappings?[action.id]
                /// The video offset, i.e. the moment in the available video stream at which this action happened. Defined in milliseconds.
                let offset = Double(offsetMapping??.videoOffset ?? action.offset)
                /// Indicates that this action happened within a video gap, i.e. a moment in real time for which there is no video available.
                /// Certain actions like variable and timer manipulations should still happen (e.g. to ensure accurate scores), but others should not,  like timeline markers.
                /// Also assume that the action is in a gap if the offset is -1, which is a special value to account for "unknown"
                /// offsets.
                let inGap = offsetMapping??.inGap ?? (offset == -1) // Double equality check: dangerous.
                switch action.data {
                case .showTimelineMarker(let data):
                    guard !inGap && offset >= 0 else { continue }

                    let timelineMarker = TimelineMarker(color: UIColor(fromHex: data.color), label: data.label, seekOffset: data.seekOffset)
                    let position = min(1.0, max(0.0, offset / input.currentDuration))
                    let seekPosition = min(1.0, max(0.0, (offset + Double(data.seekOffset)) / input.currentDuration))

                    showTimelineMarkers.append(MLSUI.ShowTimelineMarkerAction(actionId: action.id, timelineMarker: timelineMarker, position: position, seekPosition: seekPosition))
                case .showOverlay(let data):
                    if inGap && data.duration != nil {
                        // If the show overlay action is in a gap we want to ignore it,
                        // but only if it is an ephemeral overlay. For long-lived overlays
                        // like scoreboard, it should still be evaluated, because they should
                        // potentially still show up.
                        continue
                    }

                    if offset <= input.currentTime {
                        if let duration = data.duration {
                            if input.currentTime < offset + duration {
                                if let obj = self.makeShowOverlay(from: action) {
                                    if input.currentTime < offset + duration + obj.animateDuration + 1000 {
                                        inRangeOverlayActions[obj.overlayId] = obj
                                    } else {
                                        inRangeOverlayActions[obj.overlayId] = self.removeAnimation(from: obj)
                                    }
                                }
                            } else {
                                if let obj = self.makeHideOverlay(from: action) {
                                    if input.currentTime < offset + duration + obj.animateDuration + 1000 {
                                        inRangeOverlayActions[obj.overlayId] = obj
                                    } else {
                                        inRangeOverlayActions[obj.overlayId] = self.removeAnimation(from: obj)
                                    }
                                }
                            }
                        } else {
                            if let obj = self.makeShowOverlay(from: action) {
                                if input.currentTime < offset + obj.animateDuration + 1000 {
                                    inRangeOverlayActions[obj.overlayId] = obj
                                } else {
                                    inRangeOverlayActions[obj.overlayId] = self.removeAnimation(from: obj)
                                }
                            }
                        }
                    }
                case .hideOverlay:
                    if offset <= input.currentTime {
                        if let obj = self.makeHideOverlay(from: action) {
                            if input.currentTime < offset + obj.animateDuration + 1000 {
                                inRangeOverlayActions[obj.overlayId] = obj
                            } else {
                                inRangeOverlayActions[obj.overlayId] = self.removeAnimation(from: obj)
                            }
                        }
                    }
                case .reshowOverlay:
                    // This was already remapped to showOverlay earlier on, so this can be ignored here.
                    continue
                case .setVariable(let data):
                    if offset <= input.currentTime {
                        variables[data.name] = AnnotationService.Variable(name: data.name, stringValue: data.stringValue, doubleValue: data.doubleValue, longValue: data.longValue, doublePrecision: data.doublePrecision)
                    }
                case .incrementVariable(let data):
                    if offset <= input.currentTime {
                        guard let variable = variables[data.name] else { continue }

                        if variable.longValue != nil {
                            variable.longValue! += Int64(data.amount)
                        } else if variable.doubleValue != nil {
                            variable.doubleValue! += data.amount
                        }
                    }
                case .createTimer(let data):
                    if offset <= input.currentTime {
                        let format: AnnotationService.Timer.Format
                        switch data.format {
                            case .ms: format = .ms
                            case .s: format = .s
                            case .unsupported: format = .unsupported
                        }

                        let direction: AnnotationService.Timer.Direction
                        switch data.direction {
                            case .up: direction = .up
                            case .down: direction = .down
                            case .unsupported: direction = .unsupported
                        }

                        timers[data.name] = AnnotationService.Timer(name: data.name, format: format, direction: direction, startValue: data.startValue, capValue: data.capValue)
                    }
                case .startTimer(let data):
                    if offset <= input.currentTime {
                        guard let timer = timers[data.name] else { continue }

                        timer.update(isRunning: true, at: offset)
                    }
                case .pauseTimer(let data):
                    if offset <= input.currentTime {
                        guard let timer = timers[data.name] else { continue }

                        timer.update(isRunning: false, at: offset)
                    }
                case .adjustTimer(let data):
                    if offset <= input.currentTime {
                        guard let timer = timers[data.name] else { continue }

                        timer.forceAdjustTo(value: data.value, at: offset)
                    }
                case .skipTimer(let data):
                    if offset <= input.currentTime {
                        guard let timer = timers[data.name] else { continue }

                        timer.forceAdjustBy(value: data.value, at: offset)
                    }
                case .deleteAction, .createClock, .unsupported:
                    break
                }
            }


            var remainingActiveOverlayIds = activeOverlayIds
            for (_, action) in inRangeOverlayActions {
                if remainingActiveOverlayIds.contains(action.overlayId) {
                    remainingActiveOverlayIds.remove(action.overlayId)
                    if let action = action as? MLSUI.HideOverlayAction {
                        // The overlay is currently active AND should be hidden.
                        hideOverlays.append(action)
                        activeOverlayIds.remove(action.overlayId)
                    }
                } else {
                    if let action = action as? MLSUI.ShowOverlayAction {
                        // The overlay is not currently active AND should be shown.
                        showOverlays.append(action)
                        activeOverlayIds.insert(action.overlayId)
                    }
                }
            }

            for overlayId in remainingActiveOverlayIds {
                // These are all overlayIds that were active but no longer are. Remove those from screen as well.
                hideOverlays.append(MLSUI.HideOverlayAction(actionId: overlayId, overlayId: overlayId, animateType: .none, animateDuration: 0.0))
                activeOverlayIds.remove(overlayId)
            }

            for (_, timer) in timers {
                // Ensure that the timers are up-to-date with the offset of this evaluation cycle.
                timer.materialize(at: input.currentTime)
            }

            let tovs = Dictionary(uniqueKeysWithValues: (variables.map { ($0.key, TOVStore.TOV(name: $0.value.name, humanFriendlyValue: $0.value.humanFriendlyValue)) }) + (timers.map { ($0.key, TOVStore.TOV(name: $0.value.name, humanFriendlyValue: $0.value.humanFriendlyValue)) }))

            callback(EvaluationOutput(
                showTimelineMarkers: showTimelineMarkers,
                showOverlays: showOverlays,
                hideOverlays: hideOverlays,
                activeOverlayIds: activeOverlayIds,
                tovs: tovs
            ))
        }
    }
}

fileprivate extension AnnotationService {
    func makeShowOverlay(from action: AnnotationAction) -> MLSUI.ShowOverlayAction? {
        let actionData: AnnotationActionShowOverlay
        switch action.data {
        case .showOverlay(let d):
            actionData = d
        default:
            return nil
        }

        let overlay = Overlay(
            id: actionData.customId ?? action.id,
            svgURL: actionData.svgURL)

        return MLSUI.ShowOverlayAction(
            actionId: action.id,
            overlay: overlay,
            position: actionData.position,
            size: actionData.size,
            animateType: actionData.animateinType ?? .fadeIn,
            animateDuration: actionData.animateinDuration ?? 300,
            variables: actionData.variables ?? [])
    }

    func makeHideOverlay(from action: AnnotationAction) -> MLSUI.HideOverlayAction? {
        let overlayId: String?
        let animateType: OverlayAnimateoutType?
        let animateDuration: Double?

        switch action.data {
        case .showOverlay(let d):
            overlayId = d.customId
            animateType = d.animateoutType
            animateDuration = d.animateoutDuration
        case .hideOverlay(let d):
            overlayId = d.customId
            animateType = d.animateoutType
            animateDuration = d.animateoutDuration
        default:
            return nil
        }
        return MLSUI.HideOverlayAction(
            actionId: action.id,
            overlayId: overlayId ?? action.id,
            animateType: animateType ?? .fadeOut,
            animateDuration: animateDuration ?? 300)
    }

    /// Removes the animation information. Useful for when the animation should not occur
    /// because the user jumped between different sections of the video and the overlay should be hidden instantly.
    func removeAnimation(from action: MLSUI.ShowOverlayAction) -> MLSUI.ShowOverlayAction {
        return MLSUI.ShowOverlayAction(actionId: action.actionId, overlay: action.overlay, position: action.position, size: action.size, animateType: .none, animateDuration: 0, variables: action.variables)
    }

    /// Removes the animation information. Useful for when the animation should not occur
    /// because the user jumped between different sections of the video and the overlay should be hidden instantly.
    func removeAnimation(from action: MLSUI.HideOverlayAction) -> MLSUI.HideOverlayAction {
        return MLSUI.HideOverlayAction(actionId: action.actionId, overlayId: action.overlayId, animateType: .none, animateDuration: 0)
    }
}

fileprivate extension AnnotationService {

    // MARK: Variable

    class Variable: Equatable {
        static func == (lhs: Variable, rhs: Variable) -> Bool {
            return
                lhs.name == rhs.name &&
                lhs.stringValue == rhs.stringValue &&
                lhs.doubleValue == rhs.doubleValue &&
                lhs.longValue == rhs.longValue &&
                lhs.doublePrecision == rhs.doublePrecision
        }

        let name: String
        var stringValue: String?
        var doubleValue: Double?
        var longValue: Int64?
        var doublePrecision: Int?

        init(name: String, stringValue: String?, doubleValue: Double?, longValue: Int64?, doublePrecision: Int?) {
            self.name = name
            self.stringValue = stringValue
            self.doubleValue = doubleValue
            self.longValue = longValue
            self.doublePrecision = doublePrecision
        }

        var humanFriendlyValue: String {
            if let stringValue = stringValue {
                return stringValue
            }
            else if let longValue = longValue {
                return String(describing: longValue)
            }
            else if let doubleValue = doubleValue {
                return String(format: "%.\(min(15, doublePrecision ?? 2))f", doubleValue)
            }
            return ""
        }
    }

    // MARK: Timer

    class Timer: Equatable {
        static func == (lhs: Timer, rhs: Timer) -> Bool {
            return
                lhs.name == rhs.name &&
                lhs.format == rhs.format &&
                lhs.direction == rhs.direction &&
                lhs.startValue == rhs.startValue &&
                lhs.capValue == rhs.capValue &&
                lhs.isRunning == rhs.isRunning &&
                // Do not include lastUpdatedAtOffset, since that unnecessary makes this seem like a different timer.
                lhs.value == rhs.value
        }

        enum Format: String {
            case ms = "ms"
            case s = "s"
            case unsupported = "unsupported"
        }
        enum Direction: String {
            case up = "up"
            case down = "down"
            case unsupported = "unsupported"
        }

        let name: String
        let format: Format
        let direction: Direction
        let startValue: Double
        let capValue: Double?

        private var value: Double
        private var isRunning = false
        private var lastUpdatedAtOffset: Double? = nil

        /// - parameter startValue: A value in milliseconds that indicates the initial value of the timer.
        /// - parameter capValue: A value in milliseconds that indicates the limit value of the timer (either higher or lower than startValue, depending on the direction)
        init(name: String, format: Format, direction: Direction, startValue: Double, capValue: Double? = nil) {
            self.name = name
            self.format = format
            self.direction = direction
            self.startValue = startValue
            self.capValue = capValue

            self.value = startValue
        }

        var humanFriendlyValue: String {
            let valueAsSeconds = value / 1000
            switch format {
            case .ms:
                let seconds = valueAsSeconds.truncatingRemainder(dividingBy: 60)
                let minutes = (valueAsSeconds - seconds) / 60
                return String(format: "%02.0f:%02.0f", floor(minutes), floor(seconds))
            case .s, .unsupported:
                return String(format: "%.0f", floor(valueAsSeconds))
            }
        }

        /// Should be called whenever the state of the timer changes. This internally updates the `value` property.
        func update(isRunning: Bool, at offset: Double) {
            materialize(at: offset)
            self.isRunning = isRunning
        }

        /// Forces the timer to take on a new absolute value, regardless of anything that happened previously.
        func forceAdjustTo(value: Double, at offset: Double) {
            updateValueWithRulesApplied(v: value, absolute: true)
            self.lastUpdatedAtOffset = offset
        }

        /// Forces the timer to be adjusted by a relative value.
        func forceAdjustBy(value: Double, at offset: Double) {
            materialize(at: offset)
            updateValueWithRulesApplied(v: value, absolute: false)
        }

        /// Should be called to materialize the value of this timer at a specific offset. This internally updates the `value` property.
        func materialize(at offset: Double) {
            if isRunning {
                switch direction {
                case .down:
                    self.value = self.value - (offset - (lastUpdatedAtOffset ?? 0))
                    if let capValue = capValue {
                        self.value = max(capValue, self.value)
                    }
                case .up, .unsupported:
                self.value = self.value + (offset - (lastUpdatedAtOffset ?? 0))
                    if let capValue = capValue {
                        self.value = min(capValue, self.value)
                    }
                }
            }
            self.lastUpdatedAtOffset = offset
        }

        /// Manipulates the `value` variable based while respecting the direction and capValue.
        /// - parameter v: The value that `value` should have if `absolute` is true, or the value that `value` should be updated by if `absolute` is false.
        /// - parameter absolute: Whether the value is being replaced (true) or added (false).
        private func updateValueWithRulesApplied(v: Double, absolute: Bool) {
            switch direction {
            case .down:
                if absolute {
                    self.value = v
                } else {
                    self.value -= v
                }
                if let capValue = capValue {
                    self.value = max(capValue, self.value)
                }
            case .up, .unsupported:
                if absolute {
                    self.value = v
                } else {
                    self.value += v
                }
                if let capValue = capValue {
                    self.value = min(capValue, self.value)
                }
            }
        }
    }
}
