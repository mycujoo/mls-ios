//
// Copyright © 2020 mycujoo. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation


public protocol VideoPlayer: class {
    var delegate: PlayerDelegate? { get set }
    var state: VideoPlayerState { get }

    /// Setting an Event will automatically switch the player over to the primary stream that is associated with this Event, if one is available.
    /// - note: This sets `stream` to nil.
    var event: Event? { get set }

    /// Setting a Stream will automatically switch the player over to this stream.
    /// - note: This sets `event` to nil.
    var stream: Stream? { get set }

    /// The current status of the player, based on the current item.
    var status: VideoPlayerStatus { get }

    /// The view of the VideoPlayer.
    var playerView: UIView { get }

    #if os(iOS)
    /// This property changes when the fullscreen button is tapped. SDK implementors can update this state directly, which will update the visual of the button.
    /// Any value change will call the delegate's `playerDidUpdateFullscreen` method.
    var isFullscreen: Bool { get set }
    #endif

    /// Get or set the `isMuted` property of the underlying AVPlayer.
    var isMuted: Bool { get set }

    /// Indicates whether the current item is a live stream.
    var isLivestream: Bool { get }
    /// - returns: The current time (in seconds) of the currentItem.
    var currentTime: Double { get }
    /// - returns: The current time (in seconds) that is expected after all pending seek operations are done on the currentItem.
    var optimisticCurrentTime: Double { get }
    /// - returns: The duration (in seconds) of the currentItem. If unknown, returns 0.
    var currentDuration: Double { get }
    /// The view in which all player controls are rendered. SDK implementers can add more controls to this view, if desired.
    var controlView: UIView { get }
    /// The AVPlayerLayer of the associated AVPlayer
    var playerLayer: AVPlayerLayer? { get }

    #if os(iOS)
    /// A horizontal UIStackView at the top-leading corner. Can be used to add more custom UIButtons to (e.g. PiP).
    var topLeadingControlsStackView: UIStackView { get }
    /// A horizontal UIStackView at the top-trailing corner. Can be used to add more custom UIButtons to (e.g. PiP).
    var topTrailingControlsStackView: UIStackView { get }
    /// The UITapGestureRecognizer that is listening to taps on the VideoPlayer's view.
    var tapGestureRecognizer: UITapGestureRecognizer { get }
    #endif

    /// Seek to a position within the currentItem.
    /// - parameter to: The number of seconds within the currentItem to seek to.
    /// - parameter completionHandler: A closure that is called upon a completed seek operation.
    /// - note: The seek tolerance can be configured through the `playerConfig` property on this `VideoPlayer` and is used for all seek operations by this player.
    func seek(to: Double, completionHandler: @escaping (Bool) -> Void)

    func showEventInfoOverlay()

    func hideEventInfoOverlay()
}

// MARK: - State
public enum VideoPlayerState: Int {
    /// Indicates that the status of the player is not yet known because it has not tried to load new media resources for playback.
    case unknown = 0
    /// Indicates that the player is ready to play AVPlayerItem instances.
    case readyToPlay = 1
    /// Indicates that the player can no longer play AVPlayerItem instances because of an error. The error is described by the value of the player's error property.
    case failed = 2
    /// The player has finished playing the media
    case ended = 3
}

public enum VideoPlayerStatus {

    case play
    case pause

    public mutating func toggle() {
        switch self {
        case .play:
            self = .pause
        case .pause:
            self = .play
        }
    }
    public var isPlaying: Bool { self == .play }
}


// MARK: - Delegate
public protocol PlayerDelegate: AnyObject {
    /// The player has updated its playing status. To access the current status, see `VideoPlayer.status`
    func playerDidUpdatePlaying(player: VideoPlayer)
    /// The player has updated the elapsed time of the player. To access the current time, see `VideoPlayer.currentTime`
    func playerDidUpdateTime(player: VideoPlayer)
    /// The player has updated its state. To access the current state, see `VideoPlayer.state`
    func playerDidUpdateState(player: VideoPlayer)
    #if os(iOS)
    /// Gets called when the user enters or exits full-screen mode. There is no associated behavior with this other than the button-image changing;
    /// SDK implementers are responsible for any other visual or behavioral changes on the player.
    /// To manually override this state, set the desired value on `VideoPlayer.isFullscreen` (which will call the delegate again!)
    /// This button can be hidden via the Configuration object on the MLS component.
    func playerDidUpdateFullscreen(player: VideoPlayer)
    #endif
}
