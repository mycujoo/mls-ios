//
// Copyright © 2020 mycujoo. All rights reserved.
//

import UIKit

extension NSLayoutConstraint {
    func constraintWithMultiplier(_ multiplier: CGFloat) -> NSLayoutConstraint {
        return NSLayoutConstraint(item: self.firstItem!, attribute: self.firstAttribute, relatedBy: self.relation, toItem: self.secondItem, attribute: self.secondAttribute, multiplier: multiplier, constant: self.constant)
    }
    
}

extension NSLayoutConstraint {
    func matches(view: UIView, anchor: NSLayoutYAxisAnchor) -> Bool {
        if let firstView = firstItem as? UIView, firstView == view && firstAnchor == anchor {
            return true
        }
        if let secondView = secondItem as? UIView, secondView == view && secondAnchor == anchor {
            return true
        }
        return false
    }

    func matches(view: UIView, anchor: NSLayoutXAxisAnchor) -> Bool {
        if let firstView = firstItem as? UIView, firstView == view && firstAnchor == anchor {
            return true
        }
        if let secondView = secondItem as? UIView, secondView == view && secondAnchor == anchor {
            return true
        }
        return false
    }

    func matches(view: UIView, anchor: NSLayoutDimension) -> Bool {
        if let firstView = firstItem as? UIView, firstView == view && firstAnchor == anchor {
            return true
        }
        if let secondView = secondItem as? UIView, secondView == view && secondAnchor == anchor {
            return true
        }
        return false
    }
}

extension Array where Element == NSLayoutConstraint {

    func filtered(view: UIView, anchor: NSLayoutYAxisAnchor) -> [NSLayoutConstraint] {
        return filter { constraint in
            constraint.matches(view: view, anchor: anchor)
        }
    }
    func filtered(view: UIView, anchor: NSLayoutXAxisAnchor) -> [NSLayoutConstraint] {
        return filter { constraint in
            constraint.matches(view: view, anchor: anchor)
        }
    }
    func filtered(view: UIView, anchor: NSLayoutDimension) -> [NSLayoutConstraint] {
        return filter { constraint in
            constraint.matches(view: view, anchor: anchor)
        }
    }
}
