//
// Copyright © 2022 mycujoo. All rights reserved.
//

import Foundation
import MLSSDK


@available(iOS 15.0, *)
public class IAPIntegrationFactory:
    IntegrationFactoryProtocol {
        private var timelineRepository: MLSTimelineRepository!
        private var eventRepository: MLSEventRepository!
        private var playerConfigRepository: MLSPlayerConfigRepository!
        private var arbitraryDataRepository: MLSArbitraryDataRepository!
        private var drmRepository: MLSDRMRepository!
        private var paymentRepository: MLSPaymentRepository!
        private var logLevel: Configuration.LogLevel!
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
            self.logLevel = logLevel
        }
        
    public func build() -> IAPIntegration {
            let listProductsUseCase = ListProductsUseCase(paymentRepository: paymentRepository)
            let createOrderUseCase = CreateOrderUseCase(paymentRepository: paymentRepository)
            let finishTransactionUseCase = FinishTransactionUseCase(paymentRepository: paymentRepository)
            let checkEntitlementUseCase = CheckEntitlementUseCase(paymentRepository: paymentRepository)
            return IAPIntegrationImpl(
                listProductsUseCase: listProductsUseCase,
                createOrderUseCase: createOrderUseCase,
                finishTransactionUseCase: finishTransactionUseCase,
                checkEntitlementUseCase: checkEntitlementUseCase,
                logLevel: logLevel)
        }
    }

