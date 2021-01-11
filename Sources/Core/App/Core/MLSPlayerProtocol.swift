//
// Copyright © 2020 mycujoo. All rights reserved.
//

import Foundation
import AVFoundation


/// This protocol contains all the methods and properties that VideoPlayer access on the MLSPlayer object.
/// It exists with the distinct purpose of being able to mock the MLSPlayer in the VideoPlayer for easy testability.
protocol MLSPlayerProtocol: PlayerProtocol {
    /// The current item that is playing.
    var currentItem: AVPlayerItem? { get }

    // MARK: AVPlayer properties
    var status: AVPlayer.Status { get }

    /// Contains the raw HLS playlist that defines the segments. Is updated in sync with the AVPlayer.
    var rawSegmentPlaylist: String? { get }

    /// Replace a current item with another AVPlayerItem that is asynchronously built from a URL.
    /// - parameter item: The item to play. If nil is provided, the current item is removed.
    /// - parameter headers: The headers to attach to the network requests when playing this item.
    /// - parameter resourceLoaderDelegate: The delegate for the asset's resourceLoader.
    /// - parameter callback: A callback that is called when the replacement is completed (true) or failed/cancelled (false).
    func replaceCurrentItem(with assetUrl: URL?, headers: [String: String], resourceLoaderDelegate: AVAssetResourceLoaderDelegate?, callback: @escaping (Bool) -> ())

    var allowsExternalPlayback: Bool { get set }
    var isExternalPlaybackActive: Bool { get }
    var usesExternalPlaybackWhileExternalScreenIsActive: Bool { get set }
}
