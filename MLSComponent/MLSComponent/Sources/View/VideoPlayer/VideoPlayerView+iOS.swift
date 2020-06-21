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

    // MARK: - UI Components

    var activityIndicatorView: UIActivityIndicatorView?

    private lazy var playIcon = UIImage(named: "Icon-PlayLarge", in: Bundle.resourceBundle, compatibleWith: nil)
    private lazy var pauseIcon = UIImage(named: "Icon-PauseLarge", in: Bundle.resourceBundle, compatibleWith: nil)
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
        label.font = UIFont.systemFont(ofSize: 13, weight: .semibold)
        label.text = "00:00"
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

    private let controlsBackground: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    // MARK: - Public accessors

    /// Sets the visibility of the fullscreen button.
    public var fullscreenButtonIsHidden: Bool = false {
        didSet {
            fullscreenButton.isHidden = fullscreenButtonIsHidden

            barControlsStackView.trailingAnchor.constraint(equalTo: controlsBackground.trailingAnchor, constant: fullscreenButtonIsHidden ? -14 : -5).isActive = true
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
        addSubview(controlsBackground)
        drawControls(in: controlsBackground)

        let viewConstraints = [
            controlsBackground.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0),
            controlsBackground.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0),
            controlsBackground.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0),
            controlsBackground.topAnchor.constraint(equalTo: topAnchor, constant: 0)
        ]

        let safeAreaConstraints = [
            controlsBackground.leadingAnchor.constraint(greaterThanOrEqualTo: safeAreaLayoutGuide.leadingAnchor, constant: 0),
            controlsBackground.trailingAnchor.constraint(greaterThanOrEqualTo: safeAreaLayoutGuide.trailingAnchor, constant: 0),
            controlsBackground.bottomAnchor.constraint(greaterThanOrEqualTo: safeAreaLayoutGuide.bottomAnchor, constant: 0),
            controlsBackground.topAnchor.constraint(greaterThanOrEqualTo: safeAreaLayoutGuide.topAnchor, constant: 0)
        ]

        for constraint in viewConstraints {
            constraint.priority = UILayoutPriority(rawValue: 998)
        }
        for constraint in safeAreaConstraints {
            constraint.priority = UILayoutPriority(rawValue: 999)
        }

        NSLayoutConstraint.activate(viewConstraints)
        NSLayoutConstraint.activate(safeAreaConstraints)
        
        let indicator = UIActivityIndicatorView()
        indicator.style = .white
        indicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicatorView = indicator
        addSubview(indicator)
        NSLayoutConstraint.activate(
            [
                indicator.centerYAnchor.constraint(equalTo: centerYAnchor),
                indicator.centerXAnchor.constraint(equalTo: centerXAnchor)
            ]
        )

        backgroundColor = .black
    }

    public override func layoutSubviews() {
        super.layoutSubviews()
        // TODO: This may be where the animation goes wrong.
        playerLayer?.frame = bounds
    }

    private func drawControls(in view: UIView) {
        // MARK: Basic setup

        view.backgroundColor = #colorLiteral(red: 0.1098039216, green: 0.1098039216, blue: 0.1098039216, alpha: 0.8)
        view.addSubview(barControlsStackView)

        // MARK: Play/pause button

        view.addSubview(playButton)
        playButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        playButton.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
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
                    barControlsStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 14),
                    barControlsStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -5),
                    barControlsStackView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -8),
                    barControlsStackView.heightAnchor.constraint(equalToConstant: 32)
                ])

        barControlsStackView.setCustomSpacing(14, after: videoSlider)
        barControlsStackView.setCustomSpacing(5, after: remainingTimeLabel)

        remainingTimeLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
        remainingTimeLabel.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        fullscreenButton.setContentHuggingPriority(.defaultLow, for: .horizontal)
        fullscreenButton.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)

        videoSlider.addTarget(self, action: #selector(timeSliderSlide), for: .valueChanged)
        fullscreenButton.addTarget(self, action: #selector(fullscreenButtonTapped), for: .touchUpInside)
    }

    //MARK: - Methods

    func drawPlayer(with player: AVPlayer) {
        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.videoGravity = .resizeAspect
        playerLayer.needsDisplayOnBoundsChange = true
        self.playerLayer = playerLayer
        layer.addSublayer(playerLayer)
        playerLayer.frame = bounds
        
        bringSubviewToFront(controlsBackground)
        activityIndicatorView?.startAnimating()
    }
}

// MARK: - Actions
extension VideoPlayerView {

    func onPlayButtonTapped(_ action: @escaping () -> Void) {
        onPlayButtonTapped = action
    }

    @objc private func playButtonTapped() {
        onPlayButtonTapped?()
    }

    func onFullscreenButtonTapped(_ action: @escaping () -> Void) {
        onFullscreenButtonTapped = action
    }

    @objc private func fullscreenButtonTapped() {
        onFullscreenButtonTapped?()
    }

    func onTimeSliderSlide(_ action: @escaping (Double) -> Void) {
        onTimeSliderSlide = action
    }

    @objc private func timeSliderSlide(_ sender: VideoProgressSlider) {
        onTimeSliderSlide?(sender.value)
    }

    func setPlayButtonTo(status: VideoPlayer.Status) {
        let icon: UIImage?
        switch status {
        case .play:
            icon = playIcon
        case .pause:
            icon = pauseIcon
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
