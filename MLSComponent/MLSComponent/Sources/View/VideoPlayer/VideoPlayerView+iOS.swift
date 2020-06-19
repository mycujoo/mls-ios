//
// Copyright © 2020 mycujoo. All rights reserved.
//

#if os(iOS)
import UIKit
import AVKit

public class VideoPlayerView: UIView  {

    // MARK: - Properties

    private var playerLayer: AVPlayerLayer?
    private var isFullScreen = false
    private var onTimeSliderSlide: ((Double) -> Void)?
    private var onPlayButtonTapped: (() -> Void)?

    // MARK: - UI Components

    var activityIndicatorView: UIActivityIndicatorView?

    let playButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        if let image = UIImage(named: "Icon-PlayLarge", in: Bundle(for: VideoPlayerView.self), compatibleWith: nil) {
            button.setImage(image, for: .normal)
        }
        return button
    }()

    let pauseButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        if let image = UIImage(named: "Icon-PauseLarge", in: Bundle(for: VideoPlayerView.self), compatibleWith: nil) {
            button.setImage(image, for: .normal)
        }
        return button
    }()

    let currentTimeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 13, weight: .semibold)
        label.text = "00:00"
        label.textColor = .white
        return label
    }()

    let videoLengthLabel: UILabel! = {
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

    private let fullscreenButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .white
        if let image = UIImage(named: "Icon-Fullscreen", in: Bundle(for: VideoPlayerView.self), compatibleWith: nil) {
            button.setImage(image, for: .normal)
        }
        button.setTitle("Go fullscreen", for: .normal)
        return button
    }()

    private let shrinkscreenButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .white
        if let image = UIImage(named: "Icon-Shrinkscreen", in: Bundle(for: VideoPlayerView.self), compatibleWith: nil) {
            button.setImage(image, for: .normal)
        }
        return button
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
                    controlsBackground.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0),
                    controlsBackground.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0),
                    controlsBackground.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0),
                    controlsBackground.topAnchor.constraint(equalTo: topAnchor, constant: 0)
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

        view.addSubview(currentTimeLabel)
        view.addSubview(videoLengthLabel)
        view.addSubview(videoSlider)

        view.addSubview(playButton)
        playButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        playButton.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        playButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        playButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
        playButton.addTarget(self, action: #selector(playButtonTapped), for: .touchUpInside)

        currentTimeLabel.leadingAnchor.constraint(equalTo: playButton.trailingAnchor, constant: 8).isActive = true
        currentTimeLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        currentTimeLabel.widthAnchor.constraint(equalToConstant: 40).isActive = true

        NSLayoutConstraint
            .activate(
                [
                    videoSlider.leadingAnchor.constraint(equalTo: currentTimeLabel.trailingAnchor, constant: 8),
                    videoSlider.centerYAnchor.constraint(equalTo: view.centerYAnchor),
                    videoSlider.heightAnchor.constraint(equalToConstant: 16)
                ]
        )
        videoSlider.addTarget(self, action: #selector(timeSliderSlide), for: .valueChanged)

        NSLayoutConstraint
            .activate(
                [
                    videoLengthLabel.leadingAnchor.constraint(equalTo: videoSlider.trailingAnchor, constant: 8),
                    videoLengthLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
                    videoLengthLabel.widthAnchor.constraint(equalToConstant: 40)
                ]
        )

        view.addSubview(fullscreenButton)
        NSLayoutConstraint
            .activate(
                [
                    fullscreenButton.leadingAnchor.constraint(equalTo: videoLengthLabel.trailingAnchor, constant: 8),
                    fullscreenButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
                    fullscreenButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8)
                ]
        )
        fullscreenButton.addTarget(self, action: #selector(fullscreenButtonTapped), for: .touchUpInside)

        view.layer.cornerRadius = 8.0
        view.backgroundColor = #colorLiteral(red: 0.1098039216, green: 0.1098039216, blue: 0.1098039216, alpha: 0.8)
    }

    //MARK: - Methods

    func drawPlayer(with player: AVPlayer) {

        let playerLayer = AVPlayerLayer(player: player)
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

    @objc private func fullscreenButtonTapped() {
        isFullScreen.toggle()
        let newValue: UIInterfaceOrientation = isFullScreen ? .landscapeRight : .portrait
        UIDevice.current.setValue(newValue.rawValue, forKey: "orientation")
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
