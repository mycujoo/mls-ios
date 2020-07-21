//
// Copyright © 2020 mycujoo. All rights reserved.
//

import UIKit

struct ShowOverlayAction: OverlayAction {
    let actionId: String
    let overlay: Overlay
    let position: AnnotationActionShowOverlay.Position
    let size: AnnotationActionShowOverlay.Size
    let animateType: OverlayAnimateinType
    let animateDuration: Double
    let variablePositions: [String: String]

    var overlayId: String {
        return overlay.id
    }
}
