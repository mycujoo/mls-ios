//
// Copyright © 2020 mycujoo. All rights reserved.
//

#if os(iOS)
import UIKit
import AVKit

public class VideoPlayerView: UIView  {

    // MARK: - Properties

    /// The AVPlayerLayer that is associated with this video player.
    private(set) public var playerLayer: AVPlayerLayer?

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

    private lazy var playIcon = UIImage(named: "Icon-Play", in: Bundle.resourceBundle, compatibleWith: nil)
    private lazy var pauseIcon = UIImage(named: "Icon-Pause", in: Bundle.resourceBundle, compatibleWith: nil)
    private lazy var replayIcon = UIImage(named: "Icon-Replay", in: Bundle.resourceBundle, compatibleWith: nil)
    private lazy var skipBackIcon = UIImage(named: "Icon-BackBy10", in: Bundle.resourceBundle, compatibleWith: nil)
    private lazy var skipForwardIcon = UIImage(named: "Icon-ForwardBy10", in: Bundle.resourceBundle, compatibleWith: nil)
    private lazy var fullscreenIcon = UIImage(named: "Icon-Fullscreen", in: Bundle.resourceBundle, compatibleWith: nil)
    private lazy var shrinkscreenIcon = UIImage(named: "Icon-Shrinkscreen", in: Bundle.resourceBundle, compatibleWith: nil)
    private lazy var infoIcon = UIImage(named: "Icon-Info", in: Bundle.resourceBundle, compatibleWith: nil)

    lazy var playButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        if let image = playIcon {
            button.setImage(image, for: .normal)
            button.tintColor = .white
        }
        return button
    }()

    lazy var bufferIcon: NVActivityIndicatorView = {
        let indicator = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 32, height: 32))
        indicator.color = .white
        indicator.type = .circleStrokeSpin
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()

    lazy var skipBackButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        if let image = skipBackIcon {
            button.setImage(image, for: .normal)
            button.tintColor = .white
        }
        return button
    }()

    lazy var skipForwardButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        if let image = skipForwardIcon {
            button.setImage(image, for: .normal)
            button.tintColor = .white
        }
        return button
    }()

    let barControlsStackView: UIStackView = {
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

    lazy var liveButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(NSLocalizedString("LIVE", tableName: "Localizable", bundle: Bundle.resourceBundle ?? Bundle.main, value: "LIVE", comment: ""), for: .normal)
        button.backgroundColor = .red
        button.layer.cornerRadius = 2
        button.titleLabel?.font = UIFont.systemFont(ofSize: 11, weight: .bold)
        button.titleLabel?.textColor = .white
        button.alpha = 0
        button.contentEdgeInsets = UIEdgeInsets(top: 2, left: 4, bottom: 2, right: 4)
        return button
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

    /// This horizontal UIStackView can be used to add more custom UIButtons to (e.g. PiP).
    public let topControlsStackView: UIStackView = {
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

    lazy var infoButton: UIButton = {
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
    public let controlView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.alpha = 0
        return view
    }()

    /// The view in which all dynamic overlays are rendered.
    let overlayContainerView: UIView = {
        let view = UIView()
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    /// The view in which all event/stream information is rendered.
    let infoView: UIView = {
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
        label.textAlignment = .center
        label.numberOfLines = 2
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        label.font = .boldSystemFont(ofSize: 16)
        label.textColor = .white
        return label
    }()

    /// The view in which all event/stream information is rendered.
    let infoDateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
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
        label.textAlignment = .center
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

    // MARK: - Public accessors

    /// Sets the visibility of the fullscreen button.
    public var fullscreenButtonIsHidden: Bool = false {
        didSet {
            fullscreenButton.isHidden = fullscreenButtonIsHidden

            if let rightConstraint = barControlsStackView.constraints(on: barControlsStackView.rightAnchor).first {
                rightConstraint.constant = fullscreenButtonIsHidden ? -14 : -5
            }
        }
    }

    /// Exposes the `UITapGestureRecognizer` on the VideoPlayerView, which is used to determine whether to hide or show the controls.
    public lazy var tapGestureRecognizer: UITapGestureRecognizer = {
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
            infoView.leftAnchor.constraint(equalTo: safeView.leftAnchor, constant: 40),
            infoView.rightAnchor.constraint(equalTo: safeView.rightAnchor, constant: -40),
            infoView.bottomAnchor.constraint(equalTo: safeView.bottomAnchor, constant: -40),
            infoView.topAnchor.constraint(equalTo: safeView.topAnchor, constant: 40),
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
            infoTitleLabel.topAnchor.constraint(equalTo: infoView.topAnchor, constant: 8),
            infoTitleLabel.leadingAnchor.constraint(equalTo: infoView.leadingAnchor, constant: 8),
            infoTitleLabel.trailingAnchor.constraint(equalTo: infoView.trailingAnchor, constant: -8),

            infoDateLabel.topAnchor.constraint(equalTo: infoTitleLabel.bottomAnchor, constant: 4),
            infoDateLabel.leadingAnchor.constraint(equalTo: infoView.leadingAnchor, constant: 8),
            infoDateLabel.trailingAnchor.constraint(equalTo: infoView.trailingAnchor, constant: -8),

            infoDescriptionLabel.topAnchor.constraint(equalTo: infoDateLabel.bottomAnchor, constant: 12),
            infoDescriptionLabel.leadingAnchor.constraint(equalTo: infoView.leadingAnchor, constant: 8),
            infoDescriptionLabel.trailingAnchor.constraint(equalTo: infoView.trailingAnchor, constant: -8),
        ]

        for constraint in infoViewConstraints {
            constraint.priority = UILayoutPriority(rawValue: 748)
        }

        NSLayoutConstraint.activate(infoViewConstraints)

        let c = infoDescriptionLabel.bottomAnchor.constraint(lessThanOrEqualTo: infoView.bottomAnchor, constant: -8)
        c.priority = UILayoutPriority(rawValue: 749)
        c.isActive = true

        // MARK: General

        backgroundColor = .black

        setTimeIndicatorLabel(elapsedText: nil, totalText: nil)
    }

    public override func layoutSubviews() {
        super.layoutSubviews()
        playerLayer?.frame = bounds
    }

    private func drawControls() {
        // MARK: Basic setup

        controlAlphaView.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.7455710827)
        controlView.addSubview(barControlsStackView)
        controlView.addSubview(topControlsStackView)

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
        barControlsStackView.addArrangedSubview(fullscreenButton)

        NSLayoutConstraint.activate([
           barControlsStackView.leftAnchor.constraint(equalTo: controlView.leftAnchor, constant: 14),
           barControlsStackView.rightAnchor.constraint(equalTo: controlView.rightAnchor, constant: -5),
           barControlsStackView.bottomAnchor.constraint(equalTo: controlView.bottomAnchor, constant: -8),
           barControlsStackView.heightAnchor.constraint(equalToConstant: 32)
        ])

        barControlsStackView.semanticContentAttribute = .forceLeftToRight
//        barControlsStackView.setCustomSpacing(14, after: timeIndicatorLabel)

        // Set a minimum width explicitly to prevent constant resizing of the seekbar when dragging it.
        timeIndicatorLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 50).isActive = true

        timeIndicatorLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
        timeIndicatorLabel.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        liveButton.setContentHuggingPriority(.defaultLow, for: .horizontal)
        liveButton.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        fullscreenButton.setContentHuggingPriority(.defaultLow, for: .horizontal)
        fullscreenButton.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)

        liveButton.addTarget(self, action: #selector(liveButtonTapped), for: .touchUpInside)
        fullscreenButton.addTarget(self, action: #selector(fullscreenButtonTapped), for: .touchUpInside)

        // MARK: Top buttons

        NSLayoutConstraint.activate([
           topControlsStackView.trailingAnchor.constraint(equalTo: controlView.trailingAnchor, constant: -5),
           topControlsStackView.topAnchor.constraint(equalTo: controlView.topAnchor, constant: 1),
           topControlsStackView.heightAnchor.constraint(equalToConstant: 40)
        ])

        topControlsStackView.addArrangedSubview(infoButton)

        infoButton.addTarget(self, action: #selector(infoButtonTapped), for: .touchUpInside)

        addGestureRecognizer(tapGestureRecognizer)
    }

    //MARK: - Methods

    func drawPlayer(with player: AVPlayer) {
        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.videoGravity = .resizeAspect
        playerLayer.needsDisplayOnBoundsChange = true
        self.playerLayer = playerLayer
        layer.addSublayer(playerLayer)
        playerLayer.frame = bounds

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

    func setControlViewVisibility(visible: Bool, animated: Bool) {
        if (!controlViewHasAlpha) == visible {
            DispatchQueue.main.async {
                UIView.animate(withDuration: animated ? 0.2 : 0) {
                    self.controlAlphaView.alpha = visible ? 1 : 0
                    self.controlView.alpha = visible ? 1 : 0
                }
            }
        }
    }

    func setInfoViewVisibility(visible: Bool, animated: Bool) {
        if (!infoViewHasAlpha) == visible {
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                UIView.animate(withDuration: animated ? 0.2 : 0) {
                    self.infoView.alpha = visible ? 1 : 0
                }
            }
        }
    }

    func setPlayButtonTo(state: VideoPlayer.PlayButtonState) {
        let icon: UIImage?
        switch state {
        case .play:
            icon = playIcon
        case .pause:
            icon = pauseIcon
        case .replay:
            icon = replayIcon
        }

        if let image = icon {
            playButton.setImage(image, for: .normal)
        }
    }

    func setLiveButtonTo(state: VideoPlayer.LiveState) {
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

    /// - note: This hides/shows the play button to the opposite visibility of the buffer icon.
    func setBufferIcon(visible: Bool) {
        if visible {
            bufferIcon.startAnimating()
            bringSubviewToFront(bufferIcon)
        } else {
            sendSubviewToBack(bufferIcon)
            bufferIcon.stopAnimating()
        }
        bufferIcon.isHidden = !visible
        playButton.isHidden = visible
    }

    /// Set the time indicator label as an attributed string. If elapsedText is nil, then an empty string is rendered on the entire label.
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
}

// - MARK: GestureRecognizerDelegate

extension VideoPlayerView: UIGestureRecognizerDelegate {
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        // Ensure that the tapGestureRecognizer does not register on any controls.
        if (touch.view?.isKind(of: UIControl.self) ?? false) {
            return false
        }
        return true
    }
}

#endif