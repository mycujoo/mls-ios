//
// Copyright © 2021 mycujoo. All rights reserved.
//

import Foundation
import UIKit
import MLSSDK



class AnnotationIntegrationImpl: NSObject, AnnotationIntegration {
    // MARK: Protocol conformance
    var localAnnotationActions: [AnnotationAction] = []
    
    // MARK: Internal
    weak var delegate: AnnotationIntegrationDelegate?
    
    private let annotationService: AnnotationServicing
    private let hlsInspectionService: HLSInspectionServicing
    
    private var annotationActions: [AnnotationAction] = []
    
    private var tovStore: TOVStore? = nil
    private var activeOverlayIds: Set<String> = Set()
    
    /// A dictionary of dynamic overlays currently showing within this view. Keys are the overlay identifiers.
    /// The UIView should be the outer container of the overlay, not the SVGView directly.
    private var overlays: [String: UIView] = [:]
    
    init(
        annotationService: AnnotationServicing,
        hlsInspectionService: HLSInspectionServicing,
        delegate: AnnotationIntegrationDelegate) {
        self.annotationService = annotationService
        self.hlsInspectionService = hlsInspectionService
        self.delegate = delegate
    }
    
    func evaluate() {
        guard let delegate = delegate else { return }
        
        let allAnnotationActions = annotationActions + localAnnotationActions
        
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
//                if output.showOverlays.count > 0 {
//                    self?.showOverlays(with: output.showOverlays)
//                }
//                if output.hideOverlays.count > 0 {
//                    self?.hideOverlays(with: output.hideOverlays)
//                }
            }
        }
    }
    
}
