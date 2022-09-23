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
        guard let packages = try? await paymentRepository.listPackages(eventId: eventId).packages else {
            throw StoreException.fetchPackagesListException
        }
        
        return try await Product
            .products(for: packages.map { $0.appleProductId })
            .map { product in
                (packages.filter { $0.appleProductId == product.id }.first?.id, product.toDomain)
            }
            .filter { $0.0 != nil }
            .map { (packageId: $0.0!, product: $0.1) }
    }
}
