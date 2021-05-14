//
// Copyright © 2020 mycujoo. All rights reserved.
//
import Foundation


/// This class is used simply to namespace the actions,
/// so that these actions (which are aimed at manipulating the UI) can be differentiated from the domain actions.
public class MLSUI {}

public protocol MLSUIAction {
    /// The actionId can be used to internally track progress.
    var actionId: String { get }
}

protocol MLSUIOverlayAction: MLSUIAction {
    /// The id of the overlay that this action should apply to.
    /// - note: If the annotation does not specify a custom_id for the overlay, this should default to the actionId of the action that shows the overlay.
    var overlayId: String { get }
}

public extension MLSUI {
    struct ShowTimelineMarkerAction: MLSUIAction {
        public let actionId: String
        public let timelineMarker: TimelineMarker
        /// The position in milliseconds where this marker should be placed.
        public let position: Double
        /// The position in milliseconds the user should seek to when navigating to this marker.
        public let seekPosition: Double
        
        public init(actionId: String, timelineMarker: TimelineMarker, position: Double, seekPosition: Double) {
            self.actionId = actionId
            self.timelineMarker = timelineMarker
            self.position = position
            self.seekPosition = seekPosition
        }
    }
}

extension MLSUI {
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
