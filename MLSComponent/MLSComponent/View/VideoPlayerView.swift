//
// Copyright © 2020 mycujoo. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit

public class VideoPlayerView: UIView  {

    private var status: VideoPlayStatus = .pause
    private var player: AVPlayer?
    private var playerLayer: AVPlayerLayer?

    private var controlsView: VideoPlayerControls!
    private var activityIndicatorView: UIActivityIndicatorView?

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

    private func drawSelf() {

        let controls = VideoPlayerControls()
        controls.translatesAutoresizingMaskIntoConstraints = false
        controlsView = controls
        controls.delegate = self
        
        addSubview(controls)
        NSLayoutConstraint
            .activate(
                [
                    controls.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
                    controls.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
                    controls.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8),
                    controls.heightAnchor.constraint(equalToConstant: 32)
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
        controlsView.setNeedsLayout()
        controlsView.layoutIfNeeded()
        
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
        
        bringSubviewToFront(controlsView)
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

            self.controlsView.currentTimeLabel.text = "\(minutesString):\(secondsString)"

            //lets move the slider thumb
            if let duration = self.player?.currentItem?.duration, duration.value != 0 {
                let durationSeconds = CMTimeGetSeconds(duration)

                self.controlsView.videoSlider.value = seconds / durationSeconds

            }
            
        })
    }

    //MARK: - KVO

    public override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {

        //this is when the player is ready and rendering frames
        guard keyPath == "currentItem.loadedTimeRanges" else {
            return
        }
        activityIndicatorView?.stopAnimating()
        guard let duration = player?.currentItem?.duration else {
            return
        }
        let seconds = CMTimeGetSeconds(duration)

        guard !seconds.isNaN else {
            return
        }

        if let range = player?.currentItem?.loadedTimeRanges.first {
            let downloadSeconds = CMTimeGetSeconds(CMTimeRangeGetEnd(range.timeRangeValue))
            controlsView.videoSlider.downloadProgress = downloadSeconds / seconds
        }

        let secondsText = String(format: "%02d", Int(seconds.truncatingRemainder(dividingBy: 60)))
        let minutesText = String(format: "%02d", Int(seconds) / 60)
        controlsView.videoLengthLabel.text = "\(minutesText):\(secondsText)"
    }
}

extension VideoPlayerView: VideoPlayerControlsDelegate {

    public func playButtonTapped() {

        status.setOpposite()
        
        if status.isPlaying {
            player?.play()
        } else {
            player?.pause()
        }
        
        controlsView.set(status: status)
        
    }

    public func timeSliderSlide(withValue value: Double) {

        guard let player = player, let duration = player.currentItem?.duration, duration.value != 0 else {
            return
        }
        
        let totalSeconds = CMTimeGetSeconds(duration)
        
        let value = Float64(value) * totalSeconds
        
        let seekTime = CMTime(value: Int64(value), timescale: 1)
        
        player.seek(to: seekTime, completionHandler: { (completedSeek) in
            //perhaps do something later here
        })
        
    }

    public func fullscreenButtonTapped() {
        print("need to be implemented")
        controlsView.set(status: .pause)
    }

    public func showFullscreenVideo(_ url: URL) {
        print("show full screen")
    }
}
