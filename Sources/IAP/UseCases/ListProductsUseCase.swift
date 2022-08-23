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
        
        guard let productsList = try? await paymentRepository.listProducts(eventId: eventId) else {
            throw StoreException.fetchProductIdsListException
        }
        
        
        guard let products = try? await Product.products(for: [productsList.appleProductId]) else {
            return []
        }
        
        return products.map { $0.toDomain }
    }
}
