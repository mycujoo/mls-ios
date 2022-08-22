//
// Copyright © 2022 mycujoo. All rights reserved.
//

import Foundation
import MLSSDK

class CreateOrderUseCase {
    private let paymentRepository: MLSPaymentRepository
    
    init(paymentRepository: MLSPaymentRepository) {
        self.paymentRepository = paymentRepository
    }
    
    @available(iOS 13.0.0, *)
    func execute(_ productId: String) async throws -> Order {
        guard let order = try? await paymentRepository.createOrder(packageId: productId) else {
            throw StoreException.orderException
        }
        
        return order
    }
}
