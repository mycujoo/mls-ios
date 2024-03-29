//
// Copyright © 2020 mycujoo. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        window = UIWindow(frame: UIScreen.main.bounds)
        let mainView = MainViewController()
        let nav = UINavigationController(rootViewController: mainView)
        nav.navigationBar.topItem?.title = "MLS SDK Examples"
        window?.rootViewController = nav
        window?.makeKeyAndVisible()

        return true
    }
}
