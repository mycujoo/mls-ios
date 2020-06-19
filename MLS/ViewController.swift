//
// Copyright © 2020 mycujoo. All rights reserved.
//

import UIKit
import MLSComponent

class ViewController: UIViewController {

    private lazy var mls = MLS(publicKey: "key", configuration: Configuration())

    lazy var videoPlayer: VideoPlayer = {
        let player = mls
            .videoPlayer(
                with: Event(
                    id: "",
                    stream: Stream(
                        urls: .init(
                            URL(string: "https://playlists.mycujoo.football/eu/ckb97qegxz7x00hewfdaghqhh/master.m3u8")!
//                            URL(string: "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4")!
                        )
                    )
                )
        )
        return player
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        videoPlayer.delegate = self
        view.backgroundColor = .white
        videoPlayer.placePlayerView(in: view)
    }
}

// MARK: - PlayerDelegate
extension ViewController: PlayerDelegate {
    func playerDidUpdatePlaying(player: VideoPlayer) {
        print("new status: ", player.status)
    }

    func playerDidUpdateTime(player: VideoPlayer) {
        print("new time: ", player.currentTime)
    }

    func playerDidUpdateState(player: VideoPlayer) {
        print("new state: ", player.state)
    }

    func playerDidUpdateAnnotations(player: VideoPlayer) {
        print("new annotations: ", player.annotations)
    }
}
