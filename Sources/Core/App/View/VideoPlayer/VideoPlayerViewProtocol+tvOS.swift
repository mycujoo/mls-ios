//
// Copyright © 2020 mycujoo. All rights reserved.
//
import Foundation
import AVFoundation
import UIKit

#if os(tvOS)
protocol VideoPlayerViewProtocol: class {
    var videoSlider: VideoProgressSlider { get }

    /// The color that is used throughout various controls and elements of the video player, together with the `secondaryColor`.
    var primaryColor: UIColor { get set }
    /// The color that is used throughout various controls and elements of the video player, together with the `primaryColor`.
    var secondaryColor: UIColor { get set }
    /// Whether the controlView has an alpha value of more than zero (0) or not.
    var controlViewHasAlpha: Bool { get }
    /// Whether the infoView has an alpha value of more than zero (0) or not.
    var infoViewHasAlpha: Bool { get }
    /// The view in which all event/stream information is rendered.
    var infoTitleLabel: UILabel { get }
    /// The view in which all event/stream information is rendered.
    var infoDateLabel: UILabel { get }
    /// The view in which all event/stream information is rendered.
    var infoDescriptionLabel: UILabel { get }

    /// The view in which all player controls are rendered. SDK implementers can add more controls to this view, if desired.
    var controlView: UIView { get }
    /// The AVPlayerLayer of the associated AVPlayer
    var playerLayer: AVPlayerLayer? { get }

    func drawPlayer(with player: MLSPlayerProtocol)
    func setOnPlayButtonTapped(_ action: @escaping () -> Void)
    func setOnSkipBackButtonTapped(_ action: @escaping () -> Void)
    func setOnSkipForwardButtonTapped(_ action: @escaping () -> Void)
    func setOnTimeSliderSlide(_ action: @escaping (Double) -> Void)
    func setOnTimeSliderRelease(_ action: @escaping (Double) -> Void)
    /// - note: On tvOS, this method automatically also triggers the infoView to become visible.
    func setControlViewVisibility(visible: Bool, withAnimationDuration: Double)
    func setInfoViewVisibility(visible: Bool, withAnimationDuration: Double)
    func setPlayButtonTo(state: VideoPlayerPlayButtonState)
    func setLiveButtonTo(state: VideoPlayerLiveState)
    /// Shows the number of viewers on the video player. If <= 1 or nil, the element is hidden entirely.
    func setNumberOfViewersTo(amount: String?)

    /// Sets the `isHidden` property of the entire control view, *excluding* the control view's alpha layer.
    func setControlView(hidden: Bool)
    /// Sets the `isHidden` property of the buffer icon.
    /// - note: This hides/shows the play button to the opposite visibility of the buffer icon.
    func setBufferIcon(hidden: Bool)
    /// Sets the `isHidden` property of the `timeIndicatorLabel`.
    /// - seeAlso: `setTimeIndicatorLabel(elapsedText:totalText:)`
    func setTimeIndicatorLabel(hidden: Bool)
    /// Set the time indicator label as an attributed string. If elapsedText is nil, then an empty string is rendered on the entire label.
    /// - seeAlso: `setTimeIndicatorLabel(hidden:)`
    func setTimeIndicatorLabel(elapsedText: String?, totalText: String?)
    /// Set the `isHidden` property of the seekbar.
    func setSeekbar(hidden: Bool)

    func setTimelineMarkers(with actions: [MLSUI.ShowTimelineMarkerAction])
    /// Places the overlay within a containerView, that is then sized, positioned and animated within the overlayContainerView.
    func placeOverlay(
        imageView: UIView,
        size: AnnotationActionShowOverlay.Size,
        position: AnnotationActionShowOverlay.Position,
        animateType: OverlayAnimateinType,
        animateDuration: Double
    ) -> UIView
    /// Places a new imageView within an existing containerView (which was previously generated using `placeOverlay()`
    func replaceOverlay(containerView: UIView, imageView: UIView)
    /// Removes an overlay from the overlayContainerView with the proper animations.
    func removeOverlay(
        containerView: UIView,
        animateType: OverlayAnimateoutType,
        animateDuration: Double,
        completion: @escaping (() -> Void)
    )

    func setOnSelectPressed(_ action: @escaping () -> Void)
    func setOnLeftArrowTapped(_ action: @escaping () -> Void)
    func setOnRightArrowTapped(_ action: @escaping () -> Void)
}
#endif
