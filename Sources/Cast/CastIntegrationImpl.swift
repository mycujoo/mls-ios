//
// Copyright © 2021 mycujoo. All rights reserved.
//

import Foundation
import UIKit
import MLSSDK
import GoogleCast


class CastIntegrationImpl: NSObject, CastIntegration, GCKLoggerDelegate {
    private static var wasPreviouslyInitialized = false

    weak var videoPlayerDelegate: CastIntegrationVideoPlayerDelegate?
    weak var delegate: CastIntegrationDelegate?

    private var _isCasting = false {
        didSet {
            delegate?.castingStateChanged(to: _isCasting)
        }
    }
    private var _player = CastPlayer()

    private let appId: String

    /// - note: `customReceiverAppId` only has any effect on the first initialization of this class, since that is when the Chromecast context is built.
    ///   On initializations after that, the existing Chromecast context is used, and so this will not have any effect.
    init(delegate: CastIntegrationDelegate, customReceiverAppId: String?) {
        self.delegate = delegate
        self.appId = customReceiverAppId ?? castAppId

        super.init()
    }

    deinit {
        GCKCastContext.sharedInstance().sessionManager.currentSession?.remoteMediaClient?.remove(self)
        GCKCastContext.sharedInstance().sessionManager.remove(self)
    }

    func initialize(_ videoPlayerDelegate: CastIntegrationVideoPlayerDelegate) {
        guard let delegate = delegate else { return }

        self.videoPlayerDelegate = videoPlayerDelegate

        if !CastIntegrationImpl.wasPreviouslyInitialized {
            CastIntegrationImpl.wasPreviouslyInitialized = true

            // This shared instance setup should only be done once in the lifetime of the app.
            let criteria = GCKDiscoveryCriteria(applicationID: appId)
            let options = GCKCastOptions(discoveryCriteria: criteria)
            options.physicalVolumeButtonsWillControlDeviceVolume = true
            GCKCastContext.setSharedInstanceWith(options)
        }

        GCKLogger.sharedInstance().delegate = self
        GCKLogger.sharedInstance().loggingEnabled = true
        GCKLogger.sharedInstance().consoleLoggingEnabled = true
        let logFilter = GCKLoggerFilter()
        logFilter.minimumLevel = .verbose
        GCKLogger.sharedInstance().filter = logFilter

        GCKCastContext.sharedInstance().sessionManager.add(self)

        switch(GCKCastContext.sharedInstance().castState) {
        case .connected:
            _isCasting = true
        default:
            break
        }

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

        _player.initialize()
    }

    func player() -> CastPlayerProtocol {
        return _player
    }

    func isCasting() -> Bool {
        return _isCasting
    }
}

// - MARK: GCKRemoteMediaClientListener

extension CastIntegrationImpl: GCKRemoteMediaClientListener {
    func remoteMediaClient(_ client: GCKRemoteMediaClient, didUpdate mediaStatus: GCKMediaStatus?) {
        _player.updateMediaStatus(mediaStatus)
    }

    func remoteMediaClient(_ client: GCKRemoteMediaClient, didUpdate mediaMetadata: GCKMediaMetadata?) {

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

            _player.stopUpdatingTime()

            GCKCastContext.sharedInstance().sessionManager.currentSession?.remoteMediaClient?.remove(self)

            _isCasting = false

            videoPlayerDelegate?.isCastingStateUpdated()
        }

        func switchPlaybackToRemote() {
            guard !_isCasting else { return }

            GCKCastContext.sharedInstance().sessionManager.currentSession?.remoteMediaClient?.add(self)
            
            _isCasting = true

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
