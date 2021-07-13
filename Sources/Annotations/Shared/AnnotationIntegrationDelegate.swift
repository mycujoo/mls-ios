//
// Copyright © 2021 mycujoo. All rights reserved.
//

import Foundation
import MLSSDK


public protocol AnnotationIntegrationDelegate: AnyObject {
    /// The view that the annotations should be drawn on. If you are using the MCLS VideoPlayer, you should return that object's `view` property.
    var annotationIntegrationView: AnnotationIntegrationView { get }
    
    /// Should return the duration (in milliseconds) of the currentItem. If unknown, returns 0.
    var currentDuration: Double { get }
    
    /// Should return the current time (in milliseconds) that is expected after all pending seek operations are done on the currentItem.
    var optimisticCurrentTime: Double { get }
    
    /// Indicates whether the device playing through Chromecast. If true, the DVR offset calculations will not work.
    func isCasting() -> Bool
}

public extension AnnotationIntegrationDelegate {
    func isCasting() -> Bool {
        return false
    }
}
