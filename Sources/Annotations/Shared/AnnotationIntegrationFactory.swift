//
// Copyright © 2021 mycujoo. All rights reserved.
//

import Foundation
import MLSSDK


public class AnnotationIntegrationFactory: IntegrationFactoryProtocol {
    private var timelineRepository: MLSTimelineRepository!
    private var eventRepository: MLSEventRepository!
    private var playerConfigRepository: MLSPlayerConfigRepository!
    private var arbitraryDataRepository: MLSArbitraryDataRepository!
    private var drmRepository: MLSDRMRepository!
    private var paymentRepository: MLSPaymentRepository!
    
    public init() {}
    
    /// Should not be called directly, but via the `MLS`'s `prepare` method.
    public func inject(
        timelineRepository: MLSTimelineRepository,
        eventRepository: MLSEventRepository,
        playerConfigRepository: MLSPlayerConfigRepository,
        arbitraryDataRepository: MLSArbitraryDataRepository,
        drmRepository: MLSDRMRepository,
        paymentRepository: MLSPaymentRepository,
        logLevel: Configuration.LogLevel) {
        self.timelineRepository = timelineRepository
        self.eventRepository = eventRepository
        self.playerConfigRepository = playerConfigRepository
        self.arbitraryDataRepository = arbitraryDataRepository
        self.drmRepository = drmRepository
        self.paymentRepository = paymentRepository
    }
    
    private lazy var annotationService: AnnotationServicing = {
        return AnnotationService()
    }()
    private lazy var hlsInspectionService: HLSInspectionServicing = {
        return HLSInspectionService()
    }()
    
    public func build(
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
