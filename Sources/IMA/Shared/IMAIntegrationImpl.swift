//
// Copyright © 2021 mycujoo. All rights reserved.
//

import Foundation
import AVFoundation
import UIKit
import GoogleInteractiveMediaAds
import MLSSDK


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

    /// A helper to keep track of whether an ad is currently playing or not.
    private var isShowingAd_ = false

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

    func setBasicCustomParameters(eventId: String?, streamId: String?, eventStatus: MLSSDK.EventStatus?) {
        let eventStatus_: String
        if let eventStatus = eventStatus {
            switch eventStatus {
            case .scheduled:
                eventStatus_ = "scheduled"
            case .rescheduled:
                eventStatus_ = "rescheduled"
            case .cancelled:
                eventStatus_ = "cancelled"
            case .postponed:
                eventStatus_ = "postponed"
            case .delayed:
                eventStatus_ = "delayed"
            case .started:
                eventStatus_ = "started"
            case .paused:
                eventStatus_ = "paused"
            case .suspended:
                eventStatus_ = "suspended"
            case .finished:
                eventStatus_ = "finished"
            case .unspecified:
                eventStatus_ = "unspecified"
            }
        } else {
            eventStatus_ = ""
        }

        self.basicCustomParams = ["event_id": eventId ?? "", "stream_id": streamId ?? "", "event_status": eventStatus_]
    }

    func setAdUnit(_ adUnit: String?) {
        self.adUnit = adUnit
    }

    func playPreroll() {
        guard let videoPlayer = videoPlayer else { return }
        guard let delegate = delegate, let adUnit = adUnit, !adUnit.isEmpty else {
            videoPlayer.play()
            return
        }
        // Create ad display container for ad rendering.
        let adDisplayContainer = IMAAdDisplayContainer(adContainer: delegate.presentingView(for: videoPlayer), viewController: delegate.presentingViewController(for: videoPlayer))

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

    func isShowingAd() -> Bool {
        return isShowingAd_
    }
    
    func adIsPaused() -> Bool {
        return isShowingAd_ && !adsManager.adPlaybackInfo.isPlaying
    }

    func pause() {
        adsManager.pause()
    }

    func resume() {
        adsManager.resume()
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

        isShowingAd_ = false

        videoPlayer?.play()
    }

    func adsManagerDidRequestContentPause(_ adsManager: IMAAdsManager!) {
        guard let videoPlayer = videoPlayer else { return }

        videoPlayer.pause()

        isShowingAd_ = true
        delegate?.imaAdStarted(for: videoPlayer)
    }

    func adsManagerDidRequestContentResume(_ adsManager: IMAAdsManager!) {
        guard let videoPlayer = videoPlayer else { return }

        isShowingAd_ = false
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

        isShowingAd_ = false

        videoPlayer?.play()
    }
}


