//
// Copyright © 2020 mycujoo. All rights reserved.
//

import UIKit

struct ShowOverlay {
    /// The actionId can be used to internally track progress.
    let actionId: String
    let overlay: Overlay
    let position: ActionShowOverlay.Position
    let size: ActionShowOverlay.Size
    let animateType: OverlayAnimateinType
    let animateDuration: Double
}
