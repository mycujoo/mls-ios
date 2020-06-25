//
// Copyright © 2020 mycujoo. All rights reserved.
//

import Foundation


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
            guard let self = self else { return }

            guard currentDuration > 0 else { return }

            let annotations = self.annotations

            var showTimelineMarkers: [ShowTimelineMarker] = []

            var inRangeShowOverlayActions: Set<Action> = Set()
            var hideOverlayActions: [Action] = []
            var showOverlayActions: [Action] = []

            for annotation in annotations {
                let offsetAsDouble = Double(annotation.offset)
                for action in annotation.actions {
                    switch action.data {
                    case .showTimelineMarker(let data):
                        let timelineMarker = TimelineMarker(color: UIColor(hex: data.color) ?? UIColor.gray, label: data.label)
                        let position = min(1.0, max(0.0, TimeInterval(annotation.offset / 1000) / currentDuration))

                        showTimelineMarkers.append(ShowTimelineMarker(actionId: action.id, timelineMarker: timelineMarker, position: position))
                    case .showOverlay(let data):
                        guard let duration = data.duration else { break } // tmp, to keep it simple. Should remove later for non-duration bound actions.

                        if (offsetAsDouble...offsetAsDouble+duration).contains(currentTime) {
                            inRangeShowOverlayActions.insert(action)
                        }
                    case .hideOverlay(let data):
                        break
                    case .setVariable(let data):
                        break
                    case .incrementVariable(let data):
                        break
                    case .createTimer(let data):
                        break
                    case .startTimer(let data):
                        break
                    case .pauseTimer(let data):
                        break
                    case .adjustTimer(let data):
                        break
                    case .unsupported:
                        break
                    default:
                        break
                    }
                }
            }








            DispatchQueue.main.async { [weak self] in
                self?.delegate?.setTimelineMarkers(with: showTimelineMarkers)

            }
        }
    }
}

protocol AnnotationManagerDelegate: class {
    func setTimelineMarkers(with objects: [ShowTimelineMarker])
//    func showOverlays(with objects: [Action])
}


