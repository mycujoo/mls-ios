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

            var showTimelineMarkers: [(position: Double, marker: TimelineMarker)] = []

            var inRangeShowOverlayActions: Set<Action> = Set()
            var hideOverlayActions: [Action] = []
            var showOverlayActions: [Action] = []

            for annotation in annotations {
                let offsetAsDouble = Double(annotation.offset)
                for action in annotation.actions {
                    switch action.data {
                    case .showTimelineMarker(let data):
                        let color = UIColor(hex: data.color) ?? UIColor.gray
                        // There should not be multiple timeline markers for a single annotation, so reuse annotation id on the timeline marker.
                        let timelineMarker = TimelineMarker(id: annotation.id, kind: .singleLineText(text: data.label), markerColor: color, timestamp: TimeInterval(annotation.offset / 1000))
                        showTimelineMarkers.append((position: min(1.0, max(0.0, timelineMarker.timestamp / currentDuration)), marker: timelineMarker))
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
    func setTimelineMarkers(with objects: [(position: Double, marker: TimelineMarker)])
    func showOverlays(with objects: [Action])
}
