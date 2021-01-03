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
    public static func build(videoPlayer: VideoPlayer, delegate: IMAIntegrationDelegate, adTagBaseURL: URL = URL(string: "https://pubads.g.doubleclick.net/gampad/ads")!) -> IMAIntegration {
        return IMAIntegrationImpl(videoPlayer: videoPlayer, delegate: delegate, adTagBaseURL: adTagBaseURL)
    }
}

class IMAIntegrationImpl: NSObject, IMAIntegration {
    weak var videoPlayer: VideoPlayer?
    weak var avPlayer: AVPlayer?
    weak var delegate: IMAIntegrationDelegate?

    var adTagBaseURL: URL
    var adUnit: String?

    private var adTagFactory = IMAAdTagFactory()

    init(videoPlayer: VideoPlayer, delegate: IMAIntegrationDelegate, adTagBaseURL: URL) {
        self.videoPlayer = videoPlayer
        self.delegate = delegate
        self.adTagBaseURL = adTagBaseURL
    }

    func setAVPlayer(_ avPlayer: AVPlayer) {
        self.avPlayer = avPlayer
    }

    func newStreamLoaded(eventId: String?, streamId: String?) {
        guard let videoPlayer = videoPlayer, let adUnit = adUnit, !adUnit.isEmpty else { return }
        // Create ad display container for ad rendering.
        let adDisplayContainer = IMAAdDisplayContainer(adContainer: videoPlayer.playerView, viewController: delegate?.presentingViewController(for: videoPlayer))

        let request = IMAAdsRequest(
            adTagUrl: adTagFactory.buildTag(
                baseURL: adTagBaseURL,
                adUnit: adUnit,
                customParams: IMAAdTagFactory.AdInformation.CustomParams(
                    eventId: eventId,
                    streamId: streamId)),
            adDisplayContainer: adDisplayContainer,
            contentPlayhead: contentPlayhead,
            userContext: nil)

        adsLoader.requestAds(with: request)
    }

    func streamEnded() {
        adsLoader.contentComplete()
    }

    func newAdUnitLoaded(_ adUnit: String?) {
        self.adUnit = adUnit
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


