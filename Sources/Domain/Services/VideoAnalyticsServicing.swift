//
// Copyright © 2020 mycujoo. All rights reserved.
//

import Foundation
import AVFoundation


protocol VideoAnalyticsServicing: class {
    /// Call this when creating the AVPlayer.
    func create(with player: MLSAVPlayerProtocol)

    /// Call this when destroying the video player.
    func stop()

    var currentItemTitle: String? { get set }
    var currentItemEventId: String? { get set }
    var currentItemStreamId: String? { get set }
    var currentItemStreamURL: URL? { get set }
    var currentItemIsLive: Bool? { get set }
    /// Indicates whether the resource that is being played exists as an object on MLS (or whether it is a custom resource outside of the platform).
    var isNativeMLS: Bool? { get set }
}
