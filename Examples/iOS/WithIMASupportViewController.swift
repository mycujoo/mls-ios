//
// Copyright © 2021 mycujoo. All rights reserved.
//

import UIKit
import MLSSDK
import MLSSDK_IMA



class WithIMASupportViewController: UIViewController {

    private lazy var mls = MLS(publicKey: "", configuration: Configuration(playerConfig: PlayerConfig(imaAdUnit: "/124319096/external/single_ad_samples")), useFeaturedWebsocket: false)

    lazy var videoPlayer: VideoPlayer = {
        let player = mls.videoPlayer()
        player.imaIntegration = mls.prepare(IMAIntegrationFactory()).build(videoPlayer: player, delegate: self)
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

        if !didLayoutPlayerView, let playerView = videoPlayer.playerView {
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
        }

        mls.dataProvider().eventList(completionHandler: { [weak self] (events, _, _) in
            self?.videoPlayer.event = events?.first
        })
    }
}

extension WithIMASupportViewController: IMAIntegrationDelegate {
    func presentingView(for videoPlayer: VideoPlayer) -> UIView {
        return videoPlayer.playerView!
    }
    
    func presentingViewController(for videoPlayer: VideoPlayer) -> UIViewController? {
        return self
    }
    func getCustomParameters(forItemIn videoPlayer: VideoPlayer) -> [String : String] {
        return [:]
    }
    func imaAdStarted(for videoPlayer: VideoPlayer) {}

    func imaAdStopped(for videoPlayer: VideoPlayer) {}
}
