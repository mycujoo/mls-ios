//
// Copyright © 2020 mycujoo. All rights reserved.
//

import UIKit
import MLSSDK
import AVKit

class WithPictureInPictureViewController: UIViewController {

    private lazy var mls = MLS(publicKey: "", configuration: Configuration(), useConcurrencyControl: false)

    private var pictureInPictureController: AVPictureInPictureController? = nil

    private lazy var pipButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .white
        return button
    }()

    lazy var videoPlayer: VideoPlayer = {
        let player = mls
            .videoPlayer()
        return player
    }()

    override var prefersHomeIndicatorAutoHidden: Bool {
        return true
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .black

        setupPictureInPicture()
    }

    private var didLayoutPlayerView = false
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        if !didLayoutPlayerView, let playerView = videoPlayer.playerView, let controlView = videoPlayer.controlView {
            didLayoutPlayerView = true

            view.addSubview(playerView)
            playerView.translatesAutoresizingMaskIntoConstraints = false

            let playerConstraints = [
                playerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
                // Note that this heightAnchor approach will not look good on some devices in landscape.
                // For a more complete solution, see `WithFullscreenZoomViewController.swift`
                playerView.heightAnchor.constraint(equalTo: playerView.widthAnchor, multiplier: 9 / 16),
                playerView.leftAnchor.constraint(equalTo: view.leftAnchor),
                playerView.rightAnchor.constraint(equalTo: view.rightAnchor),
                playerView.bottomAnchor.constraint(lessThanOrEqualTo: view.bottomAnchor)
            ]

            NSLayoutConstraint.activate(playerConstraints)

            // PIP setup

            if #available(iOS 13.0, *) {
                let startImage = AVPictureInPictureController.pictureInPictureButtonStartImage.withTintColor(.white)
                let stopImage = AVPictureInPictureController.pictureInPictureButtonStopImage.withTintColor(.white)
                pipButton.setImage(startImage, for: .normal)
                pipButton.setImage(stopImage, for: .selected)
            } else {
                // Fallback on earlier versions
            }

            videoPlayer.controlView?.addSubview(pipButton)
            NSLayoutConstraint.activate(
                [
                    pipButton.topAnchor.constraint(equalTo: controlView.topAnchor, constant: 12),
                    pipButton.rightAnchor.constraint(equalTo: controlView.rightAnchor, constant: -12),
                    pipButton.heightAnchor.constraint(equalToConstant: 40),
                    pipButton.widthAnchor.constraint(equalToConstant: 40)
                ]
            )
            pipButton.addTarget(self, action: #selector(pipButtonTapped), for: .touchUpInside)
        }

        mls.dataProvider().eventList(completionHandler: { [weak self] (events, _, _) in
            self?.videoPlayer.event = events?.first
        })
    }

    // Taken from: https://developer.apple.com/documentation/avkit/adopting_picture_in_picture_in_a_custom_player
    func setupPictureInPicture() {
        // Ensure PiP is supported by current device.
        if AVPictureInPictureController.isPictureInPictureSupported(), let playerLayer = videoPlayer.playerLayer {
            // Create a new controller, passing the reference to the AVPlayerLayer.
            pictureInPictureController = AVPictureInPictureController(playerLayer: playerLayer)
            pictureInPictureController?.delegate = self

            let _ = pictureInPictureController?.observe(\AVPictureInPictureController.isPictureInPicturePossible, options: [.initial, .new]) { [weak self] prop, change in
                // Update the PiP button's enabled state.
//                self?.pipButton.isEnabled = change.newValue ?? false
                // TODO: On simulators, the updated state isn't always correct. For this demo, always leave isEnabled to true here.
                self?.pipButton.isEnabled = true
            }
        } else {
            // PiP isn't supported by the current device. Disable the PiP button.
            pipButton.isEnabled = false
        }
    }

    @objc func pipButtonTapped() {
        guard let pictureInPictureController = pictureInPictureController else { return }
        if pictureInPictureController.isPictureInPictureActive {
            pictureInPictureController.stopPictureInPicture()
        } else {
            pictureInPictureController.startPictureInPicture()
        }
    }
}

extension WithPictureInPictureViewController: AVPictureInPictureControllerDelegate {}
