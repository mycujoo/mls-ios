//
// Copyright © 2021 mycujoo. All rights reserved.
//

import Foundation
import AVFoundation
import UIKit
import GoogleInteractiveMediaAds
import MLSSDK


public protocol IMAIntegrationDelegate: class {
    /// Should be implemented by the SDK user for IMA ads to be displayable.
    /// - returns: The UIViewController that is presenting the `VideoPlayer`.
    func presentingViewController(for videoPlayer: VideoPlayer) -> UIViewController?
}

public class IMAIntegrationFactory {
    public static func build(videoPlayer: VideoPlayer, delegate: IMAIntegrationDelegate) -> IMAIntegration {
        return IMAIntegrationImpl(videoPlayer: videoPlayer, delegate: delegate)
    }
}

class IMAIntegrationImpl: NSObject, IMAIntegration {
    weak var videoPlayer: VideoPlayer?
    weak var avPlayer: AVPlayer?
    weak var delegate: IMAIntegrationDelegate?

    var imaTag: String?

    init(videoPlayer: VideoPlayer, delegate: IMAIntegrationDelegate) {
        self.videoPlayer = videoPlayer
        self.delegate = delegate
    }

    func setAVPlayer(_ avPlayer: AVPlayer) {
        self.avPlayer = avPlayer
    }

    func newStreamLoaded() {
        guard let videoPlayer = videoPlayer else { return }
        // Create ad display container for ad rendering.
        let adDisplayContainer = IMAAdDisplayContainer(adContainer: videoPlayer.playerView, viewController: delegate?.presentingViewController(for: videoPlayer))

        // Create an ad request with our ad tag, display container, and optional user context.
        let request = IMAAdsRequest(
            adTagUrl: imaTag,
            adDisplayContainer: adDisplayContainer,
            contentPlayhead: contentPlayhead,
            userContext: nil)

        adsLoader.requestAds(with: request)
    }

    func streamEnded() {
        adsLoader.contentComplete()
    }

    func newIMATagLoaded(_ imaTag: String?) {
        self.imaTag = imaTag
    }

    var adsManager: IMAAdsManager!
    lazy var adsLoader: IMAAdsLoader = {
        let loader = IMAAdsLoader(settings: nil)!
        loader.delegate = self
        return loader
    }()
    lazy var contentPlayhead: IMAAVPlayerContentPlayhead? = {
        return IMAAVPlayerContentPlayhead(avPlayer: avPlayer)
    }()

}

extension IMAIntegrationImpl: IMAAdsLoaderDelegate, IMAAdsManagerDelegate {
    func adsManager(_ adsManager: IMAAdsManager!, didReceive event: IMAAdEvent!) {
        if event.type == IMAAdEventType.LOADED {
            adsManager.start()
        }
    }

    func adsManager(_ adsManager: IMAAdsManager!, didReceive error: IMAAdError!) {
        print("AdsManager error: " + error.message)

        videoPlayer?.play()
    }

    func adsManagerDidRequestContentPause(_ adsManager: IMAAdsManager!) {
        videoPlayer?.pause()
    }

    func adsManagerDidRequestContentResume(_ adsManager: IMAAdsManager!) {
        videoPlayer?.play()
    }

    func adsLoader(_ loader: IMAAdsLoader!, adsLoadedWith adsLoadedData: IMAAdsLoadedData!) {
        adsManager = adsLoadedData.adsManager
        adsManager.delegate = self
        adsManager.initialize(with: nil)
    }

    func adsLoader(_ loader: IMAAdsLoader!, failedWith adErrorData: IMAAdLoadingErrorData!) {
        print("Error loading ads: " + adErrorData.adError.message)

        videoPlayer?.play()
    }
}
