//
// Copyright © 2020 mycujoo. All rights reserved.
//

import Foundation
import Alamofire

extension VideoPlayerView: AnnotationManagerDelegate {
    func setTimelineMarkers(with actions: [ShowTimelineMarkerAction]) {
        videoSlider.setTimelineMarkers(with: actions)
    }

    func showOverlays(with actions: [ShowOverlayAction]) {
        DispatchQueue.global(qos: .background).async { [weak self] in
            for action in actions {
                AF.request(action.overlay.svgURL, method: .get).responseString{ [weak self] response in
                    if let svgString = response.value {
                        if let node = try? SVGParser.parse(text: svgString), let bounds = node.bounds {
                            DispatchQueue.main.async { [weak self] in
                                guard let self = self else { return }

                                let imageView = SVGView(node: node, frame: CGRect(x: 0, y: 0, width: bounds.w, height: bounds.h))
                                imageView.clipsToBounds = true
                                imageView.backgroundColor = .none

                                let containerView = self.placeOverlay(imageView: imageView, size: action.size, position: action.position, animateType: action.animateType, animateDuration: action.animateDuration)

                                self.overlays[action.overlay.id] = containerView
                            }
                        }
                    }
                }
            }
        }
    }

    func hideOverlays(with actions: [HideOverlayAction]) {
        for action in actions {
            if let v = self.overlays[action.overlayId] {
                removeOverlay(containerView: v, animateType: action.animateType, animateDuration: action.animateDuration) { [weak self] in
                    self?.overlays[action.overlayId] = nil
                }
            }
        }
    }

    /// Places the overlay within a containerView, that is then sized, positioned and animated within the overlayContainerView.
    private func placeOverlay(
        imageView: UIView,
        size: AnnotationActionShowOverlay.Size,
        position: AnnotationActionShowOverlay.Position,
        animateType: OverlayAnimateinType,
        animateDuration: Double
    ) -> UIView {
        func wrap(_ v: UIView, axis: NSLayoutConstraint.Axis) -> UIStackView {
            let stackView = UIStackView(arrangedSubviews: [v])
            stackView.axis = axis
            stackView.distribution = .fill
            stackView.alignment = .fill
            stackView.semanticContentAttribute = semanticContentAttribute
            stackView.clipsToBounds = true
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

        overlayContainerView.addSubview(vStackView)

        let rtl = UIView.userInterfaceLayoutDirection(for: self.semanticContentAttribute) == .rightToLeft

        // MARK: Positional constraints

        if let top = position.top {
            let spacer = makeSpacer()
            vStackView.insertArrangedSubview(spacer, at: 0)
            let constraint = spacer.heightAnchor.constraint(equalTo: overlayContainerView.heightAnchor, multiplier: CGFloat(top / 100))
            constraint.priority = UILayoutPriority(rawValue: 247)
            constraint.isActive = true
            vStackView.topAnchor.constraint(equalTo: overlayContainerView.topAnchor).isActive = true
        } else if let bottom = position.bottom {
            let multiplier = max(0.0001, CGFloat(1 - (bottom / 100)))
            let constraint = NSLayoutConstraint(item: vStackView, attribute: .bottom, relatedBy: .equal, toItem: overlayContainerView, attribute: .bottom, multiplier: multiplier, constant: 0)
            constraint.priority = UILayoutPriority(rawValue: 247)
            constraint.isActive = true
        } else if let vcenter = position.vcenter {
            let multiplier = min(2, max(0.0001, CGFloat(vcenter / 50) + 1))
            let constraint = NSLayoutConstraint(item: vStackView, attribute: .centerY, relatedBy: .equal, toItem: overlayContainerView, attribute: .centerY, multiplier: multiplier, constant: 0)
            constraint.priority = UILayoutPriority(rawValue: 247)
            constraint.isActive = true
        }

        if let leading = position.leading {
            if !rtl {
                let spacer = makeSpacer()
                hStackView.insertArrangedSubview(spacer, at: 0)
                let constraint = spacer.widthAnchor.constraint(equalTo: overlayContainerView.widthAnchor, multiplier: CGFloat(leading / 100))
                constraint.priority = UILayoutPriority(rawValue: 247)
                constraint.isActive = true
                vStackView.leadingAnchor.constraint(equalTo: overlayContainerView.leadingAnchor).isActive = true
            } else {
                let multiplier = max(0.0001, CGFloat(1 - (leading / 100)))
                let constraint = NSLayoutConstraint(item: vStackView, attribute: .leading, relatedBy: .equal, toItem: overlayContainerView, attribute: .leading, multiplier: multiplier, constant: 0)
                constraint.priority = UILayoutPriority(rawValue: 247)
                constraint.isActive = true
            }
        } else if let trailing = position.trailing {
            if rtl {
                let spacer = makeSpacer()
                hStackView.addArrangedSubview(spacer)
                let constraint = spacer.widthAnchor.constraint(equalTo: overlayContainerView.widthAnchor, multiplier: CGFloat(trailing / 100))
                constraint.priority = UILayoutPriority(rawValue: 247)
                constraint.isActive = true
                vStackView.trailingAnchor.constraint(equalTo: overlayContainerView.trailingAnchor).isActive = true
            } else {
                let multiplier = max(0.0001, CGFloat(1 - (trailing / 100)))
                let constraint = NSLayoutConstraint(item: vStackView, attribute: .trailing, relatedBy: .equal, toItem: overlayContainerView, attribute: .trailing, multiplier: multiplier, constant: 0)
                constraint.priority = UILayoutPriority(rawValue: 247)
                constraint.isActive = true
            }
        } else if let hcenter = position.hcenter {
            let multiplier = min(2, max(0.0001, CGFloat(hcenter / 50) + 1))
            let constraint = NSLayoutConstraint(item: vStackView, attribute: .centerX, relatedBy: .equal, toItem: overlayContainerView, attribute: .centerX, multiplier: multiplier, constant: 0)
            constraint.priority = UILayoutPriority(rawValue: 247)
            constraint.isActive = true
        }

        // MARK: Size constraints

        // NOTE: Keep in mind that these constraints only work consistently because intrinsicContentSize was disabled within Macaw!

        if let width = size.width {
            let constraint = imageView.widthAnchor.constraint(equalTo: overlayContainerView.widthAnchor, multiplier: CGFloat(width / 100))
            constraint.priority = UILayoutPriority(rawValue: 748) // lower than constraints of overlay against its superview
            constraint.isActive = true
        }

        if let height = size.height {
            let constraint = imageView.heightAnchor.constraint(equalTo: overlayContainerView.heightAnchor, multiplier: CGFloat(height / 100))
            constraint.priority = UILayoutPriority(rawValue: 748) // lower than constraints of overlay against its superview
            constraint.isActive = true
        }

        if size.width == nil || size.height == nil {
            // If one of the height or width constraints is nil (which mostly will be the case), then set the aspect ratio
            // as determined by the native bounds of the svg.
            let multiplier = imageView.frame.width > 0 && imageView.frame.height > 0 ? imageView.frame.height / imageView.frame.width : 1.0

            let constraint = NSLayoutConstraint(item: imageView, attribute: .height, relatedBy: .equal, toItem: imageView, attribute: .width, multiplier: multiplier, constant: 0)
            constraint.priority = UILayoutPriority(rawValue: 748) // lower than constraints of overlay against its superview
            constraint.isActive = true
        }

        // MARK: Animations

        switch animateType {
        case .fadeIn:
            imageView.alpha = 0
            UIView.animate(withDuration: animateDuration, delay: 0.0, options: .curveEaseInOut, animations: { [weak self] in
                imageView.alpha = 1
            }, completion: nil)

        case .slideFromTop, .slideFromBottom, .slideFromLeading, .slideFromTrailing:
            let firstAttribute: NSLayoutConstraint.Attribute
            let secondAttribute: NSLayoutConstraint.Attribute
            var finalPositionConstraints: [NSLayoutConstraint?] = []
            if animateType == .slideFromTop {
                firstAttribute = .bottom
                secondAttribute = .top
                finalPositionConstraints.append(vStackView.constraints(on: vStackView.topAnchor).first)
                finalPositionConstraints.append(vStackView.constraints(on: vStackView.bottomAnchor).first)
            } else if animateType == .slideFromTop {
                firstAttribute = .top
                secondAttribute = .bottom
                finalPositionConstraints.append(vStackView.constraints(on: vStackView.topAnchor).first)
                finalPositionConstraints.append(vStackView.constraints(on: vStackView.bottomAnchor).first)
            } else if animateType == .slideFromTop {
                firstAttribute = .trailing
                secondAttribute = .leading
                finalPositionConstraints.append(vStackView.constraints(on: vStackView.leadingAnchor).first)
                finalPositionConstraints.append(vStackView.constraints(on: vStackView.trailingAnchor).first)
            } else {
                firstAttribute = .leading
                secondAttribute = .trailing
                finalPositionConstraints.append(vStackView.constraints(on: vStackView.leadingAnchor).first)
                finalPositionConstraints.append(vStackView.constraints(on: vStackView.trailingAnchor).first)
            }

            // Temporarily deactivate the positional constraints that were built before in favor of the constraints
            // that determine starting position.
            NSLayoutConstraint.deactivate(finalPositionConstraints.compactMap { $0 })
            let constraint = NSLayoutConstraint(item: vStackView, attribute: firstAttribute, relatedBy: .equal, toItem: self.overlayContainerView, attribute: secondAttribute, multiplier: 1, constant: 0)
            constraint.priority = UILayoutPriority(rawValue: 247)
            constraint.isActive = true
            overlayContainerView.layoutIfNeeded()

            // Now animate towards the constraints that determine the final position.
            constraint.isActive = false
            NSLayoutConstraint.activate(finalPositionConstraints.compactMap { $0 })
            UIView.animate(withDuration: animateDuration, delay: 0.0, options: .curveEaseInOut, animations: { [weak self] in
                self?.overlayContainerView.layoutIfNeeded()
            }, completion: nil)
        case .none, .unsupported:
            break
        }

        return vStackView
    }

    /// Removes an overlay from the overlayContainerView with the proper animations.
    private func removeOverlay(
        containerView: UIView,
        animateType: OverlayAnimateoutType,
        animateDuration: Double,
        completion: @escaping (() -> Void)
    ) {
        let animationCompleted: ((Bool) -> Void) = { [weak self] _ in
            containerView.removeFromSuperview()
            completion()
        }

        switch animateType {
        case .fadeOut:
            UIView.animate(withDuration: animateDuration, delay: 0.0, options: .curveEaseInOut, animations: {
                containerView.alpha = 0
            }, completion: animationCompleted)

        case .slideToTop, .slideToBottom, .slideToLeading, .slideToTrailing:
            let firstAttribute: NSLayoutConstraint.Attribute
            let secondAttribute: NSLayoutConstraint.Attribute
            if animateType == .slideToTop {
                firstAttribute = .bottom
                secondAttribute = .top
                containerView.constraints(on: containerView.topAnchor).first?.isActive = false
                containerView.constraints(on: containerView.bottomAnchor).first?.isActive = false
            } else if animateType == .slideToBottom {
                firstAttribute = .top
                secondAttribute = .bottom
                containerView.constraints(on: containerView.topAnchor).first?.isActive = false
                containerView.constraints(on: containerView.bottomAnchor).first?.isActive = false
            } else if animateType == .slideToLeading {
                firstAttribute = .trailing
                secondAttribute = .leading
                containerView.constraints(on: containerView.leadingAnchor).first?.isActive = false
                containerView.constraints(on: containerView.trailingAnchor).first?.isActive = false
            } else {
                firstAttribute = .leading
                secondAttribute = .trailing
                containerView.constraints(on: containerView.leadingAnchor).first?.isActive = false
                containerView.constraints(on: containerView.trailingAnchor).first?.isActive = false
            }

            let constraint = NSLayoutConstraint(item: containerView, attribute: firstAttribute, relatedBy: .equal, toItem: self.overlayContainerView, attribute: secondAttribute, multiplier: 1, constant: 0)
            constraint.priority = UILayoutPriority(rawValue: 247)
            constraint.isActive = true

            UIView.animate(withDuration: animateDuration, delay: 0.0, options: .curveEaseInOut, animations: { [weak self] in
                self?.overlayContainerView.layoutIfNeeded()
            }, completion: animationCompleted)

        case .none, .unsupported:
            animationCompleted(true)
        }
    }
}
