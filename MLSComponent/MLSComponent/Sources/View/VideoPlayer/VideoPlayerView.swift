//
// Copyright © 2020 mycujoo. All rights reserved.
//

import Foundation
import Macaw
import Alamofire

extension VideoPlayerView: AnnotationManagerDelegate {
    func setTimelineMarkers(with actions: [ShowTimelineMarker]) {
        videoSlider.setTimelineMarkers(with: actions)
    }

    func showOverlays(with actions: [ShowOverlay]) {
        DispatchQueue.global(qos: .background).async { [weak self] in
            if actions.count > 0 {
                for action in actions {
                    AF.request(action.overlay.svgURL, method: .get).responseString{ [weak self] response in
                        if let svgString = response.value {
                            if let node = try? SVGParser.parse(text: svgString), let bounds = node.bounds {
                                DispatchQueue.main.async { [weak self] in
                                    guard let self = self else { return }

                                    let imageView = SVGView(node: node, frame: CGRect(x: 0, y: 0, width: bounds.w, height: bounds.h))

                                    self.setOverlayConstraints(imageView: imageView, size: action.size, position: action.position)
                                    self.overlays[action.overlay.id] = (overlay: action.overlay, view: imageView)
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    func hideOverlays(with actions: [HideOverlay]) {

    }

    private func setOverlayConstraints(imageView: UIView, size: ActionShowOverlay.Size, position: ActionShowOverlay.Position) {
        imageView.removeFromSuperview()
        addSubview(imageView)

        imageView.translatesAutoresizingMaskIntoConstraints = false

        // MARK: Size constraints

        if let width = size.width {
            imageView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: CGFloat(width / 100)).isActive = true
        }

        if let height = size.height {
            imageView.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: CGFloat(height / 100)).isActive = true
        }

        if size.width == nil || size.height == nil {
            // If one of the height or width constraints is nil (which mostly will be the case), then set the standard aspect ratio.
            let multiplier = imageView.frame.width > 0 ? imageView.frame.height / imageView.frame.width : 1.0

            NSLayoutConstraint(
                item: imageView,
                attribute: .height,
                relatedBy: .equal,
                toItem: imageView,
                attribute: .width,
                multiplier: multiplier,
                constant: 0).isActive = true
        }

        // MARK: Positional constraints

        imageView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        imageView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true

    }
}
