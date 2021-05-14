//
// Copyright © 2020 mycujoo. All rights reserved.
//
import Foundation
import MLSSDK


protocol MLSUIOverlayAction: MLSUIAction {
    /// The id of the overlay that this action should apply to.
    /// - note: If the annotation does not specify a custom_id for the overlay, this should default to the actionId of the action that shows the overlay.
    var overlayId: String { get }
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
