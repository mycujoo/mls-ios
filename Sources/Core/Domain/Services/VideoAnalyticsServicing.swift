//
// Copyright © 2020 mycujoo. All rights reserved.
//

import Foundation
import AVFoundation


protocol VideoAnalyticsServicing: AnyObject {
    /// Call this when creating the AVPlayer.
    func create(with player: MLSPlayerProtocol)

    /// Call this when destroying the video player.
    func stop()
    
    /// The account code to use for video analytics. If not provided, this will rely on the default (Youbora) account code.
    var analyticsAccount: String? { get set }
    
    /// The current user id in your system. Can be any string.
    var userId: String? { get set }

    var currentItemTitle: String? { get set }
    var currentItemEventId: String? { get set }
    var currentItemStreamId: String? { get set }
    var currentItemStreamURL: URL? { get set }
    var currentItemIsLive: Bool? { get set }
    /// Indicates whether the resource that is being played exists as an object on MLS (or whether it is a custom resource outside of the platform).
    var isNativeMLS: Bool? { get set }
    
    var customData: VideoAnalyticsCustomData? { get set }
}
