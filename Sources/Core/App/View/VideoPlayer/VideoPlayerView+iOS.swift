//
// Copyright © 2020 mycujoo. All rights reserved.
//

#if os(iOS)
import UIKit
import AVKit

class VideoPlayerView: UIView, VideoPlayerViewProtocol {

    // MARK: - Properties

    /// The AVPlayerLayer that is associated with this video player.
    private(set) var playerLayer: AVPlayerLayer?

    private var onControlViewTapped: (() -> Void)?
    private var onTimeSliderSlide: ((Double) -> Void)?
    private var onTimeSliderRelease: ((Double) -> Void)?
    private var onPlayButtonTapped: (() -> Void)?
    private var onSkipBackButtonTapped: (() -> Void)?
    private var onSkipForwardButtonTapped: (() -> Void)?
    private var onLiveButtonTapped: (() -> Void)?
    private var onFullscreenButtonTapped: (() -> Void)?
    private var onInfoButtonTapped: (() -> Void)?

    // MARK: - Internal properties

    /// The color that is used throughout various controls and elements of the video player, together with the `secondaryColor`.
    var primaryColor: UIColor = .white {
        didSet {
            playButton.tintColor = primaryColor
            skipBackButton.tintColor = primaryColor
            skipForwardButton.tintColor = primaryColor
            bufferIcon.color = primaryColor
            videoSlider.trackView.backgroundColor = primaryColor
        }
    }

    /// The color that is used throughout various controls and elements of the video player, together with the `primaryColor`.
    var secondaryColor: UIColor = .black {
        didSet {
            videoSlider.annotationBubbleColor = secondaryColor
        }
    }

    /// Whether the controlView has an alpha value of more than zero (0) or not.
    var controlViewHasAlpha: Bool {
        return controlView.alpha > 0
    }

    /// Whether the infoView has an alpha value of more than zero (0) or not.
    var infoViewHasAlpha: Bool {
        return infoView.alpha > 0
    }

    // MARK: - UI Components

    private lazy var playIcon = UIImage(named: "Icon-Play", in: Bundle.mlsResourceBundle, compatibleWith: nil)
    private lazy var pauseIcon = UIImage(named: "Icon-Pause", in: Bundle.mlsResourceBundle, compatibleWith: nil)
    private lazy var replayIcon = UIImage(named: "Icon-Replay", in: Bundle.mlsResourceBundle, compatibleWith: nil)
    private lazy var skipBackIcon = UIImage(named: "Icon-BackBy10", in: Bundle.mlsResourceBundle, compatibleWith: nil)
    private lazy var skipForwardIcon = UIImage(named: "Icon-ForwardBy10", in: Bundle.mlsResourceBundle, compatibleWith: nil)
    private lazy var fullscreenIcon = UIImage(named: "Icon-Fullscreen", in: Bundle.mlsResourceBundle, compatibleWith: nil)
    private lazy var shrinkscreenIcon = UIImage(named: "Icon-Shrinkscreen", in: Bundle.mlsResourceBundle, compatibleWith: nil)
    private lazy var infoIcon = UIImage(named: "Icon-Info", in: Bundle.mlsResourceBundle, compatibleWith: nil)
    private lazy var eyeIcon = UIImage(named: "Icon-Eye", in: Bundle.mlsResourceBundle, compatibleWith: nil)

    private lazy var playButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        if let image = playIcon {
            button.setImage(image, for: .normal)
            button.tintColor = .white
        }
        return button
    }()

    private lazy var bufferIcon: NVActivityIndicatorView = {
        let indicator = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 32, height: 32))
        indicator.color = .white
        indicator.type = .circleStrokeSpin
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()

    private lazy var skipBackButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        if let image = skipBackIcon {
            button.setImage(image, for: .normal)
            button.tintColor = .white
        }
        return button
    }()

    private lazy var skipForwardButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        if let image = skipForwardIcon {
            button.setImage(image, for: .normal)
            button.tintColor = .white
        }
        return button
    }()

    private let barControlsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.spacing = 9
        return stackView
    }()

    private let timeIndicatorLabel: UILabel! = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .natural
        label.textColor = UIColor(hex: "#cccccc")
        return label
    }()

    let videoSlider: VideoProgressSlider = {
        let slider = VideoProgressSlider()
        slider.translatesAutoresizingMaskIntoConstraints = false
        return slider
    }()

    private lazy var liveButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(L10n.Localizable.buttonTitleLive, for: .normal)
        button.backgroundColor = .red
        button.layer.cornerRadius = 2
        button.titleLabel?.font = UIFont.systemFont(ofSize: 11, weight: .bold)
        button.titleLabel?.textColor = .white
        button.alpha = 0
        button.contentEdgeInsets = UIEdgeInsets(top: 2, left: 4, bottom: 2, right: 4)
        button.clipsToBounds = true
        return button
    }()

    private let numberOfViewersView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        view.isHidden = true
        view.layer.cornerRadius = 2
        view.clipsToBounds = true
        return view
    }()

    private lazy var numberOfViewersEyeImage: UIImageView = {
        let view = UIImageView()
        view.image = eyeIcon
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    let numberOfViewersLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .natural
        label.numberOfLines = 1
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        label.font = UIFont.systemFont(ofSize: 10, weight: .regular)
        label.textColor = .white
        return label
    }()

    private lazy var fullscreenButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .white
        if let image = fullscreenIcon {
            button.setImage(image, for: .normal)
        }
        button.imageEdgeInsets = UIEdgeInsets(top: 9, left: 9, bottom: 9, right: 9)
        return button
    }()

    let topLeadingControlsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.spacing = 9
        if UIView.userInterfaceLayoutDirection(for: stackView.semanticContentAttribute) == .rightToLeft {
            stackView.semanticContentAttribute = .forceRightToLeft
        }
        return stackView
    }()

    let topTrailingControlsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.spacing = 9
        if UIView.userInterfaceLayoutDirection(for: stackView.semanticContentAttribute) == .rightToLeft {
            stackView.semanticContentAttribute = .forceRightToLeft
        }
        return stackView
    }()

    private lazy var airplayButton: UIView = {
        let view = UIView()
        let routerPickerView = AVRoutePickerView()
        view.translatesAutoresizingMaskIntoConstraints = false
        routerPickerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(routerPickerView)
        // Move the Airplay button down by 1 point, otherwise it looks visually inconsistent.
        NSLayoutConstraint.activate([
            routerPickerView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0),
            routerPickerView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0),
            routerPickerView.topAnchor.constraint(equalTo: view.topAnchor, constant: 1),
            routerPickerView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 1)
        ])
        routerPickerView.tintColor = .white
        routerPickerView.activeTintColor = .white
        if #available(iOS 13.0, *) {
            routerPickerView.prioritizesVideoDevices = true
        }
        return view
    }()

    private lazy var infoButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        if let image = infoIcon {
            button.setImage(image, for: .normal)
        }
        button.tintColor = .white
        button.imageEdgeInsets = UIEdgeInsets(top: 7, left: 7, bottom: 7, right: 7)
        return button
    }()

    private let controlAlphaView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.alpha = 0
        return view
    }()

    /// The view that should be constrained to both the `VideoPlayerView`, but also the safeArea. Should be the parent view of e.g. `controlView`.
    private let safeView: UIView = {
        let view = UIView()
        // This layer should NOT clipToBounds, since the controlAlphaView is a child-view but exceeds the safeView bounds.
        view.clipsToBounds = false
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    /// The view in which all player controls are rendered. SDK implementers can add more controls to this view, if desired.
    let controlView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.alpha = 0
        return view
    }()

    /// The view in which all dynamic overlays are rendered.
    public let overlayContainerView: UIView = {
        let view = UIView()
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    /// The view in which all event/stream information is rendered.
    private let infoView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.black.withAlphaComponent(0.9)
        view.alpha = 0.0
        // user interaction is disabled because the UITapGestureRecognizer on the controlView is used to determine whether
        // to dismiss the infoView.
        // If we need interaction in the infoView later on (e.g. a UIButton) then we can no longer rely on this tap gesture recognizer.
        view.isUserInteractionEnabled = false
        return view
    }()

    /// The view in which all event/stream information is rendered.
    let infoTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .natural
        label.numberOfLines = 2
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        label.font = UIFont.systemFont(ofSize: 24, weight: .black)
        label.textColor = .white
        return label
    }()

    /// The view in which all event/stream information is rendered.
    let infoDateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .natural
        label.numberOfLines = 1
        label.adjustsFontSizeToFitWidth = true
        label.font = .boldSystemFont(ofSize: 12)
        label.minimumScaleFactor = 0.5
        label.textColor = .white
        return label
    }()

    /// The view in which all event/stream information is rendered.
    let infoDescriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .natural
        label.numberOfLines = 3
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        label.font = .systemFont(ofSize: 12)
        label.textColor = .white
        return label
    }()

    /// A dictionary of arrays, where each array is the set of constraints of a single overlay. These constraints should be
    /// copied when the UIView is exchanged for a newer one. The key is the `hash` of the UIView that the constraints belong to.
    var copyableOverlayConstraints: [Int: [NSLayoutConstraint]] = [:]

    // MARK: - accessors

    /// Sets the visibility of the fullscreen button.
    var fullscreenButtonIsHidden: Bool = false {
        didSet {
            fullscreenButton.isHidden = fullscreenButtonIsHidden

            if let rightConstraint = barControlsStackView.constraints(on: barControlsStackView.rightAnchor).first {
                rightConstraint.constant = fullscreenButtonIsHidden ? -14 : -5
            }
        }
    }

    /// Exposes the `UITapGestureRecognizer` on the VideoPlayerView, which is used to determine whether to hide or show the controls.
    private(set) lazy var tapGestureRecognizer: UITapGestureRecognizer = {
        let gr = UITapGestureRecognizer(target: self, action: #selector(controlViewTapped))
        gr.numberOfTapsRequired = 1
        gr.delegate = self
        return gr
    }()

    // MARK: - Init

    init() {
        super.init(frame: .zero)
        drawSelf()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        drawSelf()
    }

    // MARK: - Layout

    private func drawSelf() {
        addSubview(safeView)
        safeView.addSubview(overlayContainerView)
        safeView.addSubview(controlAlphaView)
        safeView.addSubview(controlView)
        safeView.addSubview(bufferIcon)
        safeView.addSubview(infoView)
        infoView.addSubview(infoTitleLabel)
        infoView.addSubview(infoDateLabel)
        infoView.addSubview(infoDescriptionLabel)
        drawControls()

        let safeViewConstraints = [
            safeView.leftAnchor.constraint(equalTo: leftAnchor, constant: 0),
            safeView.rightAnchor.constraint(equalTo: rightAnchor, constant: 0),
            safeView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0),
            safeView.topAnchor.constraint(equalTo: topAnchor, constant: 0)
        ]

        let safeViewSafeAreaConstraints = [
            safeView.leftAnchor.constraint(greaterThanOrEqualTo: safeAreaLayoutGuide.leftAnchor, constant: 0),
            safeView.rightAnchor.constraint(lessThanOrEqualTo: safeAreaLayoutGuide.rightAnchor, constant: 0),
            safeView.bottomAnchor.constraint(lessThanOrEqualTo: safeAreaLayoutGuide.bottomAnchor, constant: 0),
            safeView.topAnchor.constraint(greaterThanOrEqualTo: safeAreaLayoutGuide.topAnchor, constant: 0)
        ]

        for constraint in safeViewConstraints {
            constraint.priority = UILayoutPriority(rawValue: 751)
        }
        for constraint in safeViewSafeAreaConstraints {
            constraint.priority = UILayoutPriority(rawValue: 752)
        }

        NSLayoutConstraint.activate(safeViewConstraints)
        NSLayoutConstraint.activate(safeViewSafeAreaConstraints)

        let constraints = [
            controlView.leftAnchor.constraint(equalTo: safeView.leftAnchor, constant: 0),
            controlView.rightAnchor.constraint(equalTo: safeView.rightAnchor, constant: 0),
            controlView.bottomAnchor.constraint(equalTo: safeView.bottomAnchor, constant: 0),
            controlView.topAnchor.constraint(equalTo: safeView.topAnchor, constant: 0),
            overlayContainerView.leftAnchor.constraint(equalTo: safeView.leftAnchor, constant: 0),
            overlayContainerView.rightAnchor.constraint(equalTo: safeView.rightAnchor, constant: 0),
            overlayContainerView.bottomAnchor.constraint(equalTo: safeView.bottomAnchor, constant: 0),
            overlayContainerView.topAnchor.constraint(equalTo: safeView.topAnchor, constant: 0),
            bufferIcon.centerYAnchor.constraint(equalTo: safeView.centerYAnchor),
            bufferIcon.centerXAnchor.constraint(equalTo: safeView.centerXAnchor),
            bufferIcon.heightAnchor.constraint(equalToConstant: 32),
            bufferIcon.widthAnchor.constraint(equalToConstant: 32),
            controlAlphaView.leftAnchor.constraint(equalTo: leftAnchor, constant: 0),
            controlAlphaView.rightAnchor.constraint(equalTo: rightAnchor, constant: 0),
            controlAlphaView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0),
            controlAlphaView.topAnchor.constraint(equalTo: topAnchor, constant: 0),
            infoView.leftAnchor.constraint(equalTo: safeView.leftAnchor, constant: 0),
            infoView.rightAnchor.constraint(equalTo: safeView.rightAnchor, constant: 0),
            infoView.bottomAnchor.constraint(equalTo: safeView.bottomAnchor, constant: 0),
            infoView.topAnchor.constraint(equalTo: safeView.topAnchor, constant: 0),
        ]

        for constraint in constraints {
            constraint.priority = UILayoutPriority(rawValue: 750)
        }

        NSLayoutConstraint.activate(constraints)

        // MARK: InfoView

        infoTitleLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        infoDateLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        infoDescriptionLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)

        let infoViewConstraints = [
            infoTitleLabel.topAnchor.constraint(equalTo: infoView.topAnchor, constant: 24),
            infoTitleLabel.leadingAnchor.constraint(equalTo: infoView.leadingAnchor, constant: 16),
            infoTitleLabel.trailingAnchor.constraint(equalTo: infoView.trailingAnchor, constant: -16),

            infoDateLabel.topAnchor.constraint(equalTo: infoTitleLabel.bottomAnchor, constant: 8),
            infoDateLabel.leadingAnchor.constraint(equalTo: infoView.leadingAnchor, constant: 16),
            infoDateLabel.trailingAnchor.constraint(equalTo: infoView.trailingAnchor, constant: -16),

            infoDescriptionLabel.topAnchor.constraint(equalTo: infoDateLabel.bottomAnchor, constant: 8),
            infoDescriptionLabel.leadingAnchor.constraint(equalTo: infoView.leadingAnchor, constant: 16),
            infoDescriptionLabel.trailingAnchor.constraint(equalTo: infoView.trailingAnchor, constant: -16),
        ]

        for constraint in infoViewConstraints {
            constraint.priority = UILayoutPriority(rawValue: 748)
        }

        NSLayoutConstraint.activate(infoViewConstraints)

        let c = infoDescriptionLabel.bottomAnchor.constraint(lessThanOrEqualTo: infoView.bottomAnchor, constant: -16)
        c.priority = UILayoutPriority(rawValue: 749)
        c.isActive = true

        // MARK: General

        backgroundColor = .black

        setTimeIndicatorLabel(elapsedText: nil, totalText: nil)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        playerLayer?.frame = bounds
    }

    private func drawControls() {
        // MARK: Basic setup

        controlAlphaView.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.7455710827)
        controlView.addSubview(barControlsStackView)
        controlView.addSubview(topLeadingControlsStackView)
        controlView.addSubview(topTrailingControlsStackView)

        // MARK: Play/pause button

        controlView.addSubview(playButton)

        NSLayoutConstraint.activate([
            playButton.centerXAnchor.constraint(equalTo: controlView.centerXAnchor),
            playButton.centerYAnchor.constraint(equalTo: controlView.centerYAnchor),
            playButton.heightAnchor.constraint(equalToConstant: 32),
            playButton.widthAnchor.constraint(equalToConstant: 32)
        ])

        playButton.addTarget(self, action: #selector(playButtonTapped), for: .touchUpInside)

        // MARK: Skip forward/backwards buttons

        controlView.addSubview(skipBackButton)
        controlView.addSubview(skipForwardButton)

        NSLayoutConstraint.activate([
            skipBackButton.rightAnchor.constraint(equalTo: playButton.leftAnchor, constant: -32),
            skipBackButton.centerYAnchor.constraint(equalTo: controlView.centerYAnchor),
            skipBackButton.heightAnchor.constraint(equalToConstant: 32),
            skipBackButton.widthAnchor.constraint(equalToConstant: 32),
            skipForwardButton.leftAnchor.constraint(equalTo: playButton.rightAnchor, constant: 32),
            skipForwardButton.centerYAnchor.constraint(equalTo: controlView.centerYAnchor),
            skipForwardButton.heightAnchor.constraint(equalToConstant: 32),
            skipForwardButton.widthAnchor.constraint(equalToConstant: 32),
        ])

        skipBackButton.addTarget(self, action: #selector(skipBackButtonTapped), for: .touchUpInside)
        skipForwardButton.addTarget(self, action: #selector(skipForwardButtonTapped), for: .touchUpInside)


        // MARK: Seekbar

        controlView.addSubview(videoSlider)
        NSLayoutConstraint.activate([
            videoSlider.leftAnchor.constraint(equalTo: controlView.leftAnchor, constant: 14),
            videoSlider.rightAnchor.constraint(equalTo: controlView.rightAnchor, constant: -14),
            // Offset the bottom by 10 to correct for the 30 height (because 20pts of its height are padding for the thumb view)
            videoSlider.bottomAnchor.constraint(equalTo: barControlsStackView.topAnchor, constant: 10),
            videoSlider.heightAnchor.constraint(equalToConstant: 30)
        ])

        videoSlider.addTarget(self, action: #selector(timeSliderSlide), for: .valueChanged)
        videoSlider.addTarget(self, action: #selector(timeSliderRelease), for: [.touchUpInside, .touchUpOutside])

        // MARK: Below seekbar

        let spacer = UIView()
        barControlsStackView.addArrangedSubview(timeIndicatorLabel)
        barControlsStackView.addArrangedSubview(spacer)
        barControlsStackView.addArrangedSubview(liveButton)
        barControlsStackView.addArrangedSubview(numberOfViewersView)
        barControlsStackView.addArrangedSubview(fullscreenButton)

        NSLayoutConstraint.activate([
           barControlsStackView.leftAnchor.constraint(equalTo: controlView.leftAnchor, constant: 14),
           barControlsStackView.rightAnchor.constraint(equalTo: controlView.rightAnchor, constant: -5),
           barControlsStackView.bottomAnchor.constraint(equalTo: controlView.bottomAnchor, constant: -8),
           barControlsStackView.heightAnchor.constraint(equalToConstant: 32)
        ])

        numberOfViewersView.addSubview(numberOfViewersEyeImage)
        numberOfViewersView.addSubview(numberOfViewersLabel)
        NSLayoutConstraint.activate([
            numberOfViewersEyeImage.centerYAnchor.constraint(equalTo: numberOfViewersView.centerYAnchor),
            numberOfViewersEyeImage.leftAnchor.constraint(equalTo: numberOfViewersView.leftAnchor, constant: 4),
            numberOfViewersEyeImage.rightAnchor.constraint(equalTo: numberOfViewersLabel.leftAnchor, constant: -4),
            numberOfViewersLabel.topAnchor.constraint(equalTo: numberOfViewersView.topAnchor, constant: 4),
            numberOfViewersLabel.bottomAnchor.constraint(equalTo: numberOfViewersView.bottomAnchor, constant: -4),
            numberOfViewersLabel.rightAnchor.constraint(equalTo: numberOfViewersView.rightAnchor, constant: -4)
        ])

        barControlsStackView.semanticContentAttribute = .forceLeftToRight
//        barControlsStackView.setCustomSpacing(14, after: timeIndicatorLabel)

        // Set a minimum width explicitly to prevent constant resizing of the seekbar when dragging it.
        timeIndicatorLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 50).isActive = true

        timeIndicatorLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
        timeIndicatorLabel.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        liveButton.setContentHuggingPriority(.defaultLow, for: .horizontal)
        liveButton.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        numberOfViewersView.setContentHuggingPriority(.defaultLow, for: .horizontal)
        numberOfViewersView.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        fullscreenButton.setContentHuggingPriority(.defaultLow, for: .horizontal)
        fullscreenButton.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)

        liveButton.addTarget(self, action: #selector(liveButtonTapped), for: .touchUpInside)
        fullscreenButton.addTarget(self, action: #selector(fullscreenButtonTapped), for: .touchUpInside)

        // MARK: Top buttons

        NSLayoutConstraint.activate([
            topLeadingControlsStackView.leadingAnchor.constraint(equalTo: controlView.leadingAnchor, constant: -5),
            topLeadingControlsStackView.topAnchor.constraint(equalTo: controlView.topAnchor, constant: 1),
            topLeadingControlsStackView.heightAnchor.constraint(equalToConstant: 40),
            topTrailingControlsStackView.trailingAnchor.constraint(equalTo: controlView.trailingAnchor, constant: -5),
            topTrailingControlsStackView.topAnchor.constraint(equalTo: controlView.topAnchor, constant: 1),
            topTrailingControlsStackView.heightAnchor.constraint(equalToConstant: 40)
        ])

        topTrailingControlsStackView.addArrangedSubview(airplayButton)
        topTrailingControlsStackView.addArrangedSubview(infoButton)

        infoButton.addTarget(self, action: #selector(infoButtonTapped), for: .touchUpInside)

        addGestureRecognizer(tapGestureRecognizer)
    }

    //MARK: - Methods

    func drawPlayer(with player: MLSPlayerProtocol) {
        if let mlsPlayer = player as? AVPlayer {
            // Only add the playerlayer in real scenarios. When running unit tests with a mocked player, this will not work.
            let playerLayer = AVPlayerLayer(player: mlsPlayer)
            playerLayer.videoGravity = .resizeAspect
            playerLayer.needsDisplayOnBoundsChange = true
            self.playerLayer = playerLayer
            layer.addSublayer(playerLayer)
            playerLayer.frame = bounds
        }

        bringSubviewToFront(safeView)
    }
}

// MARK: - Actions
extension VideoPlayerView {
    func setOnControlViewTapped(_ action: @escaping () -> Void) {
        onControlViewTapped = action
    }

    @objc private func controlViewTapped() {
        onControlViewTapped?()
    }

    func setOnPlayButtonTapped(_ action: @escaping () -> Void) {
        onPlayButtonTapped = action
    }

    @objc private func playButtonTapped() {
        onPlayButtonTapped?()
    }

    func setOnSkipBackButtonTapped(_ action: @escaping () -> Void) {
        onSkipBackButtonTapped = action
    }

    @objc private func skipBackButtonTapped() {
        onSkipBackButtonTapped?()
    }

    func setOnSkipForwardButtonTapped(_ action: @escaping () -> Void) {
        onSkipForwardButtonTapped = action
    }

    @objc private func skipForwardButtonTapped() {
        onSkipForwardButtonTapped?()
    }

    func setOnLiveButtonTapped(_ action: @escaping () -> Void) {
        onLiveButtonTapped = action
    }

    @objc private func liveButtonTapped() {
        onLiveButtonTapped?()
    }

    func setOnFullscreenButtonTapped(_ action: @escaping () -> Void) {
        onFullscreenButtonTapped = action
    }

    @objc private func fullscreenButtonTapped() {
        onFullscreenButtonTapped?()
    }

    func setOnInfoButtonTapped(_ action: @escaping () -> Void) {
        onInfoButtonTapped = action
    }

    @objc private func infoButtonTapped() {
        onInfoButtonTapped?()
    }

    func setOnTimeSliderSlide(_ action: @escaping (Double) -> Void) {
        onTimeSliderSlide = action
    }

    @objc private func timeSliderSlide(_ sender: VideoProgressSlider) {
        onTimeSliderSlide?(sender.value)
    }

    func setOnTimeSliderRelease(_ action: @escaping (Double) -> Void) {
        onTimeSliderRelease = action
    }

    @objc private func timeSliderRelease(_ sender: VideoProgressSlider) {
        onTimeSliderRelease?(sender.value)
    }

    func setControlViewVisibility(visible: Bool, withAnimationDuration: Double) {
        DispatchQueue.main.async {
            UIView.animate(withDuration: withAnimationDuration) {
                self.controlAlphaView.alpha = visible ? 1 : 0
                self.controlView.alpha = visible ? 1 : 0
            }
        }
    }

    func setInfoViewVisibility(visible: Bool, withAnimationDuration: Double) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            UIView.animate(withDuration: withAnimationDuration) {
                self.infoView.alpha = visible ? 1 : 0
            }
        }
    }

    func setPlayButtonTo(state: VideoPlayerPlayButtonState) {
        let icon: UIImage?
        switch state {
        case .play:
            icon = playIcon
        case .pause:
            icon = pauseIcon
        case .replay:
            icon = replayIcon
        case .none:
            icon = nil
        }

        playButton.setImage(icon, for: .normal)
    }

    func setLiveButtonTo(state: VideoPlayerLiveState) {
        switch state {
        case .liveAndLatest:
            liveButton.alpha = 1
            liveButton.backgroundColor = .red
        case .liveNotLatest:
            liveButton.alpha = 1
            liveButton.backgroundColor = .gray
        case .notLive:
            liveButton.alpha = 0
        }
    }

    func setNumberOfViewersTo(amount: String?) {
        guard let amount = amount else {
            numberOfViewersView.isHidden = true
            return
        }
        numberOfViewersLabel.text = amount
        numberOfViewersView.isHidden = false
    }

    func setFullscreenButtonTo(fullscreen: Bool) {
        let icon: UIImage?
        switch fullscreen {
        case true:
            icon = shrinkscreenIcon
        case false:
            icon = fullscreenIcon
        }

        if let image = icon {
            fullscreenButton.setImage(image, for: .normal)
        }
    }

    /// Sets the `isHidden` property of the entire control view, *including* the control view's alpha layer.
    func setControlView(hidden: Bool) {
        controlView.isHidden = hidden
        controlAlphaView.isHidden = hidden
    }

    /// Sets the `isHidden` property of the buffer icon.
    /// - note: This hides/shows the play button to the opposite visibility of the buffer icon.
    func setBufferIcon(hidden: Bool) {
        if hidden {
            sendSubviewToBack(bufferIcon)
            bufferIcon.stopAnimating()
        } else {
            bufferIcon.startAnimating()
            bringSubviewToFront(bufferIcon)
        }
        bufferIcon.isHidden = hidden
        playButton.isHidden = !hidden
    }

    /// Sets the `isHidden` property of the skip backwards/forwards buttons.
    func setSkipButtons(hidden: Bool) {
        skipBackButton.isHidden = hidden
        skipForwardButton.isHidden = hidden
    }

    /// Sets the `isHidden` property of the info button.
    func setInfoButton(hidden: Bool) {
        infoButton.isHidden = hidden
    }

    /// Sets the `isHidden` property of the airplay button.
    func setAirplayButton(hidden: Bool) {
        airplayButton.isHidden = hidden
    }

    /// Sets the `isHidden` property of the `timeIndicatorLabel`.
    /// - seeAlso: `setTimeIndicatorLabel(elapsedText:totalText:)`
    func setTimeIndicatorLabel(hidden: Bool) {
        timeIndicatorLabel.isHidden = hidden
    }

    /// Set the time indicator label as an attributed string. If elapsedText is nil, then an empty string is rendered on the entire label.
    /// - seeAlso: `setTimeIndicatorLabel(hidden:)`
    func setTimeIndicatorLabel(elapsedText: String?, totalText: String?) {
        guard let elapsedText = elapsedText else {
            timeIndicatorLabel.text = ""
            return
        }

        let str1 = NSMutableAttributedString(string: elapsedText, attributes: [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 10, weight: .bold).monospacedDigitFont,
            NSAttributedString.Key.foregroundColor: UIColor.white
        ])

        if let totalText = totalText {
            let str2 = NSMutableAttributedString(string: " / \(totalText)", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 10, weight: .regular)])

            str1.append(str2)
        }

        if UIView.userInterfaceLayoutDirection(for: self.semanticContentAttribute) == .rightToLeft {
            // TODO: I18N
        }

        timeIndicatorLabel.attributedText = str1
    }

    /// Set the `isHidden` property of the seekbar.
    func setSeekbar(hidden: Bool) {
        videoSlider.isHidden = hidden
    }
}

// - MARK: GestureRecognizerDelegate

extension VideoPlayerView: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        // Ensure that the tapGestureRecognizer does not register on any controls.
        if (touch.view?.isKind(of: UIControl.self) ?? false) {
            return false
        }
        return true
    }
}

#endif
