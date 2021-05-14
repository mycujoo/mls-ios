//
// Copyright © 2021 mycujoo. All rights reserved.
//

import Foundation
import UIKit
import MLSSDK


/// A tag that identifies a wrappedView vs the spacer views that get added later.
/// - seeAlso: `placeOverlay()`
fileprivate let wrappedViewTag: Int = 321

/// A dictionary of arrays, where each array is the set of constraints of a single overlay. These constraints should be
/// copied when the UIView is exchanged for a newer one. The key is the `hash` of the UIView that the constraints belong to.
fileprivate var copyableOverlayConstraints: [Int: [NSLayoutConstraint]] = [:]


extension AnnotationIntegrationView {
    /// Places the overlay within a containerView, that is then sized, positioned and animated within the overlayContainerView.
    func placeOverlay(
        imageView: UIView,
        size: AnnotationActionShowOverlay.Size,
        position: AnnotationActionShowOverlay.Position,
        animateType: OverlayAnimateinType,
        animateDuration: Double
    ) -> UIView {
        func wrap(_ v: UIView, axis: NSLayoutConstraint.Axis) -> UIStackView {
            v.tag = wrappedViewTag
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

        if let left = position.left {
            if !rtl {
                let spacer = makeSpacer()
                hStackView.insertArrangedSubview(spacer, at: 0)
                let constraint = spacer.widthAnchor.constraint(equalTo: overlayContainerView.widthAnchor, multiplier: CGFloat(left / 100))
                constraint.priority = UILayoutPriority(rawValue: 247)
                constraint.isActive = true
                vStackView.leftAnchor.constraint(equalTo: overlayContainerView.leftAnchor).isActive = true
            } else {
                let multiplier = max(0.0001, CGFloat(1 - (left / 100)))
                let constraint = NSLayoutConstraint(item: vStackView, attribute: .left, relatedBy: .equal, toItem: overlayContainerView, attribute: .left, multiplier: multiplier, constant: 0)
                constraint.priority = UILayoutPriority(rawValue: 247)
                constraint.isActive = true
            }
        } else if let right = position.right {
            if rtl {
                let spacer = makeSpacer()
                hStackView.addArrangedSubview(spacer)
                let constraint = spacer.widthAnchor.constraint(equalTo: overlayContainerView.widthAnchor, multiplier: CGFloat(right / 100))
                constraint.priority = UILayoutPriority(rawValue: 247)
                constraint.isActive = true
                vStackView.rightAnchor.constraint(equalTo: overlayContainerView.rightAnchor).isActive = true
            } else {
                let multiplier = max(0.0001, CGFloat(1 - (right / 100)))
                let constraint = NSLayoutConstraint(item: vStackView, attribute: .right, relatedBy: .equal, toItem: overlayContainerView, attribute: .right, multiplier: multiplier, constant: 0)
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

        var copyableConstraints = [NSLayoutConstraint]()

        if let width = size.width {
            let constraint = imageView.widthAnchor.constraint(equalTo: overlayContainerView.widthAnchor, multiplier: CGFloat(width / 100))
            constraint.priority = UILayoutPriority(rawValue: 748) // lower than constraints of overlay against its superview
            constraint.isActive = true
            copyableConstraints.append(constraint)
        }

        if let height = size.height {
            let constraint = imageView.heightAnchor.constraint(equalTo: overlayContainerView.heightAnchor, multiplier: CGFloat(height / 100))
            constraint.priority = UILayoutPriority(rawValue: 748) // lower than constraints of overlay against its superview
            constraint.isActive = true
            copyableConstraints.append(constraint)
        }

        if size.width == nil || size.height == nil {
            // If one of the height or width constraints is nil (which mostly will be the case), then set the aspect ratio
            // as determined by the native bounds of the svg.
            let multiplier = imageView.frame.width > 0 && imageView.frame.height > 0 ? imageView.frame.height / imageView.frame.width : 1.0

            let constraint = NSLayoutConstraint(item: imageView, attribute: .height, relatedBy: .equal, toItem: imageView, attribute: .width, multiplier: multiplier, constant: 0)
            constraint.priority = UILayoutPriority(rawValue: 748) // lower than constraints of overlay against its superview
            constraint.isActive = true
            copyableConstraints.append(constraint)
        }

        // The only copyable constraints are the size constraints. The positional constraints are on the containerView, so when
        // we replace the SVG with another (e.g. when a score changes), only the size constraints need to be copied onto the new one.
        copyableOverlayConstraints[imageView.hash] = copyableConstraints

        // MARK: Animations

        switch animateType {
        case .fadeIn:
            imageView.alpha = 0
            UIView.animate(withDuration: animateDuration / 1000, delay: 0.0, options: .curveEaseInOut, animations: {
                imageView.alpha = 1
            }, completion: nil)

        case .slideFromTop, .slideFromBottom, .slideFromLeft, .slideFromRight:
            let firstAttribute: NSLayoutConstraint.Attribute
            let secondAttribute: NSLayoutConstraint.Attribute
            var finalPositionConstraints: [NSLayoutConstraint?] = []
            if animateType == .slideFromTop {
                firstAttribute = .bottom
                secondAttribute = .top
                finalPositionConstraints.append(vStackView.constraints(on: vStackView.topAnchor).first)
                finalPositionConstraints.append(vStackView.constraints(on: vStackView.bottomAnchor).first)
            } else if animateType == .slideFromBottom {
                firstAttribute = .top
                secondAttribute = .bottom
                finalPositionConstraints.append(vStackView.constraints(on: vStackView.topAnchor).first)
                finalPositionConstraints.append(vStackView.constraints(on: vStackView.bottomAnchor).first)
            } else if animateType == .slideFromLeft {
                firstAttribute = .right
                secondAttribute = .left
                finalPositionConstraints.append(vStackView.constraints(on: vStackView.leftAnchor).first)
                finalPositionConstraints.append(vStackView.constraints(on: vStackView.rightAnchor).first)
            } else {
                firstAttribute = .left
                secondAttribute = .right
                finalPositionConstraints.append(vStackView.constraints(on: vStackView.leftAnchor).first)
                finalPositionConstraints.append(vStackView.constraints(on: vStackView.rightAnchor).first)
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
            UIView.animate(withDuration: animateDuration / 1000, delay: 0.0, options: .curveEaseInOut, animations: { [weak self] in
                self?.overlayContainerView.layoutIfNeeded()
            }, completion: nil)
        case .none, .unsupported:
            break
        }

        return vStackView
    }

    /// Places a new imageView within an existing containerView (which was previously generated using `placeOverlay()`
    func replaceOverlay(containerView: UIView, imageView: UIView) {
        guard let verticalContainerView = containerView as? UIStackView,
            let horizontalContainerView = verticalContainerView.arrangedSubviews.filter({ $0.tag == wrappedViewTag }).first as? UIStackView,
            let oldImageView = horizontalContainerView.arrangedSubviews.filter({ $0.tag == wrappedViewTag }).first,
            let oldConstraints = copyableOverlayConstraints[oldImageView.hash],
            let insertPosition = horizontalContainerView.arrangedSubviews.enumerated().filter({ $0.element.isEqual(oldImageView) }).first?.offset else {
                return
        }

        imageView.tag = wrappedViewTag

        let newConstraints = UIView.copyConstraints(constraints: oldConstraints, from: oldImageView, to: imageView)

        copyableOverlayConstraints[oldImageView.hash] = nil
        copyableOverlayConstraints[imageView.hash] = newConstraints

        horizontalContainerView.removeArrangedSubview(oldImageView)
        oldImageView.removeFromSuperview()
        horizontalContainerView.insertArrangedSubview(imageView, at: insertPosition)

        NSLayoutConstraint.activate(newConstraints)

        verticalContainerView.layoutIfNeeded()
    }

    /// Removes an overlay from the overlayContainerView with the proper animations.
    func removeOverlay(
        containerView: UIView,
        animateType: OverlayAnimateoutType,
        animateDuration: Double,
        completion: @escaping (() -> Void)
    ) {
        let animationCompleted: ((Bool) -> Void) = { _ in
            containerView.removeFromSuperview()
            completion()
        }

        switch animateType {
        case .fadeOut:
            UIView.animate(withDuration: animateDuration / 1000, delay: 0.0, options: .curveEaseInOut, animations: {
                containerView.alpha = 0
            }, completion: animationCompleted)

        case .slideToTop, .slideToBottom, .slideToLeft, .slideToRight:
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
            } else if animateType == .slideToLeft {
                firstAttribute = .right
                secondAttribute = .left
                containerView.constraints(on: containerView.leftAnchor).first?.isActive = false
                containerView.constraints(on: containerView.rightAnchor).first?.isActive = false
            } else {
                firstAttribute = .left
                secondAttribute = .right
                containerView.constraints(on: containerView.leftAnchor).first?.isActive = false
                containerView.constraints(on: containerView.rightAnchor).first?.isActive = false
            }

            let constraint = NSLayoutConstraint(item: containerView, attribute: firstAttribute, relatedBy: .equal, toItem: self.overlayContainerView, attribute: secondAttribute, multiplier: 1, constant: 0)
            constraint.priority = UILayoutPriority(rawValue: 247)
            constraint.isActive = true

            UIView.animate(withDuration: animateDuration / 1000, delay: 0.0, options: .curveEaseInOut, animations: { [weak self] in
                self?.overlayContainerView.layoutIfNeeded()
            }, completion: animationCompleted)

        case .none, .unsupported:
            animationCompleted(true)
        }
    }
}
