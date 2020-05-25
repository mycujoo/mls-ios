//
// Copyright © 2020 mycujoo. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let window = UIWindow(frame: UIScreen.main.bounds)
//        let controller = AVPlayerViewController()
//        controller.player = AVPlayer(url: URL(string: "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4")!)
        window.rootViewController = ViewController()//controller//ViewController()
        self.window = window
        window.makeKeyAndVisible()
        return true
    }
}

import MLSPackage
class ViewController: UIViewController {
    let videoPlayer: VideoPlayerView = {
        let player = VideoPlayerView()
        player.translatesAutoresizingMaskIntoConstraints = false
        return player
    }()

    override func loadView() {
        view = videoPlayer
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        videoPlayer.setup(withURL: URL(string: "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4")!)

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.videoPlayer.showOverlay(Overlay(id: "id", kind: .singleLineText("singleLineText"), side: .bottomRight))

            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                self.videoPlayer.hideOverlay(with: "id")
            }
        }
    }
}

extension ViewController {
    override var preferredFocusedView: UIView? {
        videoPlayer
    }

    override var preferredFocusEnvironments: [UIFocusEnvironment] {
        return [videoPlayer]
    }
}
