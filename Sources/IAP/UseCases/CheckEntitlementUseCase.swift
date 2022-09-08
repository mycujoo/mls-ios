//
// Copyright © 2022 mycujoo. All rights reserved.
//

import Foundation
import MLSSDK
import Combine


@available(iOS 13.0, *)
class CheckEntitlementUseCase {
    private let paymentRepository: MLSPaymentRepository
    
    init(paymentRepository: MLSPaymentRepository) {
        self.paymentRepository = paymentRepository
    }
    
    func execute(order: Order) async -> Result<Bool, Error> {
        do {
            let result =  try await paymentRepository.checkEntitlement(order: order)
            if result {
                return .success(result)
            } else {
                return .failure(StoreError.purchaseNotFulfilled)
            }
        } catch {
            return .failure(error)
        }
        
    }
    
}

