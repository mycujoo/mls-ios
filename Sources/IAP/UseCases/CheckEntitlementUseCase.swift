//
// Copyright © 2022 mycujoo. All rights reserved.
//

import Foundation
import MLSSDK
import Combine


@available(iOS 13.0, *)
class CheckEntitlementUseCase {
    public enum UseCaseError: Error {
        case missingEntitlement
    }
    
    private let paymentRepository: MLSPaymentRepository
    
    init(paymentRepository: MLSPaymentRepository) {
        self.paymentRepository = paymentRepository
    }
    
    func execute(contentType: String, contentId: String) async -> Result<Bool, Error> {
        do {
            let result =  try await paymentRepository.checkEntitlement(contentType: contentType, contentId: contentId)
            if result {
                return .success(result)
            } else {
                return .failure(UseCaseError.missingEntitlement)
            }
        } catch {
            return .failure(error)
        }
        
    }
    
}

