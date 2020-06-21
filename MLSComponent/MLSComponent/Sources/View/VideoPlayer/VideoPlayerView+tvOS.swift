//
// Copyright © 2020 mycujoo. All rights reserved.
//

#if os(tvOS)
import UIKit
import AVKit

public class VideoPlayerView: UIView  {

    // MARK: - Properties

    private var playerLayer: AVPlayerLayer?
    private var onTimeSliderSlide: ((Double) -> Void)?
    private var onPlayButtonTapped: (() -> Void)?

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
            label.font = UIFont.monospacedSystemFont(ofSize: 24, weight: .regular)
        } else {
            label.font = UIFont(descriptor: UIFontDescriptor(name: "Menlo", size: 24), size: 24)
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
        drawControls(in: controlView)
        NSLayoutConstraint
            .activate(
                [
                    controlView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
                    controlView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
                    controlView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16),
                    controlView.heightAnchor.constraint(equalToConstant: 64)
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

    private func drawControls(in view: UIView) {

        view.addSubview(remainingTimeLabel)
        view.addSubview(videoSlider)

        NSLayoutConstraint
            .activate(
                [
                    videoSlider.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
                    videoSlider.centerYAnchor.constraint(equalTo: view.centerYAnchor),
                    videoSlider.heightAnchor.constraint(equalToConstant: 16)
                ]
        )
        videoSlider.addTarget(self, action: #selector(timeSliderSlide), for: .valueChanged)

        NSLayoutConstraint
            .activate(
                [
                    remainingTimeLabel.leadingAnchor.constraint(equalTo: videoSlider.trailingAnchor, constant: 24),
                    remainingTimeLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
                    remainingTimeLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
                    // Set a minimum width explicitly to prevent constant resizing of the seekbar when dragging it.
                    remainingTimeLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 120)
                ]
        )

        remainingTimeLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
        remainingTimeLabel.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)

        view.layer.cornerRadius = 16.0
        view.backgroundColor = #colorLiteral(red: 0.1098039216, green: 0.1098039216, blue: 0.1098039216, alpha: 0.8)
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
    func onPlayButtonTapped(_ action: @escaping () -> Void) {
        onPlayButtonTapped = action
    }

    @objc private func playButtonTapped() {
        onPlayButtonTapped?()
    }

    func onTimeSliderSlide(_ action: @escaping (Double) -> Void) {
        onTimeSliderSlide = action
    }

    @objc private func timeSliderSlide(_ sender: VideoProgressSlider) {
        onTimeSliderSlide?(sender.value)
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
