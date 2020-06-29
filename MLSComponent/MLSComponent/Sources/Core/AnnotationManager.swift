//
// Copyright © 2020 mycujoo. All rights reserved.
//

import Foundation
import UIKit


class AnnotationManager {

    private lazy var annotationsQueue = DispatchQueue(label: "tv.mycujoo.mls.annotations-queue")
    private weak var delegate: AnnotationManagerDelegate?

    var annotations: [Annotation] = []

    var activeShowOverlayActions: Set<Action> = Set()

    init(delegate: AnnotationManagerDelegate) {
        self.delegate = delegate
    }

    func evaluate(currentTime: Double, currentDuration: Double) {
        annotationsQueue.async { [weak self] in
            guard let self = self, currentDuration > 0 else { return }
            let annotations = self.annotations

            // MARK: Final actions

            var showTimelineMarkers: [ShowTimelineMarker] = []
            var showOverlays: [ShowOverlay] = []
            var hideOverlays: [HideOverlay] = []

            // MARK:  Helpers

            var inRangeShowOverlayActions: Set<Action> = Set()

            // MARK: Evaluate

            for annotation in annotations {
                let offsetAsSeconds = Double(annotation.offset) / 1000
                for action in annotation.actions {
                    switch action.data {
                    case .showTimelineMarker(let data):
                        let timelineMarker = TimelineMarker(color: UIColor(hex: data.color), label: data.label)
                        let position = min(1.0, max(0.0, TimeInterval(annotation.offset / 1000) / currentDuration))

                        showTimelineMarkers.append(ShowTimelineMarker(actionId: action.id, timelineMarker: timelineMarker, position: position))
                    case .showOverlay(let data):
                        if let duration = data.duration {
                            if offsetAsSeconds <= currentTime && currentTime < (offsetAsSeconds + duration) {
                                inRangeShowOverlayActions.insert(action)
                            }
                        } else {
                            if offsetAsSeconds <= currentTime {
                                inRangeShowOverlayActions.insert(action)
                            }
                        }
                    case .hideOverlay(let data):
                        break
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

            let showOverlayActions = inRangeShowOverlayActions.subtracting(self.activeShowOverlayActions)
            let hideOverlayActions = self.activeShowOverlayActions.subtracting(inRangeShowOverlayActions)
            self.activeShowOverlayActions = self.activeShowOverlayActions.union(showOverlayActions).subtracting(hideOverlayActions)

            showOverlays = showOverlayActions
                .map { action -> ShowOverlay? in
                    let actionData: ActionShowOverlay
                    switch action.data {
                    case .showOverlay(let d):
                        actionData = d
                    default:
                        return nil
                    }

                    let overlay = Overlay(
                        id: actionData.customId ?? action.id,
                        svgURL: actionData.svgURL)

                    return ShowOverlay(
                        actionId: action.id,
                        overlay: overlay,
                        position: actionData.position,
                        size: actionData.size,
                        animateType: actionData.animateinType ?? .fadeIn,
                        animateDuration: actionData.animateinDuration ?? 0.3)
                }
                .filter { $0 != nil }
                .map { $0! }

            hideOverlays = hideOverlayActions
                .map { action -> HideOverlay in
                    let actionData: ActionShowOverlay?
                    switch action.data {
                    case .showOverlay(let d):
                        actionData = d
                    default:
                        actionData = nil
                    }
                    return HideOverlay(
                        actionId: action.id,
                        overlayId: actionData?.customId ?? action.id,
                        animateType: actionData?.animateoutType ?? .fadeOut,
                        animateDuration: actionData?.animateoutDuration ?? 0.3)
                }

            // TODO: Merge hideOverlays (which is based on ShowOverlay actions) with a HideOverlayAction based list.

            DispatchQueue.main.async { [weak self] in
                self?.delegate?.setTimelineMarkers(with: showTimelineMarkers)
                self?.delegate?.showOverlays(with: showOverlays)
                self?.delegate?.hideOverlays(with: hideOverlays)
            }
        }
    }
}

protocol AnnotationManagerDelegate: class {
    /// Gets triggered often, and will often contain the same ShowTimelineMarker actions. It is up to the delegate to interpret which ones are new.
    func setTimelineMarkers(with actions: [ShowTimelineMarker])
    /// Gets triggered whenever an overlay needs to be shown. Unlike `setTimelineMarkers`,
    /// this will only contain actions that are new and can therefore be executed immediately.
    func showOverlays(with actions: [ShowOverlay])
    /// Gets triggered whenever an overlay needs to be hidden. Unlike `setTimelineMarkers`,
    /// this will only contain actions that are new and can therefore be executed immediately.
    func hideOverlays(with actions: [HideOverlay])
}


