//
// Copyright © 2020 mycujoo. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = SimpleViewController()
        //                window?.rootViewController = WithIMASupportViewController()
        //                window?.rootViewController = WithAnnotationSupportViewController()
        //                window?.rootViewController = WithCastSupportViewController()
        //                window?.rootViewController = WithFullscreenZoomViewController()
        //                window?.rootViewController = WithPictureInPictureViewController()
        //                window?.rootViewController = WithCustomAnalyticsAccountViewController()
        //                window?.rootViewController = WithAVPlayerViewController()
        //                window?.rootViewController = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "WithEventList")
        //window?.rootViewController = WithConcurrencyLimitViewController()
        window?.makeKeyAndVisible()

        return true
    }
}
