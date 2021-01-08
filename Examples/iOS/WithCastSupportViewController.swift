//
// Copyright © 2021 mycujoo. All rights reserved.
//

import UIKit
import MLSSDK
import MLSSDK_Cast



class WithCastSupportViewController: UIViewController {

    private lazy var mls = MLS(publicKey: "", configuration: Configuration())

    lazy var castButtonParentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            view.widthAnchor.constraint(equalToConstant: 32),
            view.heightAnchor.constraint(equalToConstant: 32),
        ])
        return view
    }()

    lazy var videoPlayer: VideoPlayer = {
        let player = mls.videoPlayer()
        player.castIntegration = CastIntegrationFactory.build(delegate: self)
        player.topTrailingControlsStackView.insertArrangedSubview(castButtonParentView, at: 0)
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

extension WithCastSupportViewController: CastIntegrationDelegate {
    func getMiniControllerParentView() -> UIView? {
        return nil
    }

    func getCastButtonParentView() -> UIView {
        return castButtonParentView
    }
}