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
    
    public static func build(delegate: AnnotationIntegrationDelegate) -> AnnotationIntegration {
        return AnnotationIntegrationImpl(
            annotationService: annotationService,
            hlsInspectionService: hlsInspectionService,
            delegate: delegate)
    }
}
