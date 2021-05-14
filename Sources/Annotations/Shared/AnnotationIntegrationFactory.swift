//
// Copyright © 2021 mycujoo. All rights reserved.
//

import Foundation
import MLSSDK


public class AnnotationIntegrationFactory {
    private static var annotationService: AnnotationServicing = {
        return AnnotationService()
    }()
    private static var hlsInspectionService: HLSInspectionServicing = {
        return HLSInspectionService()
    }()
    
    public static func build(
        timelineRepository: MLSTimelineRepository,
        arbitraryDataRepository: MLSArbitraryDataRepository,
        delegate: AnnotationIntegrationDelegate) -> AnnotationIntegration {
        let getTimelineActionsUpdatesUseCase = GetTimelineActionsUpdatesUseCase(timelineRepository: timelineRepository)
        let getSVGUseCase = GetSVGUseCase(arbitraryDataRepository: arbitraryDataRepository)
        
        return AnnotationIntegrationImpl(
            annotationService: annotationService,
            hlsInspectionService: hlsInspectionService,
            getTimelineActionsUpdatesUseCase: getTimelineActionsUpdatesUseCase,
            getSVGUseCase: getSVGUseCase,
            delegate: delegate)
    }
}
