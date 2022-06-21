//
// Copyright © 2022 mycujoo. All rights reserved.
//

import Foundation



public protocol IAPIntegration: AnyObject {

    
    @available(iOS 15.0, *)
    func listProducts(_ eventId: String, completion: @escaping ([IAPProduct], Error?) -> Void)

    @available(iOS 15.0, *)
    func purchaseProduct(_ product: IAPProduct, completion: @escaping (PaymentResult?, Error?) -> Void)
}
