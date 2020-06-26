//
// Copyright © 2020 mycujoo. All rights reserved.
//

import Foundation


extension VideoPlayerView: AnnotationManagerDelegate {
    func setTimelineMarkers(with actions: [ShowTimelineMarker]) {
        videoSlider.setTimelineMarkers(with: actions)
    }

    func showOverlays(with actions: [ShowOverlay]) {
        if actions.count > 0 {
            print("Show overlays!", actions)
        }
    }

    func hideOverlays(with actions: [HideOverlay]) {
        if actions.count > 0 {
            print("Hide overlays!", actions)
        }
    }
}
