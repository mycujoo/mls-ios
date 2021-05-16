//
// Copyright © 2020 mycujoo. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation


public protocol VideoPlayer: AnyObject {
    var delegate: VideoPlayerDelegate? { get set }
    
    /// Should be set by the SDK user for IMA ads to work. Such an object can be obtained through the `MLSSDK/IMA` extensions.
    var imaIntegration: IMAIntegration? { get set }
    
    /// Should be set by the SDK user for IMA ads to work. Such an object can be obtained through the `MLSSDK/Annotations` extensions.
    var annotationIntegration: AnnotationIntegration? { get set }

    #if os(iOS)
    /// Should be set by the SDK user for Google Chromecast support to work. Such an object can be obtained through the `MLSSDK/Cast` extensions.
    var castIntegration: CastIntegration? { get set }
    #endif

    /// Setting an Event will automatically switch the player over to the primary stream that is associated with this Event, if one is available.
    /// - note: This sets `stream` to nil.
    var event: Event? { get set }

    /// Setting a Stream will automatically switch the player over to this stream.
    /// - note: This sets `event` to nil.
    var stream: Stream? { get set }

    /// Indicates whether the Player is ready to play or not.
    var state: PlayerState { get }

    /// The current status of the player, based on the current item.
    var status: PlayerStatus { get }

    /// The view of the VideoPlayer.
    /// This is only available if the VideoPlayer's view is attached during initialization.
    var playerView: (UIView & AnnotationIntegrationView)? { get }

    /// Setting the playerConfig will automatically updates the associated views and behavior.
    var playerConfig: PlayerConfig! { get set }

    #if os(iOS)
    /// This property changes when the fullscreen button is tapped. SDK implementors can update this state directly, which will update the visual of the button.
    /// Any value change will call the delegate's `playerDidUpdateFullscreen` method.
    var isFullscreen: Bool { get set }
    #endif

    /// Get or set the `isMuted` property of the underlying AVPlayer.
    var isMuted: Bool { get set }

    /// - returns: The current time (in milliseconds) of the currentItem.
    var currentTime: Double { get }
    /// - returns: The current time (in milliseconds) that is expected after all pending seek operations are done on the currentItem.
    var optimisticCurrentTime: Double { get }
    /// - returns: The duration (in milliseconds) of the currentItem. If unknown, returns 0.
    var currentDuration: Double { get }
    /// The view in which all player controls are rendered. SDK implementers can add more controls to this view, if desired.
    var controlView: UIView? { get }
    
    /// The associated AVPlayer.
    var avPlayer: AVPlayer { get }
    /// The AVPlayerLayer of the associated AVPlayer. This is only available if the VideoPlayer's view is attached.
    var playerLayer: AVPlayerLayer? { get }

    #if os(iOS)
    /// A horizontal UIStackView at the top-leading corner. Can be used to add more custom UIButtons to (e.g. PiP).
    /// This is only available if the VideoPlayer's view is attached.
    var topLeadingControlsStackView: UIStackView? { get }
    /// A horizontal UIStackView at the top-trailing corner. Can be used to add more custom UIButtons to (e.g. PiP).
    /// This is only available if the VideoPlayer's view is attached.
    var topTrailingControlsStackView: UIStackView? { get }
    /// The UITapGestureRecognizer that is listening to taps on the VideoPlayer's view.
    /// This is only available if the VideoPlayer's view is attached.
    var tapGestureRecognizer: UITapGestureRecognizer? { get }
    #endif

    /// Start or continue playback of the loaded stream.
    func play()

    /// Pause playback of the loaded stream.
    func pause()
    
    /// The playback rate of the current item.
    var rate: Float { get set }

    /// Seek to a position within the currentItem.
    /// - parameter to: The number of seconds within the currentItem to seek to.
    /// - parameter completionHandler: A closure that is called upon a completed seek operation.
    /// - note: The seek tolerance can be configured through the `playerConfig` property on this `VideoPlayer` and is used for all seek operations by this player.
    func seek(to: Double, completionHandler: @escaping (Bool) -> Void)

    /// Programmatically show the information overlay. This request may be denied in certain cases.
    func showEventInfoOverlay()

    /// Programmatically hide the information overlay. This request may be denied in certain cases.
    func hideEventInfoOverlay()

    /// Programmatically show the control layer. This request may be denied in certain cases.
    func showControlLayer()

    /// Programmatically hide the control layer. This request may be denied in certain cases.
    func hideControlLayer()
}

// MARK: - Delegate
public protocol VideoPlayerDelegate: AnyObject {
    /// The player has updated its playing status. To access the current status, see `VideoPlayer.status`
    func playerDidUpdatePlaying(player: VideoPlayer)
    /// The player has updated the elapsed time of the player. To access the current time, see `VideoPlayer.currentTime`
    func playerDidUpdateTime(player: VideoPlayer)
    /// The player has updated its state. To access the current state, see `VideoPlayer.state`
    func playerDidUpdateState(player: VideoPlayer)
    /// The player has updated the visibility of the control layer.
    /// - parameter toVisible: The new visibility state of the control layer.
    /// - parameter withAnimationDuration: The duration of the animation to hide/show the control layer
    func playerDidUpdateControlVisibility(toVisible: Bool, withAnimationDuration: Double, player: VideoPlayer)
    /// The player has updated the stream object it is currently playing. This may be called repeatedly, whenever one of its properties changes.
    /// - parameter stream: The new Stream object, or nil if the stream was removed.
    func playerDidUpdateStream(stream: MLSSDK.Stream?, player: VideoPlayer)
    #if os(iOS)
    /// Gets called when the user enters or exits full-screen mode. There is no associated behavior with this other than the button-image changing;
    /// SDK implementers are responsible for any other visual or behavioral changes on the player.
    /// To manually override this state, set the desired value on `VideoPlayer.isFullscreen` (which will call the delegate again!)
    /// This button can be hidden via the Configuration object on the MLS component.
    /// - note: This is only called when there is a view attached to the VideoPlayer.
    func playerDidUpdateFullscreen(player: VideoPlayer)
    #endif
}
