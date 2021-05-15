//
// Copyright © 2021 mycujoo. All rights reserved.
//

import Foundation
import UIKit


public protocol AnnotationIntegration {
    /// Should be set to the timeline id that the annotations are related to.
    var timelineId: String? { get set }
    
    /// Should be called whenever there is reason to believe the annotation state has changed, e.g. when the time position has changed (once a second), or new annotations were loaded.
    func evaluate()
}

/// An object (e.g. a UIView) that can deal with rendering overlays and timeline markers. This is provided by the `playerView` on MCLS's VideoPlayer,
/// but you can also provide this yourself if you are not using the MCLS VideoPlayer.
public protocol AnnotationIntegrationView: AnyObject {
    /// The view in which all dynamic overlays should be rendered.
    var overlayContainerView: UIView { get }
    
    /// Gets called whenever the entire set of timeline markers needs to be repositioned, e.g. whenever the current position in the video changes.
    /// This is implemented by the standard MCLS VideoPlayer. If you desire to use your own AVPlayer implementation, implement this yourself.
    func setTimelineMarkers(with actions: [MLSUI.ShowTimelineMarkerAction])
}
