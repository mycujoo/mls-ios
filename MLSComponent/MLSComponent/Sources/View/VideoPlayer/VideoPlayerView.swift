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

                                    self.placeOverlay(imageView: imageView, size: action.size, position: action.position)
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

    private func placeOverlay(imageView: UIView, size: ActionShowOverlay.Size, position: ActionShowOverlay.Position) {
        func wrap(_ v: UIView, axis: NSLayoutConstraint.Axis) -> UIStackView {
            let stackView = UIStackView(arrangedSubviews: [v])
            stackView.axis = axis
            stackView.distribution = .fill
            stackView.alignment = .fill
            stackView.semanticContentAttribute = semanticContentAttribute
            stackView.translatesAutoresizingMaskIntoConstraints = false
            return stackView
        }

        func makeSpacer() -> UIView {
            let spacerView = UIView()
            spacerView.translatesAutoresizingMaskIntoConstraints = false
            return spacerView
        }

        // MARK: Setup basic properties

        imageView.removeFromSuperview()
        imageView.translatesAutoresizingMaskIntoConstraints = false

        let hStackView = wrap(imageView, axis: .horizontal)
        let vStackView = wrap(hStackView, axis: .vertical)

        overlayView.addSubview(vStackView)

        let rtl = UIView.userInterfaceLayoutDirection(for: self.semanticContentAttribute) == .rightToLeft

        // MARK: Positional constraints

        var horizontallyFulfilled = false
        var verticallyFulfilled = false

        if let top = position.top {
            let spacer = makeSpacer()
            vStackView.insertArrangedSubview(spacer, at: 0)
            let constraint = spacer.heightAnchor.constraint(equalTo: overlayView.heightAnchor, multiplier: CGFloat(top / 100))
            constraint.priority = UILayoutPriority(rawValue: 247)
            constraint.isActive = true
            vStackView.topAnchor.constraint(equalTo: overlayView.topAnchor).isActive = true
            verticallyFulfilled = true
        }

        if let leading = position.leading {
            if !rtl {
                let spacer = makeSpacer()
                hStackView.insertArrangedSubview(spacer, at: 0)
                let constraint = spacer.widthAnchor.constraint(equalTo: overlayView.widthAnchor, multiplier: CGFloat(leading / 100))
                constraint.priority = UILayoutPriority(rawValue: 247)
                constraint.isActive = true
                vStackView.leadingAnchor.constraint(equalTo: overlayView.leadingAnchor).isActive = true
            } else {
                let multiplier = CGFloat(1 - (leading / 100))
                let constraint = NSLayoutConstraint(item: vStackView, attribute: .leading, relatedBy: .equal, toItem: overlayView, attribute: .leading, multiplier: multiplier, constant: 0)
                constraint.priority = UILayoutPriority(rawValue: 247)
                constraint.isActive = true
            }
            horizontallyFulfilled = true
        }
        
        if let trailing = position.trailing, !horizontallyFulfilled {
            if rtl {
                let spacer = makeSpacer()
                hStackView.addArrangedSubview(spacer)
                let constraint = spacer.widthAnchor.constraint(equalTo: overlayView.widthAnchor, multiplier: CGFloat(trailing / 100))
                constraint.priority = UILayoutPriority(rawValue: 247)
                constraint.isActive = true
                vStackView.trailingAnchor.constraint(equalTo: overlayView.trailingAnchor).isActive = true
            } else {
                let multiplier = CGFloat(trailing / 100)
                let constraint = NSLayoutConstraint(item: vStackView, attribute: .trailing, relatedBy: .equal, toItem: overlayView, attribute: .trailing, multiplier: multiplier, constant: 0)
                constraint.priority = UILayoutPriority(rawValue: 247)
                constraint.isActive = true
            }
            horizontallyFulfilled = true
        }
        
        var multiplier: CGFloat? = nil
        var attribute: NSLayoutConstraint.Attribute? = nil

        if let bottom = position.bottom, !verticallyFulfilled {
            multiplier = CGFloat(1 - (bottom / 100))
            attribute = .bottom
            verticallyFulfilled = true
        }

        // TODO: hcenter and vcenter aren't working properly yet.
        if let hcenter = position.hcenter, !horizontallyFulfilled {
            multiplier = min(2, max(0.001, CGFloat(hcenter / 100) * 2))
            attribute = .centerX
            horizontallyFulfilled = true
        }
        if let vcenter = position.vcenter, !verticallyFulfilled {
            multiplier = min(2, max(0.001, CGFloat(vcenter / 100) * 2))
            attribute = .centerY
            verticallyFulfilled = true
        }

        if let multiplier = multiplier, let attribute = attribute {
            let constraint = NSLayoutConstraint(item: vStackView, attribute: attribute, relatedBy: .equal, toItem: overlayView, attribute: attribute, multiplier: multiplier, constant: 0)
            constraint.priority = UILayoutPriority(rawValue: 247)
            constraint.isActive = true
        }

        // MARK: Size constraints

        if let width = size.width {
            let constraint = imageView.widthAnchor.constraint(equalTo: overlayView.widthAnchor, multiplier: CGFloat(width / 100))
            constraint.priority = UILayoutPriority(rawValue: 748) // lower than constraints of overlay against its superview
            constraint.isActive = true
        }

        if let height = size.height {
            let constraint = imageView.heightAnchor.constraint(equalTo: overlayView.heightAnchor, multiplier: CGFloat(height / 100))
            constraint.priority = UILayoutPriority(rawValue: 748) // lower than constraints of overlay against its superview
            constraint.isActive = true
        }

        if size.width == nil || size.height == nil {
            // If one of the height or width constraints is nil (which mostly will be the case), then set the aspect ratio
            // as determined by the native bounds of the svg.
            let multiplier = imageView.frame.width > 0 ? imageView.frame.height / imageView.frame.width : 1.0

            let constraint = NSLayoutConstraint(item: imageView, attribute: .height, relatedBy: .equal, toItem: imageView, attribute: .width, multiplier: multiplier, constant: 0)
            constraint.priority = UILayoutPriority(rawValue: 748) // lower than constraints of overlay against its superview
            constraint.isActive = true
        }
    }
}
