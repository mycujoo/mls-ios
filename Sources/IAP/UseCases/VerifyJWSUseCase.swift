//
// Copyright © 2022 mycujoo. All rights reserved.
//

import Foundation
import StoreKit
import MLSSDK

@available(iOS 15.0.0, *)
class VerifyJWSUseCase {
    
    private let paymentRepository: MLSPaymentRepository
    
    init(paymentRepository: MLSPaymentRepository) {
        self.paymentRepository = paymentRepository
    }
    
    func execute(_ verification: VerificationResult<Transaction>, orderId: String) async throws -> Bool {
        
        guard let jwsVerification = try? await paymentRepository.finishTransaction(jwsToken: verification.jwsRepresentation, orderId: orderId), jwsVerification.id.isEmpty else {
            
            throw StoreException.jwsVerificationException
        }
        
        return true
    }
}
