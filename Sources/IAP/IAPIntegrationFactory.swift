//
// Copyright © 2022 mycujoo. All rights reserved.
//

import Foundation
import MLSSDK


public class IAPIntegrationFactory:
    IntegrationFactoryProtocol {
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
            paymentRepository: MLSPaymentRepository) {
            self.timelineRepository = timelineRepository
            self.eventRepository = eventRepository
            self.playerConfigRepository = playerConfigRepository
            self.arbitraryDataRepository = arbitraryDataRepository
            self.drmRepository = drmRepository
            self.paymentRepository = paymentRepository
        }
        
        public func build() -> IAPIntegration {
            return IAPIntegratoinImpl(paymentRepository: paymentRepository)
        }
    }
