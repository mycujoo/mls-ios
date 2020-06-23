//
// Copyright © 2020 mycujoo. All rights reserved.
//

import UIKit
import MLSComponent
import AVKit

class WithPictureInPictureViewController: UIViewController {

    private lazy var mls = MLS(publicKey: "key", configuration: Configuration())

    private var pictureInPictureController: AVPictureInPictureController? = nil

    private lazy var pipButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .white
        return button
    }()

    lazy var videoPlayer: VideoPlayer = {
        let player = mls
            .videoPlayer(
                with: Event(
                    id: "",
                    stream: Stream(
                        urls: .init(
                            URL(string: "https://playlists.mycujoo.football/eu/ck8u9ojpn1wzo0hewqpn7m054/master.m3u8")!
//                            URL(string: "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4")!
                        )
                    )
                )
        )
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

        if !didLayoutPlayerView {
            didLayoutPlayerView = true

            view.addSubview(videoPlayer.view)
            videoPlayer.view.translatesAutoresizingMaskIntoConstraints = false
            videoPlayer.view.fullscreenButtonIsHidden = true

            let playerConstraints = [
                videoPlayer.view.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
                // Note that this heightAnchor approach will not look good on some devices in landscape.
                // For a more complete solution, see `WithFullscreenZoomViewController.swift`
                videoPlayer.view.heightAnchor.constraint(equalTo: videoPlayer.view.widthAnchor, multiplier: 9 / 16),
                videoPlayer.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                videoPlayer.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                videoPlayer.view.bottomAnchor.constraint(lessThanOrEqualTo: view.bottomAnchor)
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

            videoPlayer.view.controlView.addSubview(pipButton)
            NSLayoutConstraint.activate(
                [
                    pipButton.topAnchor.constraint(equalTo: videoPlayer.view.controlView.topAnchor, constant: 12),
                    pipButton.trailingAnchor.constraint(equalTo: videoPlayer.view.controlView.trailingAnchor, constant: -12),
                    pipButton.heightAnchor.constraint(equalToConstant: 40),
                    pipButton.widthAnchor.constraint(equalToConstant: 40)
                ]
            )
            pipButton.addTarget(self, action: #selector(pipButtonTapped), for: .touchUpInside)
        }
    }

    // Taken from: https://developer.apple.com/documentation/avkit/adopting_picture_in_picture_in_a_custom_player
    func setupPictureInPicture() {
        // Ensure PiP is supported by current device.
        if AVPictureInPictureController.isPictureInPictureSupported(), let playerLayer = videoPlayer.view.playerLayer {
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