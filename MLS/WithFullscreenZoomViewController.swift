//
// Copyright © 2020 mycujoo. All rights reserved.
//

import UIKit
import MLSComponent

class WithFullscreenZoomViewController: UIViewController {
    private lazy var mls = MLS(publicKey: "F20E0UNTM29R0K5A30JAAE2L87URF2VO", configuration: Configuration())

    private var doubleTapGestureRecognizer: UITapGestureRecognizer? = nil

    private var portraitPlayerConstraints: [NSLayoutConstraint] = []
    private var landscapePlayerConstraints: [NSLayoutConstraint] = []

    private enum PlayerConstraintMode: Int {
        case portrait = 0, landscape, zoomedLandscape, unknown
    }
    private var playerConstraintMode = PlayerConstraintMode.unknown {
        didSet {
            switch playerConstraintMode {
            case .portrait:
                videoPlayer.view.playerLayer?.videoGravity = .resizeAspect
                NSLayoutConstraint.deactivate(landscapePlayerConstraints)
                NSLayoutConstraint.activate(portraitPlayerConstraints)
            case .landscape:
                videoPlayer.view.playerLayer?.videoGravity = .resizeAspect
                NSLayoutConstraint.deactivate(portraitPlayerConstraints)
                NSLayoutConstraint.activate(landscapePlayerConstraints)
            case .zoomedLandscape:
                videoPlayer.view.playerLayer?.videoGravity = .resizeAspectFill
                NSLayoutConstraint.deactivate(portraitPlayerConstraints)
                NSLayoutConstraint.activate(landscapePlayerConstraints)
            default:
                break
            }
            videoPlayer.view.setNeedsLayout()
            videoPlayer.view.layoutIfNeeded()
        }
    }

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

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        let isLandscape = UIDevice.current.orientation.isLandscape
        if videoPlayer.delegate == nil {
            videoPlayer.delegate = self

            view.addSubview(videoPlayer.view)
            videoPlayer.view.translatesAutoresizingMaskIntoConstraints = false

            portraitPlayerConstraints = [
                videoPlayer.view.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
                videoPlayer.view.heightAnchor.constraint(equalTo: videoPlayer.view.widthAnchor, multiplier: 9 / 16),
                videoPlayer.view.leftAnchor.constraint(equalTo: view.leftAnchor),
                videoPlayer.view.rightAnchor.constraint(equalTo: view.rightAnchor),
                videoPlayer.view.bottomAnchor.constraint(lessThanOrEqualTo: view.bottomAnchor)
            ]

            landscapePlayerConstraints = [
                videoPlayer.view.topAnchor.constraint(equalTo: view.topAnchor),
                videoPlayer.view.leftAnchor.constraint(equalTo: view.leftAnchor),
                videoPlayer.view.rightAnchor.constraint(equalTo: view.rightAnchor),
                videoPlayer.view.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ]

            for constraint in (portraitPlayerConstraints + landscapePlayerConstraints) {
                constraint.priority = .defaultHigh
            }

            doubleTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(playerViewDoubleTapped))
            doubleTapGestureRecognizer!.numberOfTapsRequired = 2
            doubleTapGestureRecognizer!.delegate = self
            videoPlayer.view.addGestureRecognizer(doubleTapGestureRecognizer!)
        }

        updateIsFullscreen(to: isLandscape)

        mls.dataProvider().eventList(completionHandler: { [weak self] (events) in
            self?.videoPlayer.event = events?.first
        })
    }
}

// MARK: - PlayerDelegate
extension WithFullscreenZoomViewController: PlayerDelegate {
    func playerDidUpdatePlaying(player: VideoPlayer) {
//        print("new status: ", player.status)
    }

    func playerDidUpdateTime(player: VideoPlayer) {
//        print("new time: ", player.currentTime)
    }

    func playerDidUpdateState(player: VideoPlayer) {
//        print("new state: ", player.state)
    }

    func playerDidUpdateAnnotations(player: VideoPlayer) {
//        print("new annotations: ", player.annotations)
    }

    func playerDidUpdateFullscreen(player: VideoPlayer) {
//        print("fullscreen mode: ", player.isFullscreen)

        updateIsFullscreen(to: player.isFullscreen)
    }
}

extension WithFullscreenZoomViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        guard let doubleTapGestureRecognizer = self.doubleTapGestureRecognizer else { return false }
        if gestureRecognizer == doubleTapGestureRecognizer && otherGestureRecognizer == videoPlayer.view.tapGestureRecognizer {
            // Could return true here. However, we only want to register double-taps in landscape mode in this demo.
            return videoPlayer.isFullscreen
        }
        return false
    }

    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        // Ensure that the doubleTapGestureRecognizer does not delay any controls.
        if (touch.view?.isKind(of: UIControl.self) ?? false) {
            return false
        }
        return true
    }
}

extension WithFullscreenZoomViewController {
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)

        updateIsFullscreen(to: UIDevice.current.orientation.isLandscape)
    }

    @objc private func playerViewDoubleTapped() {
        switch playerConstraintMode {
        case .landscape:
            playerConstraintMode = .zoomedLandscape
        case .zoomedLandscape:
            playerConstraintMode = .landscape
        default:
            break
        }
    }

    private func updateIsFullscreen(to fullscreen: Bool) {
        if videoPlayer.isFullscreen != fullscreen {
            videoPlayer.isFullscreen = fullscreen
        }

        if fullscreen && !UIDevice.current.orientation.isLandscape {
            // Note: make sure to enable "requires full screen" on the build target for this to work on iPads
            UIDevice.current.setValue(UIInterfaceOrientation.landscapeRight.rawValue, forKey: "orientation")
        }
        else if !fullscreen && !UIDevice.current.orientation.isPortrait {
            UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: "orientation")
        }

        if fullscreen && ![.landscape, .zoomedLandscape].contains(playerConstraintMode) {
            playerConstraintMode = .landscape
        } else if !fullscreen && .portrait != playerConstraintMode {
            playerConstraintMode = .portrait
        }
    }
}

