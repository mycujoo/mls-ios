//
// Copyright © 2021 mycujoo. All rights reserved.
//

import Foundation
import UIKit


public protocol AnnotationIntegration {
    /// Should be set to the timeline id that the annotations are related to.
    var timelineId: String? { get set }
    
    /// This is an advanced feature. This property can be used to introduce non-MCLS-based annotation actions.
    /// This is in addition to the remote annotation actions that are received through the MCLS annotation system.
    /// It is advised not to touch this property without advanced knowledge of MCLS annotations.
    var localAnnotationActions: [AnnotationAction] { get set }
    
    /// Advanced feature. Should contain the size of the DVR window.
    /// This will be used in combination with `currentRawSegmentPlaylist` to do offset calculations based on the HLS playlist.
    /// It is advised not to touch this property without advanced knowledge of MCLS annotations.
    var currentDvrWindowSize: Int? { get set }
    
    /// Advanced feature. Should contain the HLS playlist of a specific quality, so that all segments are defined.
    /// This will be used in combination with `currentDvrWindowSize` to do offset calculations based on the HLS playlist.
    /// It is advised not to touch this property without advanced knowledge of MCLS annotations. 
    var currentRawSegmentPlaylist: String? { get set }
    
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
