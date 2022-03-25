//
//  File.swift
//  
//
//  Created by Mohammad on 03/03/2022.
//

import UIKit
import MLSSDK


class WithConcurrencyLimitViewController: UIViewController {
    private lazy var mls = MLS(publicKey: "", configuration: Configuration(logLevel: .verbose), useConcurrencyControl: true)
    
    lazy var videoPlayer: VideoPlayer = {
        let player = mls.videoPlayer()
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
            videoPlayer.delegate = self
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
        
        mls.dataProvider().eventList { [weak self] (events, _, _) in
            self?.videoPlayer.event = events?.first
        }
    }
}

extension WithConcurrencyLimitViewController: VideoPlayerDelegate {
    
    func playerConcurrencyLimitExceeded(eventId: String, limit: Int, player: VideoPlayer) {
        // TODO: Add your custom error message here
    }
    func playerDidUpdatePlaying(player: VideoPlayer) {
        
    }
    
    func playerDidUpdateTime(player: VideoPlayer) {
        
    }

    
    func playerDidUpdateState(player: VideoPlayer) {
        
    }
    
    func playerDidUpdateControlVisibility(toVisible: Bool, withAnimationDuration: Double, player: VideoPlayer) {
        
    }
    
    func playerDidUpdateStream(stream: MLSSDK.Stream?, player: VideoPlayer) {
        
    }
    
    func playerRequestsVideoAnalyticsCustomData() -> VideoAnalyticsCustomData? {
        return nil
    }
    
    func playerDidUpdateFullscreen(player: VideoPlayer) {
        
    }
}
