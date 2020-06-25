//
// Copyright © 2020 mycujoo. All rights reserved.
//

import UIKit

struct ShowOverlay {
    let overlay: Overlay
    let position: ActionShowOverlay.Position
    let size: ActionShowOverlay.Size
    let animateType: OverlayAnimateinType
    let animateDuration: Double
}

struct Overlay {
    let svgURL: URL
}
