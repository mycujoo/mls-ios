//
// Copyright © 2020 mycujoo. All rights reserved.
//

import Foundation
import UIKit


class AnnotationService: AnnotationServicing {
    struct EvaluationInput {
        /// The annotations being evaluated
        var actions: [AnnotationAction]
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
        var variables: [String: ActionVariable]
        /// A dictionary of ActionTimers as they are defined at the current point of evaluation. The keys are the names of these timers.
        var timers: [String: ActionTimer]
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
            var variables: [String: ActionVariable] = [:]
            var timers: [String: ActionTimer] = [:]

            // MARK:  Helpers

            var activeOverlayIds = input.activeOverlayIds
            var inRangeOverlayActions: [String: MLSUIOverlayAction] = [:]

            // MARK: Evaluate

            for action in input.actions.sorted(by: { (lhs, rhs) -> Bool in
                lhs.offset < rhs.offset || (lhs.offset == rhs.offset && lhs.priority >= rhs.priority)
            }) {
                let offset = Double(action.offset)
                switch action.data {
                case .showTimelineMarker(let data):
                    let timelineMarker = TimelineMarker(color: UIColor(hex: data.color), label: data.label)
                    let position = min(1.0, max(0.0, offset / input.currentDuration))

                    showTimelineMarkers.append(MLSUI.ShowTimelineMarkerAction(actionId: action.id, timelineMarker: timelineMarker, position: position))
                case .showOverlay(let data):
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
                case .setVariable(let data):
                    if offset <= input.currentTime {
                        variables[data.name] = ActionVariable(name: data.name, stringValue: data.stringValue, doubleValue: data.doubleValue, longValue: data.longValue, doublePrecision: data.doublePrecision)
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
                        let format: ActionTimer.Format
                        switch data.format {
                            case .ms: format = .ms
                            case .s: format = .s
                            case .unsupported: format = .unsupported
                        }

                        let direction: ActionTimer.Direction
                        switch data.direction {
                            case .up: direction = .up
                            case .down: direction = .down
                            case .unsupported: direction = .unsupported
                        }

                        timers[data.name] = ActionTimer(name: data.name, format: format, direction: direction, startValue: data.startValue, capValue: data.capValue)
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
                default:
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

            callback(EvaluationOutput(
                showTimelineMarkers: showTimelineMarkers,
                showOverlays: showOverlays,
                hideOverlays: hideOverlays,
                activeOverlayIds: activeOverlayIds,
                variables: variables,
                timers: timers
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
            variablePositions: actionData.variablePositions ?? [:])
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
        return MLSUI.ShowOverlayAction(actionId: action.actionId, overlay: action.overlay, position: action.position, size: action.size, animateType: .none, animateDuration: 0, variablePositions: action.variablePositions)
    }

    /// Removes the animation information. Useful for when the animation should not occur
    /// because the user jumped between different sections of the video and the overlay should be hidden instantly.
    func removeAnimation(from action: MLSUI.HideOverlayAction) -> MLSUI.HideOverlayAction {
        return MLSUI.HideOverlayAction(actionId: action.actionId, overlayId: action.overlayId, animateType: .none, animateDuration: 0)
    }
}

