//
// Copyright © 2020 mycujoo. All rights reserved.
//

import Foundation

protocol Action {
    /// The actionId can be used to internally track progress.
    var actionId: String { get }
}

protocol OverlayAction: Action {
    /// The id of the overlay that this action should apply to.
    /// - note: If the annotation does not specify a custom_id for the overlay, this should default to the actionId of the action that shows the overlay.
    var overlayId: String { get }
}

