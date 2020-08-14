//
// Copyright © 2020 mycujoo. All rights reserved.
//

import Foundation
import UIKit
import MLSSDK


class SimpleViewController: UIViewController {
    private lazy var mls = MLS(publicKey: "F20E0UNTM29R0K5A30JAAE2L87URF2VO", configuration: Configuration())

    lazy var videoPlayer: VideoPlayer = {
        let player = mls.videoPlayer()
        return player
    }()

    override func loadView() {
        view = videoPlayer.playerView
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        mls.dataProvider().eventList(completionHandler: { [weak self] (events) in
            self?.videoPlayer.event = events?.filter { $0.streams.compactMap { $0.fullUrl }.first != nil }.first
        })
    }
}
