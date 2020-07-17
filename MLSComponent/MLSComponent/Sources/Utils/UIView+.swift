//
// Copyright © 2020 mycujoo. All rights reserved.
//

import Foundation
import UIKit

public extension UIView {

    func constraints(on anchor: NSLayoutYAxisAnchor) -> [NSLayoutConstraint] {
        guard let superview = superview else { return [] }
        return superview.constraints.filtered(view: self, anchor: anchor)
    }

    func constraints(on anchor: NSLayoutXAxisAnchor) -> [NSLayoutConstraint] {
        guard let superview = superview else { return [] }
        return superview.constraints.filtered(view: self, anchor: anchor)
    }

    func constraints(on anchor: NSLayoutDimension) -> [NSLayoutConstraint] {
        guard let superview = superview else { return [] }
        return constraints.filtered(view: self, anchor: anchor) + superview.constraints.filtered(view: self, anchor: anchor)
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
