//
// Copyright © 2020 mycujoo. All rights reserved.
//

import Foundation
import UIKit

public extension UIView {
    /// Retrieves all constraints that mention the view. Unlike the `constraints` property, this is more complete.
    var allConstraints: [NSLayoutConstraint] {
        // array will contain self and all superviews
        var views = [self]

        // get all superviews
        var view = self
        while let superview = view.superview {
            views.append(superview)
            view = superview
        }

        // transform views to constraints and filter only those
        // constraints that include the view itself
        return views.flatMap({ $0.constraints }).filter { constraint in
            return constraint.firstItem as? UIView == self ||
                constraint.secondItem as? UIView == self
        }
    }

    /// - parameter thorough: If true, it returns all constraints that are mentioned for this view anywhere in the superview hierarchy. False by default.
    func constraints(on anchor: NSLayoutYAxisAnchor, thorough: Bool = false) -> [NSLayoutConstraint] {
        guard let superview = superview else { return [] }
        return (thorough ? superview.allConstraints : superview.constraints).filtered(view: self, anchor: anchor)
    }

    /// - parameter thorough: If true, it returns all constraints that are mentioned for this view anywhere in the superview hierarchy. False by default.
    func constraints(on anchor: NSLayoutXAxisAnchor, thorough: Bool = false) -> [NSLayoutConstraint] {
        guard let superview = superview else { return [] }
        return (thorough ? superview.allConstraints : superview.constraints).filtered(view: self, anchor: anchor)
    }

    /// - parameter thorough: If true, it returns all constraints that are mentioned for this view anywhere in the superview hierarchy. False by default.
    func constraints(on anchor: NSLayoutDimension, thorough: Bool = false) -> [NSLayoutConstraint] {
        guard let superview = superview else { return [] }
        return (thorough ? superview.allConstraints : superview.constraints).filtered(view: self, anchor: anchor) + superview.constraints.filtered(view: self, anchor: anchor)
    }

    /// Copies all constraints on one or more anchors from this view to another view.
    /// - returns: The copied constraints. These are not yet activated!
    func copyConstraints(on anchors: [NSLayoutDimension], to otherView: UIView) -> [NSLayoutConstraint] {
        var new: [NSLayoutConstraint] = []

        for c in Array(Set(anchors.map { constraints(on: $0) }.flatMap { $0 })) {
            let firstItem: AnyObject?
            if let firstItem_ = c.firstItem {
                firstItem = firstItem_.isEqual(self) ? otherView : firstItem_
            } else {
                firstItem = nil
            }

            let secondItem: AnyObject?
            if let secondItem_ = c.secondItem {
                secondItem = secondItem_.isEqual(self) ? otherView : secondItem_
            } else {
                secondItem = nil
            }

            let newConstraint = NSLayoutConstraint(item: firstItem, attribute: c.firstAttribute, relatedBy: c.relation, toItem: secondItem, attribute: c.secondAttribute, multiplier: c.multiplier, constant: c.constant)
            newConstraint.priority = c.priority
            new.append(newConstraint)
        }

        return new
    }
}
