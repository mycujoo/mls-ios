//
// Copyright © 2021 mycujoo. All rights reserved.
//

import Foundation
import UIKit


public protocol AnnotationIntegration {    
    /// Should be called whenever there is reason to believe the annotation state has changed, e.g. when the time position has changed (once a second), or new annotations were loaded.
    func evaluate()
}

public protocol AnnotationIntegrationView: UIView {
    /// Gets called whenever the entire set of timeline markers needs to be repositioned, e.g. whenever the current position in the video changes.
    /// This is implemented by the standard MCLS VideoPlayer. If you desire to use your own AVPlayer implementation, implement this yourself.
    func setTimelineMarkers(with actions: [MLSUI.ShowTimelineMarkerAction])
}
