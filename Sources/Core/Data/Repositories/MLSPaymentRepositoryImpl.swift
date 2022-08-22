//
// Copyright © 2022 mycujoo. All rights reserved.
//

import Foundation
import Moya


class MLSPaymentRepositoryImpl: MLSPaymentRepository {
    
    private let listProductIdsUseCase: ListProductIdsUseCase
    private let createOrderUseCase: CreatePurchaseOrderUseCase
    private let finishTransactionUseCase: FinishTransactionUseCase
    
    init(listProdictIdsUseCase: ListProductIdsUseCase,
         createOrderUseCase: CreatePurchaseOrderUseCase,
         finishTransactionUseCase: FinishTransactionUseCase) {
        self.listProductIdsUseCase = listProdictIdsUseCase
        self.createOrderUseCase = createOrderUseCase
        self.finishTransactionUseCase = finishTransactionUseCase
    }
    
    @available(iOS 13.0.0, *)
    func listProductIds(eventId: String) async throws -> [String] {
        return try await listProductIdsUseCase.execute(eventId: eventId)
    }
    @available(iOS 13.0.0, *)
    func createOrder(packageId: String) async throws -> Order {
        return try await createOrderUseCase.execute(packageId: packageId)
    }
    @available(iOS 13.0.0, *)
    func finishTransaction(jwsToken: String, orderId: String) async throws -> PaymentVerification {
        return try await finishTransactionUseCase.execute(jwsToken: jwsToken, orderId: orderId)
    }
}

