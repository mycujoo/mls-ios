//
// Copyright © 2022 mycujoo. All rights reserved.
//

import Foundation
import MLSSDK
/// StoreHelper exceptions
extension StoreException {
    
    public func shortDescription() -> String {
        switch self {
            case .fetchPackagesListException:           return "Exception. Fetching packages failed"
            case .orderException:                       return "Exception. Creating order failed"
            case .requestProductException:              return "Exception. Storekit threw an exception while requesting for a product"
            case .purchaseException:                    return "Exception. StoreKit threw an exception while processing a purchase"
            case .purchaseInProgressException:          return "Exception. You can't start another purchase yet, one is already in progress"
            case .finishTransactionException:           return "Exception. jwsRepresentation verification failed"
            case .transactionVerificationFailed:        return "Exception. A transaction failed StoreKit's automatic verification"
            case .missingAppAccountToken:               return "Exception. This transaction does not have an associated appAccountToken"
            case .unhandledEventException:              return "Exception. An unhandled event happened"
            case .userCancelled:                        return "User cancelled the purchase."
            case .finishPurchaseException:              return "Exception. Finishing purchase threw an exception."
        }
    }
}

/// Informational logging notifications issued by StoreHelper
public enum StoreNotification: Error, Equatable {
    case fetchProductIdsListFailed
    
    case orderCreationFailed
    case orderCreationSuccess
    
    case requestProductsStarted
    case requestProductsSuccess
    case requestProductsFailure
    
    case requestProductToPurchaseFailure
    case requestProductToPurchaseSuccess
    
    
    case purchaseInProgress
    case purchaseCancelled
    case purchasePending
    case purchaseSuccess
    case purchaseFailure
    
    case transactionReceived
    case transactionValidationSuccess
    case transactionValidationFailure
    case transactionFailure
    case transactionSuccess
    case transactionRevoked
    case transactionRefundRequested
    case transactionRefundFailed
    
    case jwsVerificationFailed
    case jwsVerificationSuccess
    
    
    /// A short description of the notification.
    /// - Returns: Returns a short description of the notification.
    public func shortDescription() -> String {
        switch self {
            case .fetchProductIdsListFailed:       return "Fetching event packages for Apple productIds failed"
            case .orderCreationFailed:             return "Creating order for productId failed"
            case .orderCreationSuccess:            return "Creating order for productId success"
            
            case .requestProductsStarted:          return "Request products from the App Store started"
            case .requestProductsSuccess:          return "Request products from the App Store success"
            case .requestProductsFailure:          return "Request products from the App Store failure"
                
            case .requestProductToPurchaseFailure: return "Request product from App Store to purchase failed"
            case .requestProductToPurchaseSuccess: return "Request product from App Store to purchase success"
            
            case .purchaseInProgress:              return "Purchase in progress"
            case .purchasePending:                 return "Purchase in progress. Awaiting authorization"
            case .purchaseCancelled:               return "Purchase cancelled"
            case .purchaseSuccess:                 return "Purchase success"
            case .purchaseFailure:                 return "Purchase failure"
                
            case .transactionReceived:             return "Transaction received"
            case .transactionValidationSuccess:    return "Transaction validation success"
            case .transactionValidationFailure:    return "Transaction validation failure"
            case .transactionFailure:              return "Transaction failure"
            case .transactionSuccess:              return "Transaction success"
            case .transactionRevoked:              return "Transaction was revoked (refunded) by the App Store"
            case .transactionRefundRequested:      return "Transaction refund successfully requested"
            case .transactionRefundFailed:         return "Transaction refund request failed"
            
            case .jwsVerificationFailed:           return "JWS representation verification failed"
            case .jwsVerificationSuccess:          return "JWS representation verification success"
                
        }
    }
}
