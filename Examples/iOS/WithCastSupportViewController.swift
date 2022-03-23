//
// Copyright © 2021 mycujoo. All rights reserved.
//

import UIKit
import GoogleCast
import MLSSDK
import MLSSDK_Cast



class WithCastSupportViewController: UIViewController {

    private lazy var mls = MLS(publicKey: "", configuration: Configuration(), useFeaturedWebsocket: false)

    lazy var castButtonParentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            view.widthAnchor.constraint(equalToConstant: 40),
            view.heightAnchor.constraint(equalToConstant: 40),
        ])
        return view
    }()

    lazy var videoPlayer: VideoPlayer = {
        let player = mls.videoPlayer()
        player.castIntegration = mls.prepare(CastIntegrationFactory()).build(delegate: self)
        player.topTrailingControlsStackView?.insertArrangedSubview(castButtonParentView, at: 0)
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

extension WithCastSupportViewController: CastIntegrationDelegate {
    func getCastButtonParentViews() -> [(parentView: UIView, tintColor: UIColor)] {
        return [(parentView: castButtonParentView, tintColor: .white)]
    }
}
