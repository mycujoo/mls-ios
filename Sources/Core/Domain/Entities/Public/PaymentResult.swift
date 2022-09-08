//
// Copyright © 2022 mycujoo. All rights reserved.
//

import Foundation

public enum StoreError: Error {
    case failedVerification
    case userCancelled
    case unknownError
    case productError
    case orderError
}

public enum PaymentResult {
    case success
    case failure(StoreError)
    case pending
}
