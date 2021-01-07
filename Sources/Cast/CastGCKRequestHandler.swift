//
// Copyright © 2021 mycujoo. All rights reserved.
//

import Foundation
import GoogleCast


/// A wrapper to make GCRequest handling easier.
/// - important: Internally, this handler ensures that there is always a strong reference to itself as long as the request is busy.
class CastGCKRequestHandler: NSObject, GCKRequestDelegate {
    /// An array of strong references to `CastGCKRequestHandler` objects.
    static private var delegates = [CastGCKRequestHandler]()

    static private func start(_ handler: CastGCKRequestHandler) {
        CastGCKRequestHandler.delegates.append(handler)
    }

    static private func stop(_ handler: CastGCKRequestHandler) {
        CastGCKRequestHandler.delegates = CastGCKRequestHandler.delegates.filter { !($0 === handler) }
    }

    private var defaultHandler: (() -> Void)?
    private var completionHandler: (() -> Void)?
    private var failureHandler: (() -> Void)?
    private var abortionHandler: (() -> Void)?

    /// - parameter defaultHandler: Always gets called, regardless of completion, failure or abortion.
    /// - parameter completionHandler: Is called when the request completes.
    /// - parameter failureHandler: Is called when the request fails.
    /// - parameter abortionHandler: Is called when the request aborts.
    convenience init(defaultHandler: (() -> Void)? = nil,
                     completionHandler: (() -> Void)? = nil,
                     failureHandler: (() -> Void)? = nil,
                     abortionHandler: (() -> Void)? = nil) {
        self.init()

        self.defaultHandler = defaultHandler
        self.completionHandler = completionHandler
        self.failureHandler = failureHandler
        self.abortionHandler = abortionHandler

        CastGCKRequestHandler.start(self)
    }

    func requestDidComplete(_ request: GCKRequest) {
        defaultHandler?()
        completionHandler?()
        CastGCKRequestHandler.stop(self)
    }
    func request(_ request: GCKRequest, didFailWithError error: GCKError) {
        defaultHandler?()
        failureHandler?()
        CastGCKRequestHandler.stop(self)
    }
    func request(_ request: GCKRequest, didAbortWith abortReason: GCKRequestAbortReason) {
        defaultHandler?()
        abortionHandler?()
        CastGCKRequestHandler.stop(self)
    }

}
