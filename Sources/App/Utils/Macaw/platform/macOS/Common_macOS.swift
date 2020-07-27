//
//  Common_macOS.swift
//  Macaw
//
//  Created by Daniil Manin on 8/10/17.
//  Copyright © 2017 Exyte. All rights reserved.
//

import Foundation

#if os(OSX)
import Cocoa
import Quartz

typealias MWindow = NSWindow
typealias MFont = NSFont
typealias MFontDescriptor = NSFontDescriptor
typealias MColor = NSColor
typealias MEvent = NSEvent
typealias MTouch = NSTouch
typealias MImage = NSImage
typealias MBezierPath = NSBezierPath
typealias MGestureRecognizer = NSGestureRecognizer
typealias MGestureRecognizerState = NSGestureRecognizer.State
typealias MGestureRecognizerDelegate = NSGestureRecognizerDelegate
typealias MTapGestureRecognizer = NSClickGestureRecognizer
typealias MLongPressGestureRecognizer = NSPressGestureRecognizer
typealias MPanGestureRecognizer = NSPanGestureRecognizer
typealias MPinchGestureRecognizer = NSMagnificationGestureRecognizer
typealias MRotationGestureRecognizer = NSRotationGestureRecognizer
typealias MScreen = NSScreen

func MDefaultRunLoopMode() -> RunLoop.Mode {
    return RunLoop.Mode.default
}

extension MGestureRecognizer {
    var cancelsTouchesInView: Bool {
        get {
            return false
        } set { }
    }
}

extension MTapGestureRecognizer {
    func mNumberOfTouches() -> Int {
        return 1
    }
}

extension MPanGestureRecognizer {
    func mNumberOfTouches() -> Int {
        return 1
    }

    func mLocationOfTouch(_ touch: Int, inView: NSView?) -> NSPoint {
        return super.location(in: inView)
    }
}

extension MRotationGestureRecognizer {
    var velocity: CGFloat {
        return 0.1
    }

    var mRotation: CGFloat {
        get {
            return -rotation
        }

        set {
            rotation = -newValue
        }
    }
}

extension MPinchGestureRecognizer {
    var mScale: CGFloat {
        get {
            return magnification + 1.0
        }

        set {
            magnification = newValue - 1.0
        }
    }

    func mLocationOfTouch(_ touch: Int, inView view: NSView?) -> NSPoint {
        return super.location(in: view)
    }
}

extension NSFont {
    var lineHeight: CGFloat {
        return self.boundingRectForFont.size.height
    }

    class var mSystemFontSize: CGFloat {
        return NSFont.systemFontSize
    }

    class var mFamilyNames: [String] {
        return NSFontManager.shared.availableFontFamilies
    }

    class func mFontNames(forFamily: String) -> [String] {
        var result = [String]()
        if let members = NSFontManager.shared.availableMembers(ofFontFamily: forFamily) {
            for member in members {
                result.append(member[0] as! String)
            }
        }
        return result
    }

}

extension NSScreen {
    var mScale: CGFloat {
        return self.backingScaleFactor
    }
}

extension NSImage {
    var cgImage: CGImage? {
        return self.cgImage(forProposedRect: nil, context: nil, hints: nil)
    }
}

extension NSTouch {
    func location(in view: NSView) -> NSPoint {
        let n = self.normalizedPosition
        let b = view.bounds
        return NSPoint(x: b.origin.x + b.size.width * n.x, y: b.origin.y + b.size.height * n.y)
    }
}

extension NSString {
    @nonobjc
    func size(attributes attrs: [NSAttributedString.Key: Any]? = nil) -> NSSize {
        return size(withAttributes: attrs)
    }
}

func MMainScreen() -> MScreen? {
    return MScreen.main
}

extension MBezierPath {
    func apply(_ transform: CGAffineTransform) {
        let affineTransform = AffineTransform(
            m11: transform.a,
            m12: transform.b,
            m21: transform.c,
            m22: transform.d,
            tX: transform.tx,
            tY: transform.ty
        )

        self.transform(using: affineTransform)
    }
}

extension CGContext {
    private struct CGContextScale {
        static var _scale: CGFloat = 0.0
    }

    var scale: CGFloat {
        get {
            return CGContextScale._scale
        }

        set(newValue) {
            CGContextScale._scale = newValue
        }
    }
}

extension NSWindow {

    func addSubview(_ subview: NSView) {
        contentView?.addSubview(subview)
    }
}

extension NSBezierPath {
    var mUsesEvenOddFillRule: Bool {
        return self.windingRule == .evenOdd
    }
}

#endif
