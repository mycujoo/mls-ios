//
// Copyright © 2020 mycujoo. All rights reserved.
//

import Foundation
import UIKit
import MLSSDK


class SimpleViewController: UIViewController {
    private lazy var mls = MLS(publicKey: "", configuration: Configuration())

    lazy var videoPlayer: VideoPlayer = {
        let player = mls.videoPlayer()
        return player
    }()

    override func loadView() {
        view = videoPlayer.playerView
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        mls.dataProvider().eventList(completionHandler: { [weak self] (events, _, _) in
            self?.videoPlayer.event = events?.first
        })
    }
}
