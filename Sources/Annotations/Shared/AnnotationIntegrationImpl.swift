//
// Copyright © 2021 mycujoo. All rights reserved.
//

import Foundation
import UIKit
import MLSSDK



class AnnotationIntegrationImpl: NSObject, AnnotationIntegration {
    // MARK: Protocol conformance
    var timelineId: String? {
        didSet {
            let new = timelineId != oldValue
            if new, let oldTimelineId = oldValue {
                cleanup(oldTimelineId: oldTimelineId)
            }
            rebuildTimeline(new: new)
        }
    }
    
    // MARK: Internal
    weak var delegate: AnnotationIntegrationDelegate?
    
    private let annotationService: AnnotationServicing
    private let hlsInspectionService: HLSInspectionServicing
    private let getTimelineActionsUpdatesUseCase: GetTimelineActionsUpdatesUseCase
    private let getSVGUseCase: GetSVGUseCase
    
    private(set) var annotationActions: [AnnotationAction] = [] {
        didSet {
            evaluate()
        }
    }
    
    private var tovStore: TOVStore? = nil
    private var activeOverlayIds: Set<String> = Set()
    
    /// A dictionary of dynamic overlays currently showing within this view. Keys are the overlay identifiers.
    /// The UIView should be the outer container of the overlay, not the SVGView directly.
    private var overlays: [String: UIView] = [:]
    
    init(
        annotationService: AnnotationServicing,
        hlsInspectionService: HLSInspectionServicing,
        getTimelineActionsUpdatesUseCase: GetTimelineActionsUpdatesUseCase,
        getSVGUseCase: GetSVGUseCase,
        delegate: AnnotationIntegrationDelegate) {
        self.annotationService = annotationService
        self.hlsInspectionService = hlsInspectionService
        self.getTimelineActionsUpdatesUseCase = getTimelineActionsUpdatesUseCase
        self.getSVGUseCase = getSVGUseCase
        self.delegate = delegate
    }
    
    /// This should get called whenever a new Timeline is loaded into the video player.
    private func rebuildTimeline(new: Bool) {
        if new, let timelineId = timelineId {
            tovStore = TOVStore()
            
            getTimelineActionsUpdatesUseCase.start(id: timelineId) { [weak self] update in
                switch update {
                case .actionsUpdated(let actions):
                    self?.annotationActions = actions
                }
            }
        }
    }
    
    private func cleanup(oldTimelineId: String) {
        getTimelineActionsUpdatesUseCase.stop(id: oldTimelineId)
    }
    
    func evaluate() {
        guard let delegate = delegate else { return }
        
        let allAnnotationActions = annotationActions + delegate.localAnnotationActions
        
        // If the video is (roughly) as long as the total DVR window, then that means that it is dropping segments.
        // Because of this, we need to start calculating action offsets against the video ourselves.
        let offsetMappings: [String: (videoOffset: Int64, inGap: Bool)?]?
        
        if Int(delegate.currentDuration) + 20 > (delegate.currentDvrWindowSize ?? Int.max) / 1000 {
            #if os(iOS)
            if delegate.isCasting() == true {
                // We can't evaluate annotations at this point, since we do not have access to the raw playlist.
                return
            }
            #endif

            let map = hlsInspectionService.map(hlsPlaylist: delegate.currentRawSegmentPlaylist, absoluteTimes: allAnnotationActions.map { $0.timestamp })
            offsetMappings = Dictionary(allAnnotationActions.map { (k: $0.id, v: map[$0.timestamp] ?? nil) }) { _, last in last }
        } else {
            offsetMappings = nil
        }
        
        annotationService.evaluate(AnnotationService.EvaluationInput(actions: allAnnotationActions, offsetMappings: offsetMappings, activeOverlayIds: activeOverlayIds, currentTime: delegate.optimisticCurrentTime * 1000, currentDuration: delegate.currentDuration * 1000)) { [weak self] output in

            self?.activeOverlayIds = output.activeOverlayIds

            self?.tovStore?.new(tovs: output.tovs)

            DispatchQueue.main.async { [weak self] in
                self?.delegate?.view.setTimelineMarkers(with: output.showTimelineMarkers)
                if output.showOverlays.count > 0 {
                    self?.showOverlays(with: output.showOverlays)
                }
                if output.hideOverlays.count > 0 {
                    self?.hideOverlays(with: output.hideOverlays)
                }
            }
        }
    }
    
    private func svgParseAndRender(action: MLSUI.ShowOverlayAction, baseSVG: String) {
        var baseSVG = baseSVG
        // On every variable/timer change, re-place all variables and timers in the svg again
        // (because we only have the initial SVG, we don't keep its updated states with the original tokens
        // included).
        guard let tovStore = self.tovStore else { return }
        for variableName in action.variables {
            // Fallback to the variable name if there is no variable defined.
            // The reason for this is that certain "variable-like" values might have slipped through,
            // e.g. prices that start with a dollar sign.
            let resolved = tovStore.get(by: variableName)?.humanFriendlyValue ?? variableName
            baseSVG = baseSVG.replacingOccurrences(of: variableName, with: resolved)
        }

        if let node = try? SVGParser.parse(text: baseSVG), let bounds = node.bounds {
            DispatchQueue.main.async { [weak self] in
                guard let self = self, let delegate = self.delegate else { return }

                let imageView = SVGView(node: node, frame: CGRect(x: 0, y: 0, width: bounds.w, height: bounds.h))
                imageView.clipsToBounds = true
                imageView.backgroundColor = .none

                if let containerView = self.overlays[action.overlayId] {
                    delegate.view.replaceOverlay(containerView: containerView, imageView: imageView)
                } else {
                    self.overlays[action.overlayId] = delegate.view.placeOverlay(imageView: imageView, size: action.size, position: action.position, animateType: action.animateType, animateDuration: action.animateDuration)
                }
            }
        }
    }
    
    private func showOverlays(with actions: [MLSUI.ShowOverlayAction]) {
        DispatchQueue.global(qos: .background).async { [weak self] in
            guard let self = self else { return }
            for action in actions {
                // TODO: Find out if this is reading from network cache layer.
                self.getSVGUseCase.execute(url: action.overlay.svgURL) { [weak self] (baseSVG, _) in
                    guard let self = self else { return }

                    if let baseSVG = baseSVG {
                        for variableName in action.variables {
                            self.tovStore?.addObserver(tovName: variableName, callbackId: action.overlayId, callback: { [weak self] val in
                                // Re-render the entire SVG (including replacing all tokens with their resolved values)
                                self?.svgParseAndRender(action: action, baseSVG: baseSVG)
                            })
                        }
                        // Do an initial rendering as well
                        self.svgParseAndRender(action: action, baseSVG: baseSVG)
                    }
                }
            }
        }
    }
    
    private func hideOverlays(with actions: [MLSUI.HideOverlayAction]) {
        for action in actions {
            if let v = self.overlays[action.overlayId] {
                self.delegate?.view.removeOverlay(containerView: v, animateType: action.animateType, animateDuration: action.animateDuration) { [weak self] in
                    self?.overlays[action.overlayId] = nil
                    self?.tovStore?.removeObservers(callbackId: action.overlayId)
                }
            }
        }
    }
}
