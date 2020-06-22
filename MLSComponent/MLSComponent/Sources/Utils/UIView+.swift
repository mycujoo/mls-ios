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

}
