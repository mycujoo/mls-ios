//
// Copyright © 2020 mycujoo. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit

public class VideoPlayerView: UIView  {

    // MARK: - Properties

    private var status: VideoPlayStatus = .pause
    private var player: AVPlayer?
    private var playerLayer: AVPlayerLayer?
    private var overlays: [Overlay: (NSLayoutConstraint, UIView)] = [:]
    private var isFullScreen = false

    // MARK: - UI Components

    private var activityIndicatorView: UIActivityIndicatorView?

    private let playButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        if #available(iOS 13.0, *) {
            button.setImage(UIImage(systemName: "play.fill"), for: .normal)
        }
        return button
    }()

    private let currentTimeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .preferredFont(forTextStyle: .footnote)
        return label
    }()

    private let videoLengthLabel: UILabel! = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .preferredFont(forTextStyle: .footnote)
        return label
    }()

    private let videoSlider: VideoProgressSlider = {
        let slider = VideoProgressSlider()
        slider.translatesAutoresizingMaskIntoConstraints = false
        return slider
    }()

    private let fullscreenButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        if #available(iOS 13.0, *) {
            button.setImage(UIImage(systemName: "shift.fill"), for: .normal)
        }
        return button
    }()

    private let controlsBackground: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .brown
        return view
    }()

    //MARK: - Init

    deinit {
        player?.removeObserver(self, forKeyPath: "currentItem.loadedTimeRanges")
    }

    public init() {
        super.init(frame: .zero)
        drawSelf()
    }

    required public init?(coder aDecoder: NSCoder) {
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
        
        videoSlider.addHighlight(moment: 0.3, color: .red)
        videoSlider.addHighlight(moment: 0.5, color: .black)
        videoSlider.addHighlight(moment: 0.7, color: .white)
    }

    public override func layoutSubviews() {
        super.layoutSubviews()
        playerLayer?.frame = bounds
    }

    private func drawControls(in view: UIView) {

        view.addSubview(playButton)
        view.addSubview(currentTimeLabel)
        view.addSubview(videoLengthLabel)
        view.addSubview(videoSlider)
        view.addSubview(fullscreenButton)

        NSLayoutConstraint
            .activate(
                [
                    playButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
                    playButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
                    playButton.widthAnchor.constraint(equalToConstant: 16),
                    playButton.heightAnchor.constraint(equalToConstant: 16)
                ]
        )
        playButton.addTarget(self, action: #selector(playButtonTapped), for: .touchUpInside)

        NSLayoutConstraint
            .activate(
                [
                    currentTimeLabel.leadingAnchor.constraint(equalTo: playButton.trailingAnchor, constant: 8),
                    currentTimeLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
                    currentTimeLabel.widthAnchor.constraint(equalToConstant: 40)
                ]
        )

        NSLayoutConstraint
            .activate(
                [
                    videoSlider.leadingAnchor.constraint(equalTo: currentTimeLabel.trailingAnchor, constant: 8),
                    videoSlider.centerYAnchor.constraint(equalTo: view.centerYAnchor),
                    videoSlider.heightAnchor.constraint(equalToConstant: 24)
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

        view.layer.cornerRadius = 8.0
        view.backgroundColor = .brown
    }

    //MARK: - Methods

    public func setup(withURL url: URL) {
        player = AVPlayer(url: url)
        drawPlayer()
    }

    private func drawPlayer() {

        let playerLayer = AVPlayerLayer(player: player)
        self.playerLayer = playerLayer
        layer.addSublayer(playerLayer)
        playerLayer.frame = bounds
        
        bringSubviewToFront(controlsBackground)
        activityIndicatorView?.startAnimating()

        trackTime()
        player?.addObserver(self, forKeyPath: "currentItem.loadedTimeRanges", options: .new, context: nil)
        
    }

    private func trackTime() {

        let interval = CMTime(value: 1, timescale: 2)
        player?.addPeriodicTimeObserver(forInterval: interval, queue: DispatchQueue.main, using: { (progressTime) in
            
            let seconds = CMTimeGetSeconds(progressTime)
            let secondsString = String(format: "%02d", Int(seconds.truncatingRemainder(dividingBy: 60)))
            let minutesString = String(format: "%02d", Int(seconds / 60))

            self.currentTimeLabel.text = "\(minutesString):\(secondsString)"

            //lets move the slider thumb
            if let duration = self.player?.currentItem?.duration, duration.value != 0 {
                let durationSeconds = CMTimeGetSeconds(duration)

                self.videoSlider.value = seconds / durationSeconds

            }
            
        })
    }

    //MARK: - KVO

    public override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {

        //this is when the player is ready and rendering frames
        guard keyPath == "currentItem.loadedTimeRanges" else { return }
        activityIndicatorView?.stopAnimating()
        guard let duration = player?.currentItem?.duration else { return }
        let seconds = CMTimeGetSeconds(duration)

        guard !seconds.isNaN else { return }
        let secondsText = String(format: "%02d", Int(seconds.truncatingRemainder(dividingBy: 60)))
        let minutesText = String(format: "%02d", Int(seconds) / 60)
        videoLengthLabel.text = "\(minutesText):\(secondsText)"
    }
}

// MARK: - Actions
extension VideoPlayerView {

    @objc func playButtonTapped() {

        status.setOpposite()
        
        if status.isPlaying {
            player?.play()
        } else {
            player?.pause()
        }
        if #available(iOS 13.0, *) {
            let image = status.isPlaying ? UIImage(systemName: "pause.fill") :UIImage(systemName: "play.fill")
            playButton.setImage(image, for: .normal)
        }
    }

    @objc func timeSliderSlide(_ sender: VideoProgressSlider) {

        var value = sender.value

        guard let player = player, let duration = player.currentItem?.duration, duration.value != 0 else {
            return
        }
        
        let totalSeconds = CMTimeGetSeconds(duration)
        
        value = Float64(value) * totalSeconds
        
        let seekTime = CMTime(value: Int64(value), timescale: 1)
        
        player.seek(to: seekTime, completionHandler: { (completedSeek) in
            //perhaps do something later here
        })
        
    }

    @objc func fullscreenButtonTapped() {
        isFullScreen.toggle()
        let newValue: UIInterfaceOrientation = isFullScreen ? .landscapeRight : .portrait
        UIDevice.current.setValue(newValue.rawValue, forKey: "orientation")
    }
}

// MARK: - Annotations
public extension VideoPlayerView {
    func showOverlay(_ overlay: Overlay) {

        let overlayView: UIView

        switch overlay.kind {
        case .singleLineText(let title):
            let singleLineView = SingleLineOverlayView()
            singleLineView.render(state: .init(title: title))
            overlayView = singleLineView
        case .doubleLineText:
            overlayView = UIView()
        case .scoreBoard:
            overlayView = UIView()
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
