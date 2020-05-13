//
// Copyright © 2020 mycujoo. All rights reserved.
//

import UIKit
import MLSComponent

class ViewController: UIViewController {

    let videoPlayer: VideoPlayerView = {
        let player = VideoPlayerView()
        player.translatesAutoresizingMaskIntoConstraints = false
        return player
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white

        view.addSubview(videoPlayer)
        NSLayoutConstraint
            .activate(
                [
                    videoPlayer.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
                    videoPlayer.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                    videoPlayer.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                    videoPlayer.heightAnchor.constraint(equalTo: videoPlayer.widthAnchor, multiplier: 9 / 16)
                ]
        )

        videoPlayer.setup(withURL: URL(string: "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4")!)
    }
}
