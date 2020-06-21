//
// Copyright © 2020 mycujoo. All rights reserved.
//

import UIKit
import MLSComponent

class ViewController: UIViewController {

    private lazy var mls = MLS(publicKey: "key", configuration: Configuration())

    private var doubleTapGestureRecognizer: UITapGestureRecognizer? = nil

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

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        if videoPlayer.delegate == nil {
            videoPlayer.delegate = self
            view.backgroundColor = .black

            view.addSubview(videoPlayer.view)
            videoPlayer.view.translatesAutoresizingMaskIntoConstraints = false
            videoPlayer.view.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
            videoPlayer.view.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            videoPlayer.view.heightAnchor.constraint(equalTo: videoPlayer.view.widthAnchor, multiplier: 9 / 16).isActive = true
            videoPlayer.view.bottomAnchor.constraint(lessThanOrEqualTo: view.bottomAnchor).isActive = true

            let leading = videoPlayer.view.leadingAnchor.constraint(equalTo: view.leadingAnchor)
            leading.priority = .defaultHigh
            leading.isActive = true

            let trailing = videoPlayer.view.trailingAnchor.constraint(equalTo: view.trailingAnchor)
            trailing.priority = .defaultHigh
            trailing.isActive = true

            doubleTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(playerViewTapped))
            doubleTapGestureRecognizer!.numberOfTapsRequired = 2
            doubleTapGestureRecognizer!.delegate = self
            videoPlayer.view.addGestureRecognizer(doubleTapGestureRecognizer!)
        }

        updateIsFullscreen()
    }
}

// MARK: - PlayerDelegate
extension ViewController: PlayerDelegate {
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

extension ViewController: UIGestureRecognizerDelegate {
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

extension ViewController {
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)

        // Make sure the player is aware of the new orientation so that it can rectify the fullscreen button image.
        updateIsFullscreen()
    }

    @objc private func playerViewTapped() {
        videoPlayer.view.videoGravity = .resizeAspectFill
    }

    private func updateIsFullscreen() {
        videoPlayer.isFullscreen = UIDevice.current.orientation.isLandscape
    }
}
