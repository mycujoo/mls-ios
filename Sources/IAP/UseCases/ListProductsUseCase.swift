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
    
    func execute(eventId: String) async throws -> [(packageId: String, product: IAPProduct)] {
        
        guard let packagesList = try? await paymentRepository.listProducts(eventId: eventId) else {
            throw StoreException.fetchProductIdsListException
        }
        
        let iapProductsList = try await Product.products(for: packagesList.packages.map { $0.appleProductId })
        
        guard iapProductsList.count > 0 else {
            return []
        }
        var result: [(String, IAPProduct)] = []
        for list in iapProductsList {
            result.append((packagesList.packages.filter { $0.appleProductId == list.id }.first!.id, list.toDomain))
        }
        return result
    }
}
