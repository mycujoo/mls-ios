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

    private var _miniMediaController: GCKUIMiniMediaControlsViewController?

    private let appId: String

    /// - note: `customReceiverAppId` only has any effect on the first initialization of this class, since that is when the Chromecast context is built.
    ///   On initializations after that, the existing Chromecast context is used, and so this will not have any effect.
    init(delegate: CastIntegrationDelegate, customReceiverAppId: String?) {
        self.delegate = delegate
        self.appId = customReceiverAppId ?? castAppId

        super.init()
    }

    deinit {
        if let miniMediaController = _miniMediaController {
            uninstallViewController(miniMediaController)
        }

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
        GCKLogger.sharedInstance().loggingEnabled = false
        GCKLogger.sharedInstance().consoleLoggingEnabled = false
        let logFilter = GCKLoggerFilter()
        logFilter.minimumLevel = .none
        GCKLogger.sharedInstance().filter = logFilter

        GCKCastContext.sharedInstance().sessionManager.add(self)

        switch(GCKCastContext.sharedInstance().castState) {
        case .connected:
            _isCasting = true
        default:
            break
        }

        for (castButtonParentView, tintColor) in delegate.getCastButtonParentViews() {
            let castButton = GCKUICastButton(frame: CGRect(x: 0, y: 0, width: 24, height: 24))
            castButton.tintColor = tintColor

            castButtonParentView.addSubview(castButton)
            castButton.translatesAutoresizingMaskIntoConstraints = false
            let castButtonConstraints = [
                castButton.centerXAnchor.constraint(equalTo: castButtonParentView.centerXAnchor),
                castButton.centerYAnchor.constraint(equalTo: castButtonParentView.centerYAnchor)
            ]
            for constraint in castButtonConstraints {
                constraint.priority = UILayoutPriority(rawValue: 749)
            }
            NSLayoutConstraint.activate(castButtonConstraints)
        }

        let castContext = GCKCastContext.sharedInstance()
        if let miniControllerParentView = delegate.getMiniControllerParentView(), let miniControllerParentViewController = delegate.getMiniControllerParentViewController() {
            castContext.useDefaultExpandedMediaControls = delegate.useDefaultExpandedMediaControls()

            let miniMediaController = castContext.createMiniMediaControlsViewController()
            miniMediaController.delegate = self
            updateControlBarsVisibility()
            installViewController(miniMediaController, inContainerView: miniControllerParentView, inParentViewController: miniControllerParentViewController)
            _miniMediaController = miniMediaController
        } else {
            castContext.useDefaultExpandedMediaControls = false
        }

        #if DEBUG
        GCKLogger.sharedInstance().delegate = self
        #endif

        let style = GCKUIStyle.sharedInstance()
        delegate.customizeStyle(style)
        style.apply()

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

extension CastIntegrationImpl: GCKUIMiniMediaControlsViewControllerDelegate {
    func miniMediaControlsViewController(_ miniMediaControlsViewController: GCKUIMiniMediaControlsViewController, shouldAppear: Bool) {
        updateControlBarsVisibility()
    }

    func updateControlBarsVisibility() {
        guard let miniMediaController = _miniMediaController, let delegate = delegate, let miniControllerParentView = delegate.getMiniControllerParentView() else { return }

        miniControllerParentView.isHidden = !miniMediaController.active

        let newHeight = miniMediaController.active ? miniMediaController.minHeight : 0

        var foundHeightConstraints = false

        let heightConstraints = miniControllerParentView.constraints.filtered(view: miniControllerParentView, anchor: miniControllerParentView.heightAnchor)
        if heightConstraints.count > 0 {
            foundHeightConstraints = true
            for heightConstraint in heightConstraints {
                heightConstraint.constant = newHeight
            }
        }

        if !foundHeightConstraints {
            let heightConstraint = NSLayoutConstraint(
                item: miniControllerParentView,
                attribute: NSLayoutConstraint.Attribute.height,
                relatedBy: NSLayoutConstraint.Relation.equal,
                toItem: nil,
                attribute: NSLayoutConstraint.Attribute.notAnAttribute,
                multiplier: 1,
                constant: newHeight)
            miniControllerParentView.addConstraint(heightConstraint)
        }

        if miniMediaController.active {
            miniControllerParentView.superview?.bringSubviewToFront(miniControllerParentView)
        }

        miniControllerParentView.setNeedsLayout()
        miniControllerParentView.layoutIfNeeded()
    }

    func installViewController(_ viewController: UIViewController, inContainerView containerView: UIView, inParentViewController parentViewController: UIViewController) {
        parentViewController.addChild(viewController)
        viewController.view.frame = containerView.bounds
        containerView.addSubview(viewController.view)

        let constraints = [
            viewController.view.leftAnchor.constraint(equalTo: containerView.leftAnchor),
            viewController.view.rightAnchor.constraint(equalTo: containerView.rightAnchor),
            viewController.view.topAnchor.constraint(equalTo: containerView.topAnchor),
            viewController.view.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
        ]
        for constraint in constraints {
            constraint.priority = UILayoutPriority(rawValue: 749)
        }
        NSLayoutConstraint.activate(constraints)

        viewController.didMove(toParent: parentViewController)
    }

    func uninstallViewController(_ viewController: UIViewController) {
        viewController.willMove(toParent: nil)
        viewController.view.removeFromSuperview()
        viewController.removeFromParent()
    }

}

// - MARK: GCKLoggerDelegate

extension CastIntegrationImpl {
    func logMessage(_ message: String, at level: GCKLoggerLevel, fromFunction function: String, location: String) {
        print(function + " - " + message)
    }
}
