//
// Copyright © 2021 mycujoo. All rights reserved.
//

import Foundation
import UIKit
import MLSSDK
import GoogleCast


public protocol CastIntegrationDelegate: class {
    /// Should be implemented by the SDK user. Should return a UIView to which this SDK can add the Google Cast mini-controller as a subview. Nil if the mini controller is not desired.
    func getMiniControllerParentView() -> UIView?

    /// Should be implemented by the SDK user. Should return a UIView to which this SDK can add the Google Cast button.
    /// - note:  It is recommended that the SDK user places this UIView inside the `topTrailingControlsStackView` UIStackView on the VideoPlayer.
    func getCastButtonParentView() -> UIView
}


public class CastIntegrationFactory {
    public static func build(delegate: CastIntegrationDelegate) -> CastIntegration {
        return CastIntegrationImpl(delegate: delegate)
    }
}

class CastIntegrationImpl: NSObject, CastIntegration, GCKLoggerDelegate {
    weak var videoPlayerDelegate: CastIntegrationVideoPlayerDelegate?
    weak var delegate: CastIntegrationDelegate?

    lazy var appId: String = {
        //        guard let appId = Bundle.mlsResourceBundle?.object(forInfoDictionaryKey: "CastAppId") as? String else {
        //            fatalError("Could not read Cast appId from Info.plist")
        //        }
        return castAppId
    }()

    private var _isCasting = false

    private static let encoder = JSONEncoder()

    init(delegate: CastIntegrationDelegate) {
        self.delegate = delegate

        super.init()
    }

    func initialize(_ videoPlayerDelegate: CastIntegrationVideoPlayerDelegate) {
        guard let delegate = delegate else { return }

        self.videoPlayerDelegate = videoPlayerDelegate

        let criteria = GCKDiscoveryCriteria(applicationID: appId)
        let options = GCKCastOptions(discoveryCriteria: criteria)
        options.physicalVolumeButtonsWillControlDeviceVolume = true
        GCKCastContext.setSharedInstanceWith(options)

        GCKLogger.sharedInstance().delegate = self
        GCKLogger.sharedInstance().loggingEnabled = false
        GCKLogger.sharedInstance().consoleLoggingEnabled = false
        let logFilter = GCKLoggerFilter()
        logFilter.minimumLevel = .none
        GCKLogger.sharedInstance().filter = logFilter

        GCKCastContext.sharedInstance().sessionManager.add(self)

        let castButton = GCKUICastButton(frame: CGRect(x: 0, y: 0, width: 24, height: 24))
        castButton.tintColor = UIColor.gray

        let castButtonParentView = delegate.getCastButtonParentView()
        castButtonParentView.addSubview(castButton)
        let castButtonConstraints = [
            castButton.leftAnchor.constraint(equalTo: castButtonParentView.leftAnchor),
            castButton.rightAnchor.constraint(equalTo: castButtonParentView.rightAnchor),
            castButton.topAnchor.constraint(equalTo: castButtonParentView.topAnchor),
            castButton.bottomAnchor.constraint(equalTo: castButtonParentView.bottomAnchor),
        ]
        for constraint in castButtonConstraints {
            constraint.priority = UILayoutPriority(rawValue: 749)
        }
        NSLayoutConstraint.activate(castButtonConstraints)

        #if DEBUG
        GCKLogger.sharedInstance().delegate = self
        #endif
    }

    func replaceCurrentItem(publicKey: String, pseudoUserId: String, event: MLSSDK.Event?, stream: MLSSDK.Stream?) {
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

        if let data = try? (CastIntegrationImpl.encoder.encode(ReceiverCustomData(publicKey: publicKey, pseudoUserId: pseudoUserId, eventId: event?.id))) {
            mediaInfoBuilder.customData = String(data: data, encoding: .utf8)!
        }

        GCKCastContext.sharedInstance().sessionManager.currentSession?.remoteMediaClient?.loadMedia(mediaInfoBuilder.build())
    }

    func play() {
        if let mediaStatus = GCKCastContext.sharedInstance().sessionManager.currentSession?.remoteMediaClient?.mediaStatus, let _ = mediaStatus.currentQueueItem {
            GCKCastContext.sharedInstance().sessionManager.currentSession?.remoteMediaClient?.play()
        }
    }

    func pause() {
        GCKCastContext.sharedInstance().sessionManager.currentSession?.remoteMediaClient?.pause()
    }

    func seek(to: Double, completionHandler: @escaping (Bool) -> Void) {
        let seekOptions = GCKMediaSeekOptions()
        seekOptions.interval = to
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

    func seek(by amount: Double, completionHandler: @escaping (Bool) -> Void) {

    }

    func isCasting() -> Bool {
        return _isCasting
    }

    struct ReceiverCustomData: Codable {
        var publicKey: String
        var pseudoUserId: String
        var eventId: String?
    }
}

// - MARK: GCKRemoteMediaClientListener

extension CastIntegrationImpl: GCKRemoteMediaClientListener {
    func remoteMediaClient(_ client: GCKRemoteMediaClient, didUpdate mediaStatus: GCKMediaStatus?) {
//        _mediaStatusUpdatedSubject.onNext(mediaStatus)
    }

    func remoteMediaClient(_ client: GCKRemoteMediaClient, didUpdate mediaMetadata: GCKMediaMetadata?) {
//        _metadataUpdatedSubject.onNext(mediaMetadata)
    }

    func remoteMediaClientDidUpdateQueue(_ client: GCKRemoteMediaClient) {

    }
}

// - MARK: GCKSessionManagerListener

extension CastIntegrationImpl: GCKSessionManagerListener {
    func sessionManager(_ sessionManager: GCKSessionManager, didStart session: GCKCastSession) {
            switchPlaybackToRemote()
        }

        func sessionManager(_ sessionManager: GCKSessionManager, didResumeCastSession session: GCKCastSession) {
            switchPlaybackToRemote()
        }

        func sessionManager(_ sessionManager: GCKSessionManager, willEnd session: GCKCastSession) {
            // Switch to local BEFORE the session ends, because it gives us a chance to stop playback BEFORE the connection is broken.
            switchPlaybackToLocal()
        }

        func sessionManager(_ sessionManager: GCKSessionManager, didEnd session: GCKCastSession, withError error: Error?) {
            // This should be redundant, but is useful as a safety measure.
            switchPlaybackToLocal()
        }

        func sessionManager(_ sessionManager: GCKSessionManager, didFailToStart session: GCKCastSession, withError error: Error) {
            switchPlaybackToLocal()
        }

        func switchPlaybackToLocal() {
            guard _isCasting else { return }
            _isCasting = false

            GCKCastContext.sharedInstance().sessionManager.currentSession?.remoteMediaClient?.remove(self)

            videoPlayerDelegate?.isCastingStateUpdated()
        }

        func switchPlaybackToRemote() {
            guard !_isCasting else { return }
            _isCasting = true

            GCKCastContext.sharedInstance().sessionManager.currentSession?.remoteMediaClient?.add(self)

            videoPlayerDelegate?.isCastingStateUpdated()

//            if let metadata = GCKCastContext.sharedInstance().sessionManager.currentSession?.remoteMediaClient?.mediaStatus?.mediaInformation?.metadata {
//                _metadataUpdatedSubject.onNext(metadata)
//            }
        }
}

// - MARK: GCKLoggerDelegate

extension CastIntegrationImpl {
    func logMessage(_ message: String, at level: GCKLoggerLevel, fromFunction function: String, location: String) {
        print(function + " - " + message)
    }
}
