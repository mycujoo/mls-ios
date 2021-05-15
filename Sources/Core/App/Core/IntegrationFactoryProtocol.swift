//
// Copyright © 2021 mycujoo. All rights reserved.
//

import Foundation


/// The protocol that should be implemented by all builders of integrations (modules) of this SDK, e.g. IMAIntegration or AnnotationIntegration.
public protocol IntegrationFactoryProtocol {
    func inject(
        timelineRepository: MLSTimelineRepository,
        eventRepository: MLSEventRepository,
        playerConfigRepository: MLSPlayerConfigRepository,
        arbitraryDataRepository: MLSArbitraryDataRepository,
        drmRepository: MLSDRMRepository)
}
