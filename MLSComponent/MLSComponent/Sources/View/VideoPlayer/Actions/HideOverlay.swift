//
// Copyright © 2020 mycujoo. All rights reserved.
//

import Foundation

struct HideOverlay {
    /// The actionId can be used to internally track progress.
    let actionId: String
    /// The id of the overlay that should be hidden.
    let overlayId: String
    let animateType: OverlayAnimateoutType
    let animateDuration: Double
}
