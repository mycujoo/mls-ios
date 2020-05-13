//
// Copyright © 2020 mycujoo. All rights reserved.
//

import UIKit

class VideoPlayerControls: UIView {
    
    private let playButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        if #available(iOS 13.0, *) {
            button.setImage(UIImage(systemName: "play.fill"), for: .normal)
        }
        return button
    }()
    var currentTimeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .preferredFont(forTextStyle: .footnote)
        return label
    }()
    var videoLengthLabel: UILabel! = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .preferredFont(forTextStyle: .footnote)
        return label
    }()
    var videoSlider: VideoProgressSlider = {
        let slider = VideoProgressSlider()
        slider.translatesAutoresizingMaskIntoConstraints = false
        return slider
    }()
    var fullscreenButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        if #available(iOS 13.0, *) {
            button.setImage(UIImage(systemName: "shift.fill"), for: .normal)
        }
        return button
    }()
    
    weak var delegate: VideoPlayerControlsDelegate?
    
    //MARK: - Init
    
    public init() {
        super.init(frame: .zero)
        drawSelf()
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        drawSelf()
    }

    private func drawSelf() {

        addSubview(playButton)
        addSubview(currentTimeLabel)
        addSubview(videoLengthLabel)
        addSubview(videoSlider)
        addSubview(fullscreenButton)

        NSLayoutConstraint
            .activate(
                [
                    playButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
                    playButton.centerYAnchor.constraint(equalTo: centerYAnchor),
                    playButton.widthAnchor.constraint(equalToConstant: 16),
                    playButton.heightAnchor.constraint(equalToConstant: 16)
                ]
        )
        playButton.addTarget(self, action: #selector(playAction), for: .touchUpInside)

        NSLayoutConstraint
            .activate(
                [
                    currentTimeLabel.leadingAnchor.constraint(equalTo: playButton.trailingAnchor, constant: 8),
                    currentTimeLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
                    currentTimeLabel.widthAnchor.constraint(equalToConstant: 40)
                ]
        )

        NSLayoutConstraint
            .activate(
                [
                    videoSlider.leadingAnchor.constraint(equalTo: currentTimeLabel.trailingAnchor, constant: 8),
                    videoSlider.centerYAnchor.constraint(equalTo: centerYAnchor),
                    videoSlider.heightAnchor.constraint(equalToConstant: 16)
                ]
        )
        videoSlider.addTarget(self, action: #selector(sliderAction), for: .valueChanged)

        NSLayoutConstraint
            .activate(
                [
                    videoLengthLabel.leadingAnchor.constraint(equalTo: videoSlider.trailingAnchor, constant: 8),
                    videoLengthLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
                    videoLengthLabel.widthAnchor.constraint(equalToConstant: 40)
                ]
        )

        NSLayoutConstraint
            .activate(
                [
                    fullscreenButton.leadingAnchor.constraint(equalTo: videoLengthLabel.trailingAnchor, constant: 8),
                    fullscreenButton.centerYAnchor.constraint(equalTo: centerYAnchor),
                    fullscreenButton.widthAnchor.constraint(equalToConstant: 16),
                    fullscreenButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8)
                ]
        )
        fullscreenButton.addTarget(self, action: #selector(fullscreenAction), for: .touchUpInside)

        layer.cornerRadius = 8.0
        backgroundColor = .brown
    }
    
    //MARK: - Actions
    
    @objc private func playAction() {
        delegate?.playButtonTapped()
    }
    
    @objc func sliderAction(_ sender: VideoProgressSlider) {
        delegate?.timeSliderSlide(withValue: sender.value)
    }
    
    @objc func fullscreenAction(_ sender: Any) {
        delegate?.fullscreenButtonTapped()
    }
    
    //MARK: - Methods
    
    func set(status: VideoPlayStatus) {
        if #available(iOS 13.0, *) {
            let image = status.isPlaying ? UIImage(systemName: "pause.fill") :UIImage(systemName: "play.fill")
            playButton.setImage(image, for: .normal)
        }
    }
}
