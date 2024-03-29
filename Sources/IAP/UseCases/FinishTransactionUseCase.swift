//
// Copyright © 2022 mycujoo. All rights reserved.
//

import Foundation
import StoreKit
import MLSSDK

@available(iOS 15.0.0, *)
class FinishTransactionUseCase {
    
    private let paymentRepository: MLSPaymentRepository
    
    init(paymentRepository: MLSPaymentRepository) {
        self.paymentRepository = paymentRepository
    }
    
    func execute(_ jwsToken: String) async throws -> Void {
        try await paymentRepository.finishTransaction(jwsToken: jwsToken)
    }
}
