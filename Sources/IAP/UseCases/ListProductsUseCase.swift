//
// Copyright © 2022 mycujoo. All rights reserved.
//

import Foundation
import StoreKit
import MLSSDK

@available(iOS 15.0.0, *)
class ListProductsUseCase {
    private let paymentRepository: MLSPaymentRepository
    
    init(paymentRepository: MLSPaymentRepository) {
        self.paymentRepository = paymentRepository
    }
    
    func execute(eventId: String) async throws -> [IAPProduct] {
        
        guard let productIdsList = try? await paymentRepository.listProductIds(eventId: eventId) else {
            throw StoreException.fetchProductIdsListException
        }
        
        
        guard let products = try? await Product.products(for: productIdsList) else {
            return []
        }
        
        return products.map { $0.toDomain }
    }
}
