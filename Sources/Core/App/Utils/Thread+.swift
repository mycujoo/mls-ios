//
// Copyright © 2020 mycujoo. All rights reserved.
//

import Foundation


extension Thread {
    var isRunningTests: Bool {
        return ProcessInfo.processInfo.environment["XCTestConfigurationFilePath"] != nil
    }
}
