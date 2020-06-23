//
// Copyright © 2020 mycujoo. All rights reserved.
//

#if os(tvOS)
import UIKit
import AVKit

public class VideoPlayerView: UIView  {

    // MARK: - Properties

    /// The color that is used throughout various controls and elements of the video player.
    public var primaryColor: UIColor = .white {
        didSet {
            playButton.tintColor = primaryColor
            bufferIcon.color = primaryColor
            videoSlider.trackView.backgroundColor = primaryColor
        }
    }

    /// The AVPlayerLayer that is associated with this video player.
    private(set) public var playerLayer: AVPlayerLayer?
    
    private var onTimeSliderSlide: ((Double) -> Void)?
    private var onPlayButtonTapped: (() -> Void)?
    private var controlViewDebouncer = Debouncer(minimumDelay: 4.0)

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

    let remainingTimeLabel: UILabel! = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        if #available(tvOS 13.0, *) {
            label.font = UIFont.monospacedSystemFont(ofSize: 18, weight: .regular)
        } else {
            label.font = UIFont(descriptor: UIFontDescriptor(name: "Menlo", size: 18), size: 18)
        }
        label.text = "00:00"
        label.textAlignment = .left
        label.textColor = .white
        return label
    }()

    let videoSlider: VideoProgressSlider = {
        let slider = VideoProgressSlider()
        slider.translatesAutoresizingMaskIntoConstraints = false
        return slider
    }()

    private let controlView: UIView = {
        let view = UIView()
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

        addSubview(controlView)
        drawControls()
        NSLayoutConstraint
            .activate(
                [
                    controlView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0),
                    controlView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0),
                    controlView.topAnchor.constraint(equalTo: topAnchor, constant: 0),
                    controlView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0)
                ]
        )

        addSubview(bufferIcon)
        NSLayoutConstraint.activate(
            [
                bufferIcon.centerYAnchor.constraint(equalTo: centerYAnchor),
                bufferIcon.centerXAnchor.constraint(equalTo: centerXAnchor),
                bufferIcon.heightAnchor.constraint(equalToConstant: 80),
                bufferIcon.widthAnchor.constraint(equalToConstant: 80)
            ]
        )

        backgroundColor = .black
    }

    public override func layoutSubviews() {
        super.layoutSubviews()
        playerLayer?.frame = bounds
    }

    private func drawControls() {

        controlView.addSubview(remainingTimeLabel)
        controlView.addSubview(videoSlider)

        NSLayoutConstraint
            .activate(
                [
                    videoSlider.leadingAnchor.constraint(equalTo: controlView.leadingAnchor, constant: 96),
                    videoSlider.trailingAnchor.constraint(equalTo: controlView.trailingAnchor, constant: -96),
                    videoSlider.bottomAnchor.constraint(equalTo: remainingTimeLabel.topAnchor, constant: -12),
                    videoSlider.heightAnchor.constraint(equalToConstant: 16)
                ]
        )
        videoSlider.addTarget(self, action: #selector(timeSliderSlide), for: .valueChanged)

        NSLayoutConstraint
            .activate(
                [
                    remainingTimeLabel.leadingAnchor.constraint(equalTo: controlView.leadingAnchor, constant: 96),
                    remainingTimeLabel.trailingAnchor.constraint(greaterThanOrEqualTo: controlView.trailingAnchor, constant: -96),
                    remainingTimeLabel.bottomAnchor.constraint(equalTo: controlView.bottomAnchor, constant: -96)
                ]
        )

        remainingTimeLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
        remainingTimeLabel.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)

        controlView.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.5)
    }

    //MARK: - Methods

    func drawPlayer(with player: AVPlayer) {
        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.videoGravity = .resizeAspect
        self.playerLayer = playerLayer
        layer.addSublayer(playerLayer)
        playerLayer.frame = bounds

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
                    self.controlView.alpha = 0
                }
            }
        }

        if (controlView.alpha <= 0) == visible {
            DispatchQueue.main.async {
                UIView.animate(withDuration: 0.15) {
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
