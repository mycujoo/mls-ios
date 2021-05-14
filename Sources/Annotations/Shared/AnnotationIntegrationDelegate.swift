//
// Copyright © 2021 mycujoo. All rights reserved.
//

import Foundation
import MLSSDK


public protocol AnnotationIntegrationDelegate: AnyObject {
    var currentDuration: Double { get }
    
    var optimisticCurrentTime: Double { get }
    
    var currentDvrWindowSize: Int? { get }
    
    var currentRawSegmentPlaylist: String? { get }
    
    /// Indicates whether the CastIntegration is connected and the device playing through Chromecast.
    func isCasting() -> Bool
}
