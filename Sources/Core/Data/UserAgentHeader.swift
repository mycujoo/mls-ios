//
// Copyright © 2022 mycujoo. All rights reserved.
//

import Foundation
import UIKit

internal struct UserAgentHeader {
    
    internal func getDeviceInfo() -> String {
        let appName = Bundle.main.infoDictionary!["CFBundleName"] as! String
        let version = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! String
        let build = Bundle.main.infoDictionary!["CFBundleVersion"] as! String
        let modelName = UIDevice().type
        let platform = UIDevice.current.systemName
        let operationSystemVersion = ProcessInfo.processInfo.operatingSystemVersionString
        var cfNetworkVersion: String {
            guard
                let bundle = Bundle(identifier: "com.apple.CFNetwork"),
                let versionAny = bundle.infoDictionary?[kCFBundleVersionKey as String],
                let version = versionAny as? String
            else { return "" }
            return version
        }
        
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.release)
        let darvinVersionString = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8,
                  value != 0 else {
                      return identifier
                  }
            
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        let header =  {
            return "\(appName)/\(version) (\(platform); \(modelName); \(operationSystemVersion)) CFNetwork/\(cfNetworkVersion) Darvin/\(darvinVersionString)"
        }()
        print("### Header: " + header)
        return header
    }
}
