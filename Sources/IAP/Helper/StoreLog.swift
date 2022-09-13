//
// Copyright © 2022 mycujoo. All rights reserved.
//

import Foundation
import MLSSDK
import os.log



public typealias ProductId = String

@available(iOS 15.0, *)
public struct StoreLog {
    private static let storeLog = OSLog(subsystem: Bundle.main.bundleIdentifier!, category: "STORE")
    
    /// Logs a StoreNotification. Note that the text (shortDescription) of the log entry will be
    /// publically available in the Console app.
    /// - Parameter event: A StoreNotification.
    public static func event(_ event: StoreNotification) {
        #if DEBUG
        print(event.shortDescription())
        #else
        os_log("%{public}s", log: storeLog, type: .default, event.shortDescription())
        #endif
    }
    
    /// Logs an StoreNotification. Note that the text (shortDescription) and the productId for the
    /// log entry will be publically available in the Console app.
    /// - Parameters:
    ///   - event:      A StoreNotification.
    ///   - productId:  A ProductId associated with the event.
    public static func event(_ event: StoreNotification, productId: ProductId) {
        #if DEBUG
        print("\(event.shortDescription()) for product \(productId)")
        #else
        os_log("%{public}s for product %{public}s", log: storeLog, type: .default, event.shortDescription(), productId)
        #endif
    }
    
    
    public static var transactionLog: Set<TransactionLog> = []
    
    /// Logs a StoreNotification as a transaction. Multiple transactions for the same event and product id will only be logged once.
    /// Note that the text (shortDescription) and the productId for the log entry will be publically available in the Console app.
    /// - Parameters:
    ///   - event:      A StoreNotification.
    ///   - productId:  A ProductId associated with the event.
    public static func transaction(_ event: StoreNotification, productId: ProductId) {
        
        let t = TransactionLog(notification: event, productId: productId)
        if transactionLog.contains(t) { return }
        transactionLog.insert(t)
        
        #if DEBUG
        print("\(event.shortDescription()) for product \(productId)")
        #else
        os_log("%{public}s for product %{public}s", log: storeLog, type: .default, event.shortDescription(), productId)
        #endif
    }
    
    /// Logs a StoreException. Note that the text (shortDescription) and the productId for the
    /// log entry will be publically available in the Console app.
    /// - Parameters:
    ///   - exception:  A StoreException.
    ///   - productId:  A ProductId associated with the event.
    public static func exception(_ exception: StoreException, productId: ProductId) {
        #if DEBUG
        print("\(exception.shortDescription()). For product \(productId)")
        #else
        os_log("%{public}s for product %{public}s", log: storeLog, type: .default, exception.shortDescription(), productId)
        #endif
    }
    
    /// Logs a message.
    /// - Parameter message: The message to log.
    public static func event(_ message: String) {
        #if DEBUG
        print(message)
        #else
        os_log("%s", log: storeLog, type: .info, message)
        #endif
    }
}

public struct TransactionLog: Hashable {
    
    let notification: StoreNotification
    let productId: ProductId
    
    public static func == (lhs: TransactionLog, rhs: TransactionLog) -> Bool {
        return (lhs.productId == rhs.productId) && (lhs.notification == rhs.notification)
    }
}

