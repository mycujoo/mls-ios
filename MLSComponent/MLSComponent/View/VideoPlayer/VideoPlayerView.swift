//
// Copyright © 2020 mycujoo. All rights reserved.
//

import UIKit
import AVKit

public class VideoPlayerView: UIView  {

    // MARK: - Properties

    private var playerLayer: AVPlayerLayer?
    private var overlays: [Overlay: (NSLayoutConstraint, UIView)] = [:]
    private var isFullScreen = false
    private var onTimeSliderSlide: ((Double) -> Void)?
    private var onPlayButtonTapped: (() -> Void)?

    // MARK: - UI Components

    var activityIndicatorView: UIActivityIndicatorView?

    let playButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        #if os(iOS)
        if #available(iOS 13.0, tvOS 13.0, *) {
            button.setImage(UIImage(systemName: "pause.fill"), for: .normal)
            button.tintColor = .white
        }
        #else
        button.setTitle("Play", for: .normal)
        #endif
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
        if #available(iOS 13.0, tvOS 13.0, *) {
            button.setImage(UIImage(systemName: "shift.fill"), for: .normal)
            button.tintColor = .white
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

        view.addSubview(currentTimeLabel)
        view.addSubview(videoLengthLabel)
        view.addSubview(videoSlider)

        #if os(iOS)
        view.addSubview(playButton)
        playButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8).isActive = true
        playButton.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        playButton.heightAnchor.constraint(equalToConstant: 16).isActive = true
        playButton.widthAnchor.constraint(equalToConstant: 16).isActive = true
        playButton.addTarget(self, action: #selector(playButtonTapped), for: .touchUpInside)
        #endif

        #if os(iOS)
        currentTimeLabel.leadingAnchor.constraint(equalTo: playButton.trailingAnchor, constant: 8).isActive = true
        #else
        currentTimeLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8).isActive = true
        #endif
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

        #if os(iOS)
        view.addSubview(fullscreenButton)
        NSLayoutConstraint
            .activate(
                [
                    fullscreenButton.leadingAnchor.constraint(equalTo: videoLengthLabel.trailingAnchor, constant: 8),
                    fullscreenButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
                    fullscreenButton.widthAnchor.constraint(equalToConstant: 16),
                    fullscreenButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8)
                ]
        )
        fullscreenButton.addTarget(self, action: #selector(fullscreenButtonTapped), for: .touchUpInside)
        #else
        videoLengthLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8).isActive = true
        #endif

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

    #if os(iOS)
    @objc private func fullscreenButtonTapped() {
        isFullScreen.toggle()
        let newValue: UIInterfaceOrientation = isFullScreen ? .landscapeRight : .portrait
        UIDevice.current.setValue(newValue.rawValue, forKey: "orientation")
    }
    #endif
}

// MARK: - Annotations
extension VideoPlayerView {
    func showOverlay(_ overlay: Overlay) {

        let overlayView: UIView

        switch overlay.kind {
        case .singleLineText(let title):
            let singleLineView = SingleLineOverlayView()
            singleLineView.render(state: .init(title: title))
            overlayView = singleLineView
        }
        overlayView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(overlayView)

        switch overlay.side {
        case .topLeft:
            overlayView.topAnchor.constraint(equalTo: topAnchor, constant: 12).isActive = true
            let leading = overlayView.leadingAnchor.constraint(equalTo: leadingAnchor)
            leading.isActive = true
            layoutIfNeeded()
            leading.constant = 40
            overlays[overlay] = (leading, overlayView)
        case .bottomLeft:
            overlayView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -44).isActive = true
            let leading = overlayView.leadingAnchor.constraint(equalTo: leadingAnchor)
            leading.isActive = true
            layoutIfNeeded()
            leading.constant = 40
            overlays[overlay] = (leading, overlayView)
        case .topRight:
            overlayView.topAnchor.constraint(equalTo: topAnchor, constant: 12).isActive = true
            let trailing = overlayView.trailingAnchor.constraint(equalTo: trailingAnchor)
            trailing.isActive = true
            layoutIfNeeded()
            trailing.constant = -40
            overlays[overlay] = (trailing, overlayView)
        case .bottomRight:
            overlayView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -44).isActive = true
            let trailing = overlayView.trailingAnchor.constraint(equalTo: trailingAnchor)
            trailing.isActive = true
            layoutIfNeeded()
            trailing.constant = -40
            overlays[overlay] = (trailing, overlayView)
        }
        UIView.animate(withDuration: 0.3, animations: layoutIfNeeded, completion: nil)
    }

    func hideOverlay(with id: String) {
        guard
            let overlay = overlays.keys.first(where: { $0.id == id }),
            let overlayView = overlays[overlay]?.1,
            let constraint = overlays[overlay]?.0
            else { return }

        switch overlay.side {
        case .topLeft:
            constraint.constant = -overlayView.bounds.width
        case .bottomLeft:
            constraint.constant = -overlayView.bounds.width
        case .topRight:
            constraint.constant = overlayView.bounds.width
        case .bottomRight:
            constraint.constant = overlayView.bounds.width
        }
        UIView.animate(withDuration: 0.5, animations: layoutIfNeeded) { _ in
            self.overlays.removeValue(forKey: overlay)
            overlayView.removeFromSuperview()
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
