//
// Copyright © 2021 mycujoo. All rights reserved.
//

import Foundation
import MLSSDK



class AnnotationIntegrationImpl: NSObject, AnnotationIntegration {
    // MARK: Protocol conformance
    var localAnnotationActions: [AnnotationAction] = []
    
    // MARK: Internal
    weak var delegate: AnnotationIntegrationDelegate?
    
    private let hlsInspectionService: HLSInspectionServicing
    
    private var annotationActions: [AnnotationAction] = []
    
    init(
        hlsInspectionService: HLSInspectionServicing,
        delegate: AnnotationIntegrationDelegate) {
        self.hlsInspectionService = hlsInspectionService
        self.delegate = delegate
    }
    
    /// This should be called whenever the annotations associated with this videoPlayer should be re-evaluated.
    private func evaluateAnnotations() {
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
    }
    
}
