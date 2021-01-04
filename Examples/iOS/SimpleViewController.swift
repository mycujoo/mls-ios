//
// Copyright © 2020 mycujoo. All rights reserved.
//

import UIKit
import MLSSDK
import MLSSDK_IMA_iOS



class SimpleViewController: UIViewController {

    private lazy var mls = MLS(publicKey: "", configuration: Configuration())

    lazy var videoPlayer: VideoPlayer = {
        let player = mls.videoPlayer()
        player.imaIntegration = IMAIntegrationFactory.build(videoPlayer: player, delegate: self)
        return player
    }()

    override var prefersHomeIndicatorAutoHidden: Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .black
    }

    private var didLayoutPlayerView = false
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        if !didLayoutPlayerView {
            didLayoutPlayerView = true

            view.addSubview(videoPlayer.playerView)
            videoPlayer.playerView.translatesAutoresizingMaskIntoConstraints = false

            let playerConstraints = [
                videoPlayer.playerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
                // Note that this heightAnchor approach will not look good on some devices in landscape.
                // For a more complete solution, see `WithFullscreenZoomViewController.swift`
                videoPlayer.playerView.heightAnchor.constraint(equalTo: videoPlayer.playerView.widthAnchor, multiplier: 9 / 16),
                videoPlayer.playerView.leftAnchor.constraint(equalTo: view.leftAnchor),
                videoPlayer.playerView.rightAnchor.constraint(equalTo: view.rightAnchor),
                videoPlayer.playerView.bottomAnchor.constraint(lessThanOrEqualTo: view.bottomAnchor)
            ]

            NSLayoutConstraint.activate(playerConstraints)
        }

        mls.dataProvider().eventList(completionHandler: { [weak self] (events, _, _) in
            self?.videoPlayer.event = events?.first
        })
    }
}

extension SimpleViewController: IMAIntegrationDelegate {
    func presentingViewController(for videoPlayer: VideoPlayer) -> UIViewController? {
        return self
    }
    func imaAdStarted(for videoPlayer: VideoPlayer) {}

    func imaAdStopped(for videoPlayer: VideoPlayer) {}
}
