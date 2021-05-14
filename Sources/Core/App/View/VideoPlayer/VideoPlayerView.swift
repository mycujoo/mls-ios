//
// Copyright © 2020 mycujoo. All rights reserved.
//

import Foundation
import UIKit


extension VideoPlayerView {
    func setTimelineMarkers(with actions: [MLSUI.ShowTimelineMarkerAction]) {
        videoSlider.setTimelineMarkers(with: actions)
    }
}
