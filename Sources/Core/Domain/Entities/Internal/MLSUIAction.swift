//
// Copyright © 2020 mycujoo. All rights reserved.
//
import Foundation


/// This class is used simply to namespace the actions,
/// so that these actions (which are aimed at manipulating the UI) can be differentiated from the domain actions.
class MLSUI {}

protocol MLSUIAction {
    /// The actionId can be used to internally track progress.
    var actionId: String { get }
}

protocol MLSUIOverlayAction: MLSUIAction {
    /// The id of the overlay that this action should apply to.
    /// - note: If the annotation does not specify a custom_id for the overlay, this should default to the actionId of the action that shows the overlay.
    var overlayId: String { get }
}

extension MLSUI {
    struct ShowTimelineMarkerAction: MLSUIAction {
        let actionId: String
        let timelineMarker: TimelineMarker
        let position: Double
        let seekPosition: Double
    }

    struct ShowOverlayAction: MLSUIOverlayAction {
        let actionId: String
        let overlay: Overlay
        let position: AnnotationActionShowOverlay.Position
        let size: AnnotationActionShowOverlay.Size
        let animateType: OverlayAnimateinType
        let animateDuration: Double
        let variables: [String]

        var overlayId: String {
            return overlay.id
        }
    }

    struct HideOverlayAction: MLSUIOverlayAction {
        let actionId: String
        let overlayId: String
        let animateType: OverlayAnimateoutType
        let animateDuration: Double
    }
}
