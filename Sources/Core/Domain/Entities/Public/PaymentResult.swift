//
// Copyright © 2022 mycujoo. All rights reserved.
//

import Foundation

public enum StoreError: Error {
    case failedVerification
}

public enum PaymentResult {
    case success
    case failure
    case pending
}
