//
// Copyright © 2020 mycujoo. All rights reserved.
//

import UIKit
import MLSComponent

class SimpleViewController: UIViewController {

    private lazy var mls = MLS(publicKey: "key", configuration: Configuration())

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
                videoPlayer.view.heightAnchor.constraint(equalTo: videoPlayer.view.widthAnchor, multiplier: 9 / 16),
                videoPlayer.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                videoPlayer.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                videoPlayer.view.bottomAnchor.constraint(lessThanOrEqualTo: view.bottomAnchor)
            ]

            NSLayoutConstraint.activate(playerConstraints)
        }
    }
}