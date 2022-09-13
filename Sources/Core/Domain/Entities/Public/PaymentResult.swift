//
// Copyright © 2022 mycujoo. All rights reserved.
//

import Foundation

public enum StoreException: Error, Equatable {
    case fetchPackagesListException
    case orderException
    case requestProductException
    case purchaseException
    case purchaseInProgressException
    case finishTransactionException
    case finishPurchaseException
    case transactionVerificationFailed
    case missingAppAccountToken
    case unhandledEventException
    case userCancelled
}

public enum PaymentResult {
    case success
    case failure(StoreException)
    case pending
}
