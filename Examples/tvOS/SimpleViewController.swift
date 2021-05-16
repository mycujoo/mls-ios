//
// Copyright © 2020 mycujoo. All rights reserved.
//

import Foundation
import UIKit
import MLSSDK
import MLSSDK_IMA
import MLSSDK_Annotations



class SimpleViewController: UIViewController {
    private lazy var mls = MLS(publicKey: "", configuration: Configuration(seekTolerance: .zero, playerConfig: PlayerConfig(imaAdUnit: "/124319096/external/single_ad_samples")))

    lazy var videoPlayer: VideoPlayer = {
        let player = mls.videoPlayer()
        player.imaIntegration = mls.prepare(IMAIntegrationFactory()).build(videoPlayer: player, delegate: self)
        player.annotationIntegration = mls.prepare(AnnotationIntegrationFactory()).build(delegate: self)
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

extension SimpleViewController: IMAIntegrationDelegate {
    func presentingView(for videoPlayer: VideoPlayer) -> UIView {
        return videoPlayer.playerView
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

extension SimpleViewController: AnnotationIntegrationDelegate {
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
