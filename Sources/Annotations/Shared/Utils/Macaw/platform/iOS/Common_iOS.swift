//
//  Common_iOS.swift
//  Macaw
//
//  Created by Daniil Manin on 8/10/17.
//  Copyright © 2017 Exyte. All rights reserved.
//

import Foundation

#if os(iOS) || os(tvOS)
import UIKit

typealias MWindow = UIWindow
typealias MRectCorner = UIRectCorner
typealias MFont = UIFont
typealias MFontDescriptor = UIFontDescriptor
typealias MColor = UIColor
typealias MEvent = UIEvent
typealias MTouch = UITouch
typealias MImage = UIImage
typealias MBezierPath = UIBezierPath
typealias MGestureRecognizer = UIGestureRecognizer
typealias MGestureRecognizerState = UIGestureRecognizer.State
typealias MGestureRecognizerDelegate = UIGestureRecognizerDelegate
typealias MTapGestureRecognizer = UITapGestureRecognizer
typealias MLongPressGestureRecognizer = UILongPressGestureRecognizer
typealias MPanGestureRecognizer = UIPanGestureRecognizer
#if os(iOS)
typealias MPinchGestureRecognizer = UIPinchGestureRecognizer
typealias MRotationGestureRecognizer = UIRotationGestureRecognizer
#endif
typealias MScreen = UIScreen
typealias MViewContentMode = UIView.ContentMode

func MDefaultRunLoopMode() -> RunLoop.Mode {
    return RunLoop.Mode.default
}

extension MTapGestureRecognizer {
    func mNumberOfTouches() -> Int {
        return numberOfTouches
    }
}

extension MPanGestureRecognizer {
    func mNumberOfTouches() -> Int {
        return numberOfTouches
    }

    func mLocationOfTouch(_ touch: Int, inView: UIView?) -> CGPoint {
        return super.location(ofTouch: touch, in: inView)
    }
}

#if os(iOS)
extension MRotationGestureRecognizer {
    final var mRotation: CGFloat {
        get {
            return rotation
        }

        set {
            rotation = newValue
        }
    }
}

extension MPinchGestureRecognizer {
    var mScale: CGFloat {
        get {
            return scale
        }

        set {
            scale = newValue
        }
    }

    func mLocationOfTouch(_ touch: Int, inView: UIView?) -> CGPoint {
        return super.location(ofTouch: touch, in: inView)
    }
}
#endif

extension MFont {
    class var mSystemFontSize: CGFloat {
        #if os(iOS)
        return UIFont.systemFontSize
        #else
        return 18.0
        #endif
    }

    class var mFamilyNames: [String] {
        return UIFont.familyNames
    }

    class func mFontNames(forFamily: String) -> [String] {
        return UIFont.fontNames(forFamilyName: forFamily)
    }
}

extension UIScreen {
    var mScale: CGFloat {
        return self.scale
    }
}

extension UIBezierPath {
    var mUsesEvenOddFillRule: Bool {
        return self.usesEvenOddFillRule
    }
}

#endif
