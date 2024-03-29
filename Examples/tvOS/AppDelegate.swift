//
// Copyright © 2020 mycujoo. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit
import MLSSDK

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let window = UIWindow(frame: UIScreen.main.bounds)
//        window.rootViewController = SimpleViewController()
//        window.rootViewController = WithConcurrencyLimitViewController()
        window.rootViewController = WithAVPlayerViewController()
        self.window = window
        window.makeKeyAndVisible()
        return true
    }
}
