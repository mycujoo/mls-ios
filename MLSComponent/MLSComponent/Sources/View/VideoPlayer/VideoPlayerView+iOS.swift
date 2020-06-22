//
// Copyright © 2020 mycujoo. All rights reserved.
//

#if os(iOS)
import UIKit
import AVKit

public class VideoPlayerView: UIView  {

    // MARK: - Properties

    private var playerLayer: AVPlayerLayer?
    private var onTimeSliderSlide: ((Double) -> Void)?
    private var onPlayButtonTapped: (() -> Void)?
    private var onFullscreenButtonTapped: (() -> Void)?
    private var controlViewDebouncer = Debouncer(minimumDelay: 4.0)

    // MARK: - UI Components

    private lazy var playIcon = UIImage(named: "Icon-PlayLarge", in: Bundle.resourceBundle, compatibleWith: nil)
    private lazy var pauseIcon = UIImage(named: "Icon-PauseLarge", in: Bundle.resourceBundle, compatibleWith: nil)
    private lazy var replayIcon = UIImage(named: "Icon-ReplayLarge", in: Bundle.resourceBundle, compatibleWith: nil)
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
        let indicator = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        indicator.color = .white
        indicator.type = .circleStrokeSpin
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()

    let barControlsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fill
        return stackView
    }()

    let remainingTimeLabel: UILabel! = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        if #available(iOS 13.0, *) {
            label.font = UIFont.monospacedSystemFont(ofSize: 10, weight: .regular)
        } else {
            label.font = UIFont(descriptor: UIFontDescriptor(name: "Menlo", size: 10), size: 10)
        }
        label.text = "00:00"
        label.textAlignment = .center
        label.textColor = .white
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

    private let controlView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    // MARK: - Public accessors

    /// Sets the visibility of the fullscreen button.
    public var fullscreenButtonIsHidden: Bool = false {
        didSet {
            fullscreenButton.isHidden = fullscreenButtonIsHidden

            barControlsStackView.trailingAnchor.constraint(equalTo: controlView.trailingAnchor, constant: fullscreenButtonIsHidden ? -14 : -5).isActive = true
        }
    }

    /// Exposes the AVPlayerLayer's videoGravity property.
    public var videoGravity: AVLayerVideoGravity {
        get {
            return playerLayer?.videoGravity ?? .resizeAspect
        }
        set {
            playerLayer?.videoGravity = newValue
        }
    }

    /// Exposes the `UITapGestureRecognizer` on the VideoPlayerView, which is used to determine whether to hide or show the controls.
    public lazy var tapGestureRecognizer: UITapGestureRecognizer = {
        let gr = UITapGestureRecognizer(target: self, action: #selector(controlViewTapped))
        gr.numberOfTapsRequired = 1
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
        addSubview(controlView)
        addSubview(controlAlphaView)
        drawControls()

        let viewConstraints = [
            controlView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0),
            controlView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0),
            controlView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0),
            controlView.topAnchor.constraint(equalTo: topAnchor, constant: 0)
        ]

        let safeAreaConstraints = [
            controlView.leadingAnchor.constraint(greaterThanOrEqualTo: safeAreaLayoutGuide.leadingAnchor, constant: 0),
            controlView.trailingAnchor.constraint(lessThanOrEqualTo: safeAreaLayoutGuide.trailingAnchor, constant: 0),
            controlView.bottomAnchor.constraint(lessThanOrEqualTo: safeAreaLayoutGuide.bottomAnchor, constant: 0),
            controlView.topAnchor.constraint(greaterThanOrEqualTo: safeAreaLayoutGuide.topAnchor, constant: 0)
        ]

        let alphaConstraints = [
            controlAlphaView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0),
            controlAlphaView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0),
            controlAlphaView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0),
            controlAlphaView.topAnchor.constraint(equalTo: topAnchor, constant: 0)
        ]

        for constraint in viewConstraints {
            constraint.priority = UILayoutPriority(rawValue: 249)
        }
        for constraint in safeAreaConstraints {
            constraint.priority = UILayoutPriority(rawValue: 250)
        }
        for constraint in alphaConstraints {
            constraint.priority = UILayoutPriority(rawValue: 250)
        }

        NSLayoutConstraint.activate(viewConstraints)
        NSLayoutConstraint.activate(safeAreaConstraints)
        NSLayoutConstraint.activate(alphaConstraints)

        addSubview(bufferIcon)
        NSLayoutConstraint.activate(
            [
                bufferIcon.centerYAnchor.constraint(equalTo: centerYAnchor),
                bufferIcon.centerXAnchor.constraint(equalTo: centerXAnchor),
                bufferIcon.heightAnchor.constraint(equalToConstant: 40),
                bufferIcon.widthAnchor.constraint(equalToConstant: 40)
            ]
        )

        backgroundColor = .black
    }

    public override func layoutSubviews() {
        super.layoutSubviews()
        // TODO: This may be where the animation goes wrong.
        playerLayer?.frame = bounds
    }

    private func drawControls() {
        // MARK: Basic setup

        controlAlphaView.backgroundColor = #colorLiteral(red: 0.1098039216, green: 0.1098039216, blue: 0.1098039216, alpha: 0.5)
        controlView.addSubview(barControlsStackView)

        // MARK: Play/pause button

        controlView.addSubview(playButton)
        playButton.centerXAnchor.constraint(equalTo: controlView.centerXAnchor).isActive = true
        playButton.centerYAnchor.constraint(equalTo: controlView.centerYAnchor).isActive = true
        playButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        playButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
        playButton.addTarget(self, action: #selector(playButtonTapped), for: .touchUpInside)

        // MARK: Seekbar

        barControlsStackView.addArrangedSubview(videoSlider)
        barControlsStackView.addArrangedSubview(remainingTimeLabel)
        barControlsStackView.addArrangedSubview(fullscreenButton)

        NSLayoutConstraint
           .activate(
               [
                   barControlsStackView.leadingAnchor.constraint(equalTo: controlView.leadingAnchor, constant: 14),
                   barControlsStackView.trailingAnchor.constraint(equalTo: controlView.trailingAnchor, constant: -5),
                   barControlsStackView.bottomAnchor.constraint(equalTo: controlView.bottomAnchor, constant: -8),
                   barControlsStackView.heightAnchor.constraint(equalToConstant: 32)
               ])

        barControlsStackView.setCustomSpacing(14, after: videoSlider)
        barControlsStackView.setCustomSpacing(5, after: remainingTimeLabel)

        // Set a minimum width explicitly to prevent constant resizing of the seekbar when dragging it.
        remainingTimeLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 50).isActive = true

        remainingTimeLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
        remainingTimeLabel.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        fullscreenButton.setContentHuggingPriority(.defaultLow, for: .horizontal)
        fullscreenButton.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)

        videoSlider.addTarget(self, action: #selector(timeSliderSlide), for: .valueChanged)
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

        bringSubviewToFront(controlAlphaView)
        bringSubviewToFront(controlView)
        setBufferIcon(visible: true)
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
