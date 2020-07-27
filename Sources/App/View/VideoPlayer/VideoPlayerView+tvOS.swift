//
// Copyright © 2020 mycujoo. All rights reserved.
//

#if os(tvOS)
import UIKit
import AVKit

public class VideoPlayerView: UIView  {

    // MARK: - Properties

    /// The AVPlayerLayer that is associated with this video player.
    private(set) public var playerLayer: AVPlayerLayer?
    
    private var onTimeSliderSlide: ((Double) -> Void)?
    private var onTimeSliderRelease: ((Double) -> Void)?
    private var onPlayButtonTapped: (() -> Void)?
    private var onSkipBackButtonTapped: (() -> Void)?
    private var onSkipForwardButtonTapped: (() -> Void)?
    private var onSelectPressed: (() -> Void)?
    private var onLeftArrowTapped: (() -> Void)?
    private var onRightArrowTapped: (() -> Void)?
    private var controlViewDebouncer = Debouncer(minimumDelay: 4.0)

    private var sliderValueChangedSinceTouchdown = false

    // MARK: - Internal properties

    /// The color that is used throughout various controls and elements of the video player, together with the `secondaryColor`.
    var primaryColor: UIColor = .white {
        didSet {
            playButton.tintColor = primaryColor
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

    var controlViewHasAlpha: Bool {
        return controlView.alpha > 0
    }

    /// Whether the infoView has an alpha value of more than zero (0) or not.
    var infoViewHasAlpha: Bool {
        return infoView.alpha > 0
    }

    // MARK: - UI Components

    lazy var bufferIcon: NVActivityIndicatorView = {
        let indicator = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 80, height: 80))
        indicator.color = .white
        indicator.type = .circleStrokeSpin
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()

    let playButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Play", for: .normal)
        return button
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
        button.layer.cornerRadius = 3
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        button.titleLabel?.textColor = .white
        button.alpha = 0
        button.contentEdgeInsets = UIEdgeInsets(top: 3, left: 6, bottom: 3, right: 6)
        return button
    }()

    private let controlAlphaView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
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
        view.isUserInteractionEnabled = false
        view.alpha = 0
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
        label.font = .boldSystemFont(ofSize: 28)
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
        label.font = .boldSystemFont(ofSize: 20)
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
        label.font = .systemFont(ofSize: 20)
        label.textColor = .white
        return label
    }()

    /// A dictionary of arrays, where each array is the set of constraints of a single overlay. These constraints should be
    /// copied when the UIView is exchanged for a newer one. The key is the `hash` of the UIView that the constraints belong to.
    var copyableOverlayConstraints: [Int: [NSLayoutConstraint]] = [:]

    //MARK: - Init

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
            infoTitleLabel.topAnchor.constraint(equalTo: infoView.topAnchor, constant: 20),
            infoTitleLabel.leadingAnchor.constraint(equalTo: infoView.leadingAnchor, constant: 20),
            infoTitleLabel.trailingAnchor.constraint(equalTo: infoView.trailingAnchor, constant: -20),

            infoDateLabel.topAnchor.constraint(equalTo: infoTitleLabel.bottomAnchor, constant: 10),
            infoDateLabel.leadingAnchor.constraint(equalTo: infoView.leadingAnchor, constant: 20),
            infoDateLabel.trailingAnchor.constraint(equalTo: infoView.trailingAnchor, constant: -20),

            infoDescriptionLabel.topAnchor.constraint(equalTo: infoDateLabel.bottomAnchor, constant: 30),
            infoDescriptionLabel.leadingAnchor.constraint(equalTo: infoView.leadingAnchor, constant: 20),
            infoDescriptionLabel.trailingAnchor.constraint(equalTo: infoView.trailingAnchor, constant: -20),
        ]

        for constraint in infoViewConstraints {
            constraint.priority = UILayoutPriority(rawValue: 748)
        }

        NSLayoutConstraint.activate(infoViewConstraints)

        let c = infoDescriptionLabel.bottomAnchor.constraint(lessThanOrEqualTo: infoView.bottomAnchor, constant: -20)
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

        controlAlphaView.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.7455710827)
        controlView.addSubview(timeIndicatorLabel)
        controlView.addSubview(liveButton)
        controlView.addSubview(videoSlider)

        NSLayoutConstraint
            .activate(
                [
                    videoSlider.leftAnchor.constraint(equalTo: controlView.leftAnchor, constant: 96),
                    videoSlider.rightAnchor.constraint(equalTo: controlView.rightAnchor, constant: -96),
                    videoSlider.bottomAnchor.constraint(equalTo: controlView.bottomAnchor, constant: -130),
                    videoSlider.heightAnchor.constraint(equalToConstant: 16)
                ]
        )
        videoSlider.addTarget(self, action: #selector(timeSliderTouchdown), for: .touchDown)
        videoSlider.addTarget(self, action: #selector(timeSliderSlide), for: .valueChanged)
        videoSlider.addTarget(self, action: #selector(timeSliderRelease), for: [.touchUpInside, .touchUpOutside])

        NSLayoutConstraint
            .activate(
                [
                    timeIndicatorLabel.leftAnchor.constraint(equalTo: controlView.leftAnchor, constant: 96),
                    timeIndicatorLabel.bottomAnchor.constraint(equalTo: controlView.bottomAnchor, constant: -96),

                    liveButton.leftAnchor.constraint(greaterThanOrEqualTo: timeIndicatorLabel.rightAnchor, constant: 96),
                    liveButton.rightAnchor.constraint(equalTo: controlView.rightAnchor, constant: -96),
                    liveButton.bottomAnchor.constraint(equalTo: controlView.bottomAnchor, constant: -96),
                ]
        )

        timeIndicatorLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
        timeIndicatorLabel.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
    }

    //MARK: - Methods

    func drawPlayer(with player: AVPlayer) {
        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.videoGravity = .resizeAspect
        self.playerLayer = playerLayer
        layer.addSublayer(playerLayer)
        playerLayer.frame = bounds

        bringSubviewToFront(safeView)
    }
}

// MARK: - Actions
extension VideoPlayerView {
    func setOnPlayButtonTapped(_ action: @escaping () -> Void) {
        onPlayButtonTapped = action
    }

    @objc private func playButtonTapped() {
        onPlayButtonTapped?()
    }

    func setOnSkipBackButtonTapped(_ action: @escaping () -> Void) {
        onSkipBackButtonTapped = action
    }

    private func skipBackButtonTapped() {
        onSkipBackButtonTapped?()
    }

    func setOnSkipForwardButtonTapped(_ action: @escaping () -> Void) {
        onSkipForwardButtonTapped = action
    }

    private func skipForwardButtonTapped() {
        onSkipForwardButtonTapped?()
    }

    @objc private func timeSliderTouchdown(_ sender: VideoProgressSlider) {
        sliderValueChangedSinceTouchdown = false
        videoSlider.ignoreTracking = false
    }

    func setOnTimeSliderSlide(_ action: @escaping (Double) -> Void) {
        onTimeSliderSlide = action
    }

    @objc private func timeSliderSlide(_ sender: VideoProgressSlider) {
        onTimeSliderSlide?(sender.value)

        sliderValueChangedSinceTouchdown = true
    }

    func setOnTimeSliderRelease(_ action: @escaping (Double) -> Void) {
        onTimeSliderRelease = action
    }

    @objc private func timeSliderRelease(_ sender: VideoProgressSlider) {
        if sliderValueChangedSinceTouchdown {
            onTimeSliderRelease?(sender.value)
        }
    }

    func setOnSelectPressed(_ action: @escaping () -> Void) {
        onSelectPressed = action
    }

    private func selectPressed() {
        videoSlider.ignoreTracking = true
        onSelectPressed?()
    }

    func setOnLeftArrowTapped(_ action: @escaping () -> Void) {
        onLeftArrowTapped = action
    }

    private func leftArrowTapped() {
        onLeftArrowTapped?()
    }

    func setOnRightArrowTapped(_ action: @escaping () -> Void) {
        onRightArrowTapped = action
    }

    private func rightArrowTapped() {
        onRightArrowTapped?()
    }

    func setControlViewVisibility(visible: Bool, animated: Bool) {
        if (!controlViewHasAlpha) == visible {
            DispatchQueue.main.async {
                UIView.animate(withDuration: animated ? 0.3 : 0) {
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
            playButton.setTitle("Play", for: .normal)
        case .pause:
            playButton.setTitle("Pause", for: .normal)
        case .replay:
            playButton.setTitle("Replay", for: .normal)
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

    func setBufferIcon(visible: Bool) {
        if visible {
            bufferIcon.startAnimating()
            bringSubviewToFront(bufferIcon)
        } else {
            sendSubviewToBack(bufferIcon)
            bufferIcon.stopAnimating()
        }
        bufferIcon.isHidden = !visible
    }

    /// Set the time indicator label as an attributed string. If elapsedText is nil, then an empty string is rendered on the entire label.
    func setTimeIndicatorLabel(elapsedText: String?, totalText: String?) {
        guard let elapsedText = elapsedText else {
            timeIndicatorLabel.text = ""
            return
        }

        let str1 = NSMutableAttributedString(string: elapsedText, attributes: [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18, weight: .bold).monospacedDigitFont,
            NSAttributedString.Key.foregroundColor: UIColor.white
        ])

        if let totalText = totalText {
            let str2 = NSMutableAttributedString(string: " / \(totalText)", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18, weight: .regular)])

            str1.append(str2)
        }

        timeIndicatorLabel.attributedText = str1
    }
}

public extension VideoPlayerView {
    override func pressesBegan(_ presses: Set<UIPress>, with event: UIPressesEvent?) {
        switch(presses.first?.type) {
        case .playPause?:
            playButtonTapped()
        case .select?:
            selectPressed()
        case .leftArrow?:
            leftArrowTapped()
        case .rightArrow?:
            rightArrowTapped()
        default:
            super.pressesBegan(presses, with: event)
        }
    }
}
#endif