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
}
