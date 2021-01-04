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

    /// Should be implemented by the SDK user for IMA ads to be targetable to custom needs.
    /// This will populate the `custom_params` field in the IMA ad tag.
    /// If no extra parameters are needed, return an empty dictionary.
    func getCustomParameters(forItemIn videoPlayer: VideoPlayer) -> [String: String]

    /// Gets called when the video player starts playing an IMA ad.
    func imaAdStarted(for videoPlayer: VideoPlayer)

    /// Gets called when the video player stops playing an IMA ad.
    func imaAdStopped(for videoPlayer: VideoPlayer)
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

    var adsManager: IMAAdsManager!
    var adsLoader: IMAAdsLoader

    var adTagBaseURL: URL
    var adUnit: String?

    private var basicCustomParams: [String: String] = [:]
    private var adTagFactory = IMAAdTagFactory()

    init(videoPlayer: VideoPlayer, delegate: IMAIntegrationDelegate, adTagBaseURL: URL) {
        self.videoPlayer = videoPlayer
        self.delegate = delegate
        self.adTagBaseURL = adTagBaseURL

        // The adsLoader should be initialized as soon as it can, since it takes 1-2 seconds initialization time.
        adsLoader = IMAAdsLoader(settings: nil)!

        super.init()

        adsLoader.delegate = self
    }

    func setAVPlayer(_ avPlayer: AVPlayer) {
        self.avPlayer = avPlayer
    }

    func setBasicCustomParameters(eventId: String?, streamId: String?) {
        self.basicCustomParams = ["event_id": eventId ?? "", "stream_id": streamId ?? ""]
    }

    func setAdUnit(_ adUnit: String?) {
        self.adUnit = adUnit
    }

    func playPreroll() {
        guard let videoPlayer = videoPlayer, let delegate = delegate, let adUnit = adUnit, !adUnit.isEmpty else { return }
        // Create ad display container for ad rendering.
        let adDisplayContainer = IMAAdDisplayContainer(adContainer: videoPlayer.playerView, viewController: delegate.presentingViewController(for: videoPlayer))

        // Merge the basic custom parameters (event_id and stream_id, most likely), and collect any custom parameters desired by the SDK user.
        // We give precedence to the ones provided by the customer.
        let allCustomParameters = basicCustomParams.merging(delegate.getCustomParameters(forItemIn: videoPlayer)) { (_, new) in new }

        let request = IMAAdsRequest(
            adTagUrl: adTagFactory.buildTag(
                baseURL: adTagBaseURL,
                adUnit: adUnit,
                customParams: allCustomParameters),
            adDisplayContainer: adDisplayContainer,
            contentPlayhead: contentPlayhead,
            userContext: nil)

        adsLoader.requestAds(with: request)
    }

    func playPostroll() {
        adsLoader.contentComplete()
    }

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
        guard let videoPlayer = videoPlayer else { return }

        videoPlayer.pause()

        delegate?.imaAdStarted(for: videoPlayer)
    }

    func adsManagerDidRequestContentResume(_ adsManager: IMAAdsManager!) {
        guard let videoPlayer = videoPlayer else { return }

        delegate?.imaAdStopped(for: videoPlayer)

        videoPlayer.play()
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


