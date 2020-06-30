//
// Copyright © 2020 mycujoo. All rights reserved.
//

import Foundation
import UIKit


class AnnotationManager {

    private lazy var annotationsQueue = DispatchQueue(label: "tv.mycujoo.mls.annotations-queue")
    private weak var delegate: AnnotationManagerDelegate?

    var annotations: [Annotation] = []

    /// A Set of overlayIds that are currently active (i.e. on-screen).
    private var activeOverlayIds: Set<String> = Set()

    init(delegate: AnnotationManagerDelegate) {
        self.delegate = delegate
    }

    func evaluate(currentTime: Double, currentDuration: Double) {
        annotationsQueue.async { [weak self] in
            guard let self = self, currentDuration > 0 else { return }
            let annotations = self.annotations

            // MARK: Final actions

            var showTimelineMarkers: [ShowTimelineMarkerAction] = []
            var showOverlays: [ShowOverlayAction] = []
            var hideOverlays: [HideOverlayAction] = []

            // MARK:  Helpers

            var inRangeOverlayActions: [String: OverlayAction] = [:]

            // MARK: Evaluate

            for annotation in annotations {
                let offsetAsSeconds = Double(annotation.offset) / 1000
                for action in annotation.actions {
                    switch action.data {
                    case .showTimelineMarker(let data):
                        let timelineMarker = TimelineMarker(color: UIColor(hex: data.color), label: data.label)
                        let position = min(1.0, max(0.0, TimeInterval(annotation.offset / 1000) / currentDuration))

                        showTimelineMarkers.append(ShowTimelineMarkerAction(actionId: action.id, timelineMarker: timelineMarker, position: position))
                    case .showOverlay(let data):
                        if offsetAsSeconds <= currentTime {
                            if let duration = data.duration {
                                if currentTime < (offsetAsSeconds + duration) {
                                    if let obj = self.makeShowOverlay(from: action) {
                                        inRangeOverlayActions[obj.overlayId] = obj
                                    }
                                } else {
                                    if let obj = self.makeHideOverlay(from: action) {
                                        inRangeOverlayActions[obj.overlayId] = obj
                                    }
                                }
                            } else {
                                if let obj = self.makeShowOverlay(from: action) {
                                    inRangeOverlayActions[obj.overlayId] = obj
                                }
                            }
                        }

                    case .hideOverlay:
                        if offsetAsSeconds <= currentTime {
                            if let obj = self.makeHideOverlay(from: action) {
                                inRangeOverlayActions[obj.overlayId] = obj
                            }
                        }
//                    case .setVariable(let data):
//                        break
//                    case .incrementVariable(let data):
//                        break
//                    case .createTimer(let data):
//                        break
//                    case .startTimer(let data):
//                        break
//                    case .pauseTimer(let data):
//                        break
//                    case .adjustTimer(let data):
//                        break
//                    case .unsupported:
//                        break
                    default:
                        break
                    }
                }
            }

            var remainingActiveOverlayIds = self.activeOverlayIds
            for (_, action) in inRangeOverlayActions {
                if remainingActiveOverlayIds.contains(action.overlayId) {
                    remainingActiveOverlayIds.remove(action.overlayId)
                    if let action = action as? HideOverlayAction {
                        // The overlay is currently active AND should be hidden.
                        hideOverlays.append(action)
                        self.activeOverlayIds.remove(action.overlayId)
                    }
                } else {
                    if let action = action as? ShowOverlayAction {
                        // The overlay is not currently active AND should be shown.
                        showOverlays.append(action)
                        self.activeOverlayIds.insert(action.overlayId)
                    }
                }
            }

            for overlayId in remainingActiveOverlayIds {
                // These are all overlayIds that were active but no longer are. Remove those from screen as well.
                hideOverlays.append(HideOverlayAction(actionId: overlayId, overlayId: overlayId, animateType: .none, animateDuration: 0.0))
                self.activeOverlayIds.remove(overlayId)
            }

            DispatchQueue.main.async { [weak self] in
                self?.delegate?.setTimelineMarkers(with: showTimelineMarkers)
                if showOverlays.count > 0 {
                    self?.delegate?.showOverlays(with: showOverlays)
                }
                if hideOverlays.count > 0 {
                    self?.delegate?.hideOverlays(with: hideOverlays)
                }
            }
        }
    }
}

fileprivate extension AnnotationManager {
    func makeShowOverlay(from action: AnnotationAction) -> ShowOverlayAction? {
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

        return ShowOverlayAction(
            actionId: action.id,
            overlay: overlay,
            position: actionData.position,
            size: actionData.size,
            animateType: actionData.animateinType ?? .fadeIn,
            animateDuration: actionData.animateinDuration ?? 0.3)
    }

    func makeHideOverlay(from action: AnnotationAction) -> HideOverlayAction? {
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
        return HideOverlayAction(
            actionId: action.id,
            overlayId: overlayId ?? action.id,
            animateType: animateType ?? .fadeOut,
            animateDuration: animateDuration ?? 0.3)
    }

    /// Removes the animation information. Useful for when the animation should not occur
    /// because the user jumped between different sections of the video and the overlay should be hidden instantly.
    func removeAnimation(from action: ShowOverlayAction) -> ShowOverlayAction {
        return ShowOverlayAction(actionId: action.actionId, overlay: action.overlay, position: action.position, size: action.size, animateType: .none, animateDuration: 0)
    }

    /// Removes the animation information. Useful for when the animation should not occur
    /// because the user jumped between different sections of the video and the overlay should be hidden instantly.
    func removeAnimation(from action: HideOverlayAction) -> HideOverlayAction {
        return HideOverlayAction(actionId: action.actionId, overlayId: action.overlayId, animateType: .none, animateDuration: 0)
    }
}

protocol AnnotationManagerDelegate: class {
    /// Gets triggered often, and will often contain the same ShowTimelineMarker actions. It is up to the delegate to interpret which ones are new.
    func setTimelineMarkers(with actions: [ShowTimelineMarkerAction])
    /// Gets triggered whenever an overlay needs to be shown. Unlike `setTimelineMarkers`,
    /// this will only contain actions that are new and can therefore be executed immediately.
    func showOverlays(with actions: [ShowOverlayAction])
    /// Gets triggered whenever an overlay needs to be hidden. Unlike `setTimelineMarkers`,
    /// this will only contain actions that are new and can therefore be executed immediately.
    func hideOverlays(with actions: [HideOverlayAction])
}


