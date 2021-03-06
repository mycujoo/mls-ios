//
// Copyright © 2020 mycujoo. All rights reserved.
//

import Foundation
import AVFoundation
import UIKit

#if os(iOS)
protocol VideoPlayerViewProtocol: AnnotationIntegrationView {
    var videoSlider: VideoProgressSlider { get }

    /// The color that is used throughout various controls and elements of the video player, together with the `secondaryColor`.
    var primaryColor: UIColor { get set }
    /// The color that is used throughout various controls and elements of the video player, together with the `primaryColor`.
    var secondaryColor: UIColor { get set }
    /// Whether the controlView has an alpha value of more than zero (0) or not.
    var controlViewHasAlpha: Bool { get }
    /// Whether the infoView has an alpha value of more than zero (0) or not.
    var infoViewHasAlpha: Bool { get }
    /// The view in which all event/stream title information is rendered.
    var infoTitleLabel: UILabel { get }
    /// The view in which all event/stream date information is rendered.
    var infoDateLabel: UILabel { get }
    /// The view in which event/stream description information is rendered.
    var infoDescriptionLabel: UILabel { get }

    /// The view in which all player controls are rendered. SDK implementers can add more controls to this view, if desired.
    var controlView: UIView { get }
    /// The AVPlayerLayer of the associated AVPlayer
    var playerLayer: AVPlayerLayer? { get }

    /// A horizontal UIStackView at the top-leading corner. Can be used to add more custom UIButtons to (e.g. PiP).
    var topLeadingControlsStackView: UIStackView { get }
    /// A horizontal UIStackView at the top-trailing corner. Can be used to add more custom UIButtons to (e.g. PiP).
    var topTrailingControlsStackView: UIStackView { get }
    /// Sets the visibility of the fullscreen button.
    var fullscreenButtonIsHidden: Bool { get set }
    /// The UITapGestureRecognizer that is listening to taps on the VideoPlayer's view.
    var tapGestureRecognizer: UITapGestureRecognizer { get }

    func drawPlayer(with player: MLSPlayerProtocol)
    func setOnPlayButtonTapped(_ action: @escaping () -> Void)
    func setOnSkipBackButtonTapped(_ action: @escaping () -> Void)
    func setOnSkipForwardButtonTapped(_ action: @escaping () -> Void)
    func setOnTimeSliderSlide(_ action: @escaping (Double) -> Void)
    func setOnTimeSliderRelease(_ action: @escaping (Double) -> Void)
    func setControlViewVisibility(visible: Bool, withAnimationDuration: Double)
    func setInfoViewVisibility(visible: Bool, withAnimationDuration: Double)
    func setPlayButtonTo(state: VideoPlayerPlayButtonState)
    func setLiveButtonTo(state: VideoPlayerLiveState)
    /// Shows the number of viewers on the video player. If <= 1 or nil, the element is hidden entirely.
    func setNumberOfViewersTo(amount: String?)
    func setOnControlViewTapped(_ action: @escaping () -> Void)
    func setOnLiveButtonTapped(_ action: @escaping () -> Void)
    func setOnFullscreenButtonTapped(_ action: @escaping () -> Void)
    func setOnInfoButtonTapped(_ action: @escaping () -> Void)
    func setFullscreenButtonTo(fullscreen: Bool)

    /// Sets the `isHidden` property of the entire control view, *including* the control view's alpha layer.
    func setControlView(hidden: Bool)
    /// Sets the `isHidden` property of the buffer icon.
    /// - note: This hides/shows the play button to the opposite visibility of the buffer icon.
    func setBufferIcon(hidden: Bool)
    /// Sets the `isHidden` property of the info button.
    func setInfoButton(hidden: Bool)
    /// Sets the `isHidden` property of the airplay button.
    func setAirplayButton(hidden: Bool)
    /// Sets the `isHidden` property of the skip backwards/forwards buttons.
    func setSkipButtons(hidden: Bool)
    /// Sets the `isHidden` property of the `timeIndicatorLabel`.
    /// - seeAlso: `setTimeIndicatorLabel(elapsedText:totalText:)`
    func setTimeIndicatorLabel(hidden: Bool)
    /// Set the time indicator label as an attributed string. If elapsedText is nil, then an empty string is rendered on the entire label.
    /// - seeAlso: `setTimeIndicatorLabel(hidden:)`
    func setTimeIndicatorLabel(elapsedText: String?, totalText: String?)
    /// Set the `isHidden` property of the seekbar.
    func setSeekbar(hidden: Bool)
}
#endif
