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

    var activityIndicatorView: UIActivityIndicatorView?

    let playButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Play", for: .normal)
        return button
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

    private let controlsBackground: UIView = {
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

        addSubview(controlsBackground)
        drawControls(in: controlsBackground)
        NSLayoutConstraint
            .activate(
                [
                    controlsBackground.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
                    controlsBackground.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
                    controlsBackground.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8),
                    controlsBackground.heightAnchor.constraint(equalToConstant: 32)
                ]
        )

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
        playerLayer?.frame = bounds
    }

    private func drawControls(in view: UIView) {

        view.addSubview(remainingTimeLabel)
        view.addSubview(videoSlider)

        NSLayoutConstraint
            .activate(
                [
                    videoSlider.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
                    videoSlider.centerYAnchor.constraint(equalTo: view.centerYAnchor),
                    videoSlider.heightAnchor.constraint(equalToConstant: 16)
                ]
        )
        videoSlider.addTarget(self, action: #selector(timeSliderSlide), for: .valueChanged)

        NSLayoutConstraint
            .activate(
                [
                    remainingTimeLabel.leadingAnchor.constraint(equalTo: videoSlider.trailingAnchor, constant: 8),
                    remainingTimeLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
                    remainingTimeLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8)
                ]
        )

        remainingTimeLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
        remainingTimeLabel.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)

        view.layer.cornerRadius = 8.0
        view.backgroundColor = #colorLiteral(red: 0.1098039216, green: 0.1098039216, blue: 0.1098039216, alpha: 0.8)
    }

    //MARK: - Methods

    func drawPlayer(with player: AVPlayer) {

        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.videoGravity = .resizeAspect
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
            playButton.setTitle("Play", for: .normal)
        case .pause:
            playButton.setTitle("Pause", for: .normal)
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
