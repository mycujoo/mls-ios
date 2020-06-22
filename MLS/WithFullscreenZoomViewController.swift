//
// Copyright © 2020 mycujoo. All rights reserved.
//

import UIKit
import MLSComponent

class WithFullscreenZoomViewController: UIViewController {

    private lazy var mls = MLS(publicKey: "key", configuration: Configuration())

    private var doubleTapGestureRecognizer: UITapGestureRecognizer? = nil

    private var playerConstraints: [NSLayoutConstraint]? = nil
    private var zoomedPlayerConstraints: [NSLayoutConstraint]? = nil

    lazy var videoPlayer: VideoPlayer = {
        let player = mls
            .videoPlayer(
                with: Event(
                    id: "",
                    stream: Stream(
                        urls: .init(
                            URL(string: "https://playlists.mycujoo.football/eu/ck8u9ojpn1wzo0hewqpn7m054/master.m3u8")!
//                            URL(string: "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4")!
                        )
                    )
                )
        )
        return player
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .black
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        if videoPlayer.delegate == nil {
            videoPlayer.delegate = self

            view.addSubview(videoPlayer.view)
            videoPlayer.view.translatesAutoresizingMaskIntoConstraints = false

            playerConstraints = [
                videoPlayer.view.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
                videoPlayer.view.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                videoPlayer.view.heightAnchor.constraint(equalTo: videoPlayer.view.widthAnchor, multiplier: 9 / 16),
                videoPlayer.view.leftAnchor.constraint(equalTo: view.leftAnchor),
                videoPlayer.view.rightAnchor.constraint(equalTo: view.rightAnchor),
                videoPlayer.view.bottomAnchor.constraint(lessThanOrEqualTo: view.bottomAnchor)
            ]

            for constraint in playerConstraints! {
                constraint.priority = UILayoutPriority(rawValue: 998)
            }

            NSLayoutConstraint.activate(playerConstraints!)

            // Define the layout constraints for a zoomed player, but do not activate the constraints.
            zoomedPlayerConstraints = [
                videoPlayer.view.topAnchor.constraint(equalTo: view.topAnchor),
                videoPlayer.view.leftAnchor.constraint(equalTo: view.leftAnchor),
                videoPlayer.view.rightAnchor.constraint(equalTo: view.rightAnchor),
                videoPlayer.view.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ]
            for constraint in zoomedPlayerConstraints! {
                constraint.priority = UILayoutPriority(rawValue: 999)
            }

            doubleTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(playerViewDoubleTapped))
            doubleTapGestureRecognizer!.numberOfTapsRequired = 2
            doubleTapGestureRecognizer!.delegate = self
            videoPlayer.view.addGestureRecognizer(doubleTapGestureRecognizer!)
        }

        updateIsFullscreen()
    }
}

// MARK: - PlayerDelegate
extension WithFullscreenZoomViewController: PlayerDelegate {
    func playerDidUpdatePlaying(player: VideoPlayer) {
        print("new status: ", player.status)
    }

    func playerDidUpdateTime(player: VideoPlayer) {
        print("new time: ", player.currentTime)
    }

    func playerDidUpdateState(player: VideoPlayer) {
        print("new state: ", player.state)
    }

    func playerDidUpdateAnnotations(player: VideoPlayer) {
        print("new annotations: ", player.annotations)
    }

    func playerDidUpdateFullscreen(player: VideoPlayer) {
        print("fullscreen mode: ", player.isFullscreen)

        if player.isFullscreen && !UIDevice.current.orientation.isLandscape {
            UIDevice.current.setValue(UIInterfaceOrientation.landscapeRight.rawValue, forKey: "orientation")
        }
        else if !player.isFullscreen && !UIDevice.current.orientation.isPortrait {
            UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: "orientation")
        }
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

        // Make sure the player is aware of the new orientation so that it can rectify the fullscreen button image.
        updateIsFullscreen()
    }

    @objc private func playerViewDoubleTapped() {
        if let playerConstraints = self.playerConstraints, let zoomedPlayerConstraints = self.zoomedPlayerConstraints {
            if videoPlayer.view.videoGravity == .resizeAspect {
                videoPlayer.view.videoGravity = .resizeAspectFill
                NSLayoutConstraint.deactivate(playerConstraints)
                NSLayoutConstraint.activate(zoomedPlayerConstraints)
            } else {
                videoPlayer.view.videoGravity = .resizeAspect
                NSLayoutConstraint.deactivate(zoomedPlayerConstraints)
                NSLayoutConstraint.activate(playerConstraints)
            }
        }
    }

    private func updateIsFullscreen() {
        videoPlayer.isFullscreen = UIDevice.current.orientation.isLandscape
    }
}
