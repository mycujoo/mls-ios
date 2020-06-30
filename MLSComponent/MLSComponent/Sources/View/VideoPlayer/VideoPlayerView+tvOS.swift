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
    private var onPlayButtonTapped: (() -> Void)?
    private var controlViewDebouncer = Debouncer(minimumDelay: 4.0)

    /// A dictionary of dynamic overlays currently showing within this view. Keys are the overlay identifiers.
    /// The UIView should be the outer container of the overlay, not the SVGView directly.
    var overlays: [String: UIView] = [:]

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

    private let controlView: UIView = {
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
            controlAlphaView.topAnchor.constraint(equalTo: topAnchor, constant: 0)
        ]

        for constraint in constraints {
            constraint.priority = UILayoutPriority(rawValue: 750)
        }

        NSLayoutConstraint.activate(constraints)

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
        controlView.addSubview(videoSlider)

        NSLayoutConstraint
            .activate(
                [
                    videoSlider.leftAnchor.constraint(equalTo: controlView.leftAnchor, constant: 96),
                    videoSlider.rightAnchor.constraint(equalTo: controlView.rightAnchor, constant: -96),
                    videoSlider.bottomAnchor.constraint(equalTo: timeIndicatorLabel.topAnchor, constant: -12),
                    videoSlider.heightAnchor.constraint(equalToConstant: 16)
                ]
        )
        videoSlider.addTarget(self, action: #selector(timeSliderSlide), for: .valueChanged)

        NSLayoutConstraint
            .activate(
                [
                    timeIndicatorLabel.leftAnchor.constraint(equalTo: controlView.leftAnchor, constant: 96),
                    timeIndicatorLabel.rightAnchor.constraint(greaterThanOrEqualTo: controlView.rightAnchor, constant: -96),
                    timeIndicatorLabel.bottomAnchor.constraint(equalTo: controlView.bottomAnchor, constant: -96)
                ]
        )

        timeIndicatorLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
        timeIndicatorLabel.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)

        setControlViewVisibility(visible: true)
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

        setControlViewVisibility(visible: true) // Debounce the hiding of the control view
    }

    func setOnTimeSliderSlide(_ action: @escaping (Double) -> Void) {
        onTimeSliderSlide = action
    }

    @objc private func timeSliderSlide(_ sender: VideoProgressSlider) {
        onTimeSliderSlide?(sender.value)

        setControlViewVisibility(visible: true) // Debounce the hiding of the control view
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
            playButton.setTitle("Play", for: .normal)
        case .pause:
            playButton.setTitle("Pause", for: .normal)
        case .replay:
            playButton.setTitle("Replay", for: .normal)
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
