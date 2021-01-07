//
// Copyright © 2021 mycujoo. All rights reserved.
//

import Foundation
import MLSSDK
import GoogleCast
import AVFoundation


class CastPlayer: NSObject, CastPlayerProtocol {
    private static let encoder = JSONEncoder()

    override init() {}

    var isMuted: Bool = false

    var currentDuration: Double = 0

    var currentDurationAsCMTime: CMTime? = nil

    var currentTime: Double = 0

    var currentItem: AVPlayerItem? = nil

    var optimisticCurrentTime: Double = 0

    var isSeeking: Bool = false

    func play() {
        if let mediaStatus = GCKCastContext.sharedInstance().sessionManager.currentSession?.remoteMediaClient?.mediaStatus, let _ = mediaStatus.currentQueueItem {
            GCKCastContext.sharedInstance().sessionManager.currentSession?.remoteMediaClient?.play()
        }
    }

    func pause() {
        GCKCastContext.sharedInstance().sessionManager.currentSession?.remoteMediaClient?.pause()
    }

    func replaceCurrentItem(publicKey: String, pseudoUserId: String, event: MLSSDK.Event?, stream: MLSSDK.Stream?) {
        struct ReceiverCustomData: Codable {
            var publicKey: String
            var pseudoUserId: String
            var eventId: String?
        }

        let metadata = GCKMediaMetadata()
        metadata.setString(event?.title ?? "", forKey: kGCKMetadataKeyTitle)
        metadata.setString(event?.descriptionText ?? "", forKey: kGCKMetadataKeyTitle)

        let mediaInfoBuilder = GCKMediaInformationBuilder()
        // TODO: If we introduce Widevine, the streamUrl will need to be provided differently, since this uses Fairplay by default.
        mediaInfoBuilder.contentURL = stream?.url
        mediaInfoBuilder.streamType = .none
        mediaInfoBuilder.contentType = "video/m3u"
        mediaInfoBuilder.metadata = metadata
        mediaInfoBuilder.customData = []

        if let data = try? (CastPlayer.encoder.encode(ReceiverCustomData(publicKey: publicKey, pseudoUserId: pseudoUserId, eventId: event?.id))) {
            mediaInfoBuilder.customData = String(data: data, encoding: .utf8)!
        }

        GCKCastContext.sharedInstance().sessionManager.currentSession?.remoteMediaClient?.loadMedia(mediaInfoBuilder.build())
    }

    func seek(to time: CMTime, toleranceBefore: CMTime, toleranceAfter: CMTime, completionHandler: @escaping (Bool) -> Void) {
        let seekOptions = GCKMediaSeekOptions()
        seekOptions.interval = CMTimeGetSeconds(time)
        seekOptions.resumeState = .unchanged

        let request = GCKCastContext.sharedInstance().sessionManager.currentSession?.remoteMediaClient?.seek(with: seekOptions)
        let requestWrapper = CastGCKRequestHandler {} completionHandler: {
            completionHandler(true)
        } failureHandler: {
            completionHandler(false)
        } abortionHandler: {
            completionHandler(false)
        }

        // requestWrapper is not weakly retained because `CastGCKRequestHandler` statically retains it as long as needed.
        request?.delegate = requestWrapper
    }

    func seek(to time: CMTime, toleranceBefore: CMTime, toleranceAfter: CMTime, debounceSeconds: Double, completionHandler: @escaping (Bool) -> Void) {
        // TODO.

    }

    func seek(by amount: Double, toleranceBefore: CMTime, toleranceAfter: CMTime, debounceSeconds: Double, completionHandler: @escaping (Bool) -> Void) {
        // TODO
    }


}
