//
// Copyright © 2021 mycujoo. All rights reserved.
//

import UIKit
import MLSSDK
import MLSSDK_Annotations



class WithAnnotationSupportViewController: UIViewController {

    private lazy var mls = MLS(publicKey: "UPGTQCRI6EDNL38HNB63JQB04P3O8Q17", configuration: Configuration())

    lazy var videoPlayer: VideoPlayer = {
        let player = mls.videoPlayer()
        player.annotationIntegration = mls.prepare(AnnotationIntegrationFactory()).build(delegate: self)
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
            self?.videoPlayer.event = events?.filter { $0.id == "1qChhkajImF5NzMDKyL7zEKhGKt" }.first
        })
    }
}

extension WithAnnotationSupportViewController: AnnotationIntegrationDelegate {
    var annotationIntegrationView: AnnotationIntegrationView {
        videoPlayer.playerView
    }
    
    var currentDuration: Double {
        return videoPlayer.currentDuration
    }
    
    var optimisticCurrentTime: Double {
        return videoPlayer.optimisticCurrentTime
    }
}