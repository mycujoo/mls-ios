//
// Copyright © 2021 mycujoo. All rights reserved.
//

import Foundation
import UIKit
import AVKit
import MLSSDK
import MLSSDK_IMA
import MLSSDK_Annotations



class WithAVPlayerViewController: AVPlayerViewController {
    private lazy var mls = MLS(publicKey: "", configuration: Configuration(seekTolerance: .zero, playerConfig: PlayerConfig(imaAdUnit: "/124319096/external/single_ad_samples")))

    lazy var videoPlayer: VideoPlayer = {
        let player = mls.videoPlayer(attachView: false)
        player.delegate = self
        player.imaIntegration = mls.prepare(IMAIntegrationFactory()).build(videoPlayer: player, delegate: self)
        player.annotationIntegration = mls.prepare(AnnotationIntegrationFactory()).build(delegate: self)
        return player
    }()
    
    var annotationIntegrationView_: AnnotationIntegrationView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let contentOverlayView = self.contentOverlayView {
            let v = AnnotationIntegrationViewImpl()
            v.translatesAutoresizingMaskIntoConstraints = false
            contentOverlayView.addSubview(v)
            
            NSLayoutConstraint.activate([
                v.leadingAnchor.constraint(equalTo: contentOverlayView.leadingAnchor),
                v.trailingAnchor.constraint(equalTo: contentOverlayView.trailingAnchor),
                v.topAnchor.constraint(equalTo: contentOverlayView.topAnchor),
                v.bottomAnchor.constraint(equalTo: contentOverlayView.bottomAnchor)
            ])
            
            self.annotationIntegrationView_ = v
        }
        
        self.player = videoPlayer.avPlayer
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        mls.dataProvider().eventList(completionHandler: { [weak self] (events, _, _) in
            self?.videoPlayer.event = events?.first
        })
    }
}

extension WithAVPlayerViewController: IMAIntegrationDelegate {
    func presentingView(for videoPlayer: VideoPlayer) -> UIView {
        return self.view
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

extension WithAVPlayerViewController: AnnotationIntegrationDelegate {
    var annotationIntegrationView: AnnotationIntegrationView {
        return annotationIntegrationView_
    }
    
    var currentDuration: Double {
        return videoPlayer.currentDuration
    }
    
    var optimisticCurrentTime: Double {
        return videoPlayer.optimisticCurrentTime
    }
}

// MARK: - PlayerDelegate
extension WithAVPlayerViewController: VideoPlayerDelegate {
    func playerDidUpdateStream(stream: MLSSDK.Stream?, player: VideoPlayer) {
        if let errorCode = stream?.error?.code {
            switch errorCode {
            case .geoblocked:
                // Show a geoblocked message to your users.
                break
            case .missingEntitlement:
                // Show a missing entitlement message to your users.
                break
            default:
                // Show a general error message.
                break
            }
        }
    }
    
    func playerDidUpdateControlVisibility(toVisible: Bool, withAnimationDuration: Double, player: VideoPlayer) {}

    func playerDidUpdatePlaying(player: VideoPlayer) {}

    func playerDidUpdateTime(player: VideoPlayer) {}

    func playerDidUpdateState(player: VideoPlayer) {}

    func playerDidUpdateFullscreen(player: VideoPlayer) {}
}


class AnnotationIntegrationViewImpl: UIView, AnnotationIntegrationView {
    private var overlayContainerView_: UIView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(v)
        
        NSLayoutConstraint.activate([
            v.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            v.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            v.topAnchor.constraint(equalTo: self.topAnchor),
            v.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
        
        self.overlayContainerView_ = v
    }
    
    var overlayContainerView: UIView {
        return overlayContainerView_
    }
     
    func setTimelineMarkers(with actions: [MLSUI.ShowTimelineMarkerAction]) {
        // Not implemented.
    }
}
