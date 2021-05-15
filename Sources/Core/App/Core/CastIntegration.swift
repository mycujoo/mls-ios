//
// Copyright © 2021 mycujoo. All rights reserved.
//

import Foundation


public protocol CastIntegration: AnyObject {
    func initialize(_ videoPlayerDelegate: CastIntegrationVideoPlayerDelegate)

    /// Indicates whether this CastIntegration is connected and the device playing through Chromecast.
    func isCasting() -> Bool

    /// - returns: A player object. Should only be used while `isCasting()` is true.
    func player() -> CastPlayerProtocol
}

public protocol CastIntegrationVideoPlayerDelegate: AnyObject {
    /// Indicates that the `isCasting` state on the `CastIntegration` has updated to a different value.
    func isCastingStateUpdated()
}

public protocol CastPlayerProtocol: PlayerProtocol {
    func replaceCurrentItem(publicKey: String, pseudoUserId: String, event: MLSSDK.Event?, stream: MLSSDK.Stream?, completionHandler: @escaping (Bool) -> Void)
}
