//
// Copyright © 2020 mycujoo. All rights reserved.
//

import UIKit
import MLSPackage

class ViewController: UIViewController {

    private lazy var mls = MLS(publicKey: "key", configuration: Configuration())

    lazy var videoPlayer: VideoPlayerView = {
        let player = mls.videoPlayerView(
            with: Event(id: "",
                        streamURL: URL(string: "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4")!
            )
        )
        player.translatesAutoresizingMaskIntoConstraints = false
        return player
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white

        view.addSubview(videoPlayer)
        videoPlayer.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        videoPlayer.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        videoPlayer.heightAnchor.constraint(equalTo: videoPlayer.widthAnchor, multiplier: 9 / 16).isActive = true
        videoPlayer.bottomAnchor.constraint(lessThanOrEqualTo: view.bottomAnchor).isActive = true

        let leading = videoPlayer.leadingAnchor.constraint(equalTo: view.leadingAnchor)
        leading.priority = .defaultHigh
        leading.isActive = true

        let trailing = videoPlayer.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        trailing.priority = .defaultHigh
        trailing.isActive = true

//        videoPlayer.setup(withURL: URL(string: "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4")!)
//
//        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
//            self.videoPlayer.showOverlay(Overlay(id: "id", kind: .singleLineText("singleLineText"), side: .bottomRight, timestamp: 0))
//
//            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
//                self.videoPlayer.hideOverlay(with: "id")
//            }
//        }
    }
}
