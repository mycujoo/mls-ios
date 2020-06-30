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

    private var onTimeSliderSlide: ((Double) -> Void)?
    private var onPlayButtonTapped: (() -> Void)?
    private var onSkipBackButtonTapped: (() -> Void)?
    private var onSkipForwardButtonTapped: (() -> Void)?
    private var onFullscreenButtonTapped: (() -> Void)?
    private var controlViewDebouncer = Debouncer(minimumDelay: 4.0)

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

    /// A dictionary of dynamic overlays currently showing within this view. Keys are the overlay identifiers.
    /// The UIView should be the outer container of the overlay, not the SVGView directly.
    var overlays: [String: UIView] = [:]

    // MARK: - UI Components

    private lazy var playIcon = UIImage(named: "Icon-Play", in: Bundle.resourceBundle, compatibleWith: nil)
    private lazy var pauseIcon = UIImage(named: "Icon-Pause", in: Bundle.resourceBundle, compatibleWith: nil)
    private lazy var replayIcon = UIImage(named: "Icon-Replay", in: Bundle.resourceBundle, compatibleWith: nil)
    private lazy var skipBackIcon = UIImage(named: "Icon-BackBy10", in: Bundle.resourceBundle, compatibleWith: nil)
    private lazy var skipForwardIcon = UIImage(named: "Icon-ForwardBy10", in: Bundle.resourceBundle, compatibleWith: nil)
    private lazy var fullscreenIcon = UIImage(named: "Icon-Fullscreen", in: Bundle.resourceBundle, compatibleWith: nil)
    private lazy var shrinkscreenIcon = UIImage(named: "Icon-Shrinkscreen", in: Bundle.resourceBundle, compatibleWith: nil)

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
        stackView.alignment = .fill
        stackView.distribution = .fill
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

    private let controlAlphaView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    /// The view in which all player controls are rendered. SDK implementers can add more controls to this view, if desired.
    public let controlView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    /// The view in which all dynamic overlays are rendered.
    let overlayContainerView: UIView = {
        let view = UIView()
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

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
        addSubview(overlayContainerView)
        addSubview(controlView)
        addSubview(controlAlphaView)
        drawControls()

        let viewConstraints = [
            controlView.leftAnchor.constraint(equalTo: leftAnchor, constant: 0),
            controlView.rightAnchor.constraint(equalTo: rightAnchor, constant: 0),
            controlView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0),
            controlView.topAnchor.constraint(equalTo: topAnchor, constant: 0),
            overlayContainerView.leftAnchor.constraint(equalTo: leftAnchor, constant: 0),
            overlayContainerView.rightAnchor.constraint(equalTo: rightAnchor, constant: 0),
            overlayContainerView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0),
            overlayContainerView.topAnchor.constraint(equalTo: topAnchor, constant: 0)
        ]

        let safeAreaConstraints = [
            controlView.leftAnchor.constraint(greaterThanOrEqualTo: safeAreaLayoutGuide.leftAnchor, constant: 0),
            controlView.rightAnchor.constraint(lessThanOrEqualTo: safeAreaLayoutGuide.rightAnchor, constant: 0),
            controlView.bottomAnchor.constraint(lessThanOrEqualTo: safeAreaLayoutGuide.bottomAnchor, constant: 0),
            controlView.topAnchor.constraint(greaterThanOrEqualTo: safeAreaLayoutGuide.topAnchor, constant: 0),
            overlayContainerView.leftAnchor.constraint(greaterThanOrEqualTo: safeAreaLayoutGuide.leftAnchor, constant: 0),
            overlayContainerView.rightAnchor.constraint(lessThanOrEqualTo: safeAreaLayoutGuide.rightAnchor, constant: 0),
            overlayContainerView.bottomAnchor.constraint(lessThanOrEqualTo: safeAreaLayoutGuide.bottomAnchor, constant: 0),
            overlayContainerView.topAnchor.constraint(greaterThanOrEqualTo: safeAreaLayoutGuide.topAnchor, constant: 0)
        ]

        let alphaConstraints = [
            controlAlphaView.leftAnchor.constraint(equalTo: leftAnchor, constant: 0),
            controlAlphaView.rightAnchor.constraint(equalTo: rightAnchor, constant: 0),
            controlAlphaView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0),
            controlAlphaView.topAnchor.constraint(equalTo: topAnchor, constant: 0)
        ]

        for constraint in viewConstraints {
            constraint.priority = UILayoutPriority(rawValue: 749)
        }
        for constraint in safeAreaConstraints {
            constraint.priority = UILayoutPriority(rawValue: 750)
        }
        for constraint in alphaConstraints {
            constraint.priority = UILayoutPriority(rawValue: 750)
        }

        NSLayoutConstraint.activate(viewConstraints)
        NSLayoutConstraint.activate(safeAreaConstraints)
        NSLayoutConstraint.activate(alphaConstraints)

        addSubview(bufferIcon)
        NSLayoutConstraint.activate(
            [
                bufferIcon.centerYAnchor.constraint(equalTo: centerYAnchor),
                bufferIcon.centerXAnchor.constraint(equalTo: centerXAnchor),
                bufferIcon.heightAnchor.constraint(equalToConstant: 32),
                bufferIcon.widthAnchor.constraint(equalToConstant: 32)
            ]
        )

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
            videoSlider.bottomAnchor.constraint(equalTo: barControlsStackView.topAnchor, constant: 0),
            videoSlider.heightAnchor.constraint(equalToConstant: 10)
        ])

        videoSlider.addTarget(self, action: #selector(timeSliderSlide), for: .valueChanged)

        // MARK: Below seekbar

        let spacer = UIView()
        barControlsStackView.addArrangedSubview(timeIndicatorLabel)
        barControlsStackView.addArrangedSubview(spacer)
        barControlsStackView.addArrangedSubview(fullscreenButton)

        NSLayoutConstraint.activate([
           barControlsStackView.leftAnchor.constraint(equalTo: controlView.leftAnchor, constant: 14),
           barControlsStackView.rightAnchor.constraint(equalTo: controlView.rightAnchor, constant: -5),
           barControlsStackView.bottomAnchor.constraint(equalTo: controlView.bottomAnchor, constant: -8),
           barControlsStackView.heightAnchor.constraint(equalToConstant: 32)
        ])

        barControlsStackView.semanticContentAttribute = .forceLeftToRight
        barControlsStackView.setCustomSpacing(14, after: videoSlider)
        barControlsStackView.setCustomSpacing(5, after: timeIndicatorLabel)

        // Set a minimum width explicitly to prevent constant resizing of the seekbar when dragging it.
        timeIndicatorLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 50).isActive = true

        timeIndicatorLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
        timeIndicatorLabel.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        fullscreenButton.setContentHuggingPriority(.defaultLow, for: .horizontal)
        fullscreenButton.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)

        fullscreenButton.addTarget(self, action: #selector(fullscreenButtonTapped), for: .touchUpInside)

        addGestureRecognizer(tapGestureRecognizer)

        setControlViewVisibility(visible: true)
    }

    //MARK: - Methods

    func drawPlayer(with player: AVPlayer) {
        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.videoGravity = .resizeAspect
        playerLayer.needsDisplayOnBoundsChange = true
        self.playerLayer = playerLayer
        layer.addSublayer(playerLayer)
        playerLayer.frame = bounds

        bringSubviewToFront(overlayContainerView)
        bringSubviewToFront(controlAlphaView)
        bringSubviewToFront(controlView)
    }
}

// MARK: - Actions
extension VideoPlayerView {

    func setOnPlayButtonTapped(_ action: @escaping () -> Void) {
        onPlayButtonTapped = action
    }

    @objc private func playButtonTapped() {
        onPlayButtonTapped?()

        setControlViewVisibility(visible: true) // Debounce the hiding of the control view
    }

    func setOnSkipBackButtonTapped(_ action: @escaping () -> Void) {
        onSkipBackButtonTapped = action
    }

    @objc private func skipBackButtonTapped() {
        onSkipBackButtonTapped?()

        setControlViewVisibility(visible: true) // Debounce the hiding of the control view
    }

    func setOnSkipForwardButtonTapped(_ action: @escaping () -> Void) {
        onSkipForwardButtonTapped = action
    }

    @objc private func skipForwardButtonTapped() {
        onSkipForwardButtonTapped?()

        setControlViewVisibility(visible: true) // Debounce the hiding of the control view
    }

    func setOnFullscreenButtonTapped(_ action: @escaping () -> Void) {
        onFullscreenButtonTapped = action
    }

    @objc private func fullscreenButtonTapped() {
        onFullscreenButtonTapped?()

        setControlViewVisibility(visible: true) // Debounce the hiding of the control view
    }

    func setOnTimeSliderSlide(_ action: @escaping (Double) -> Void) {
        onTimeSliderSlide = action
    }

    @objc private func timeSliderSlide(_ sender: VideoProgressSlider) {
        onTimeSliderSlide?(sender.value)

        setControlViewVisibility(visible: true) // Debounce the hiding of the control view
    }

    @objc private func controlViewTapped() {
        toggleControlViewVisibility()
    }

    private func toggleControlViewVisibility() {
        setControlViewVisibility(visible: controlView.alpha <= 0)
    }

    private func setControlViewVisibility(visible: Bool) {
        if visible {
            controlViewDebouncer.debounce {
                UIView.animate(withDuration: 0.3) {
                    self.controlAlphaView.alpha = 0
                    self.controlView.alpha = 0
                }
            }
        }

        if (controlView.alpha <= 0) == visible {
            DispatchQueue.main.async {
                UIView.animate(withDuration: 0.15) {
                    self.controlAlphaView.alpha = visible ? 1 : 0
                    self.controlView.alpha = visible ? 1 : 0
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


public extension VideoPlayerView {
    override func pressesBegan(_ presses: Set<UIPress>, with event: UIPressesEvent?) {
        guard let buttonPress = presses.first?.type else { return }

        switch(buttonPress) {
        case .playPause:
            playButtonTapped()
        case .select:
            playButtonTapped()
        default:
            break
        }
    }
}
#endif
