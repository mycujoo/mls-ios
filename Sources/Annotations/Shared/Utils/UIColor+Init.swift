//
// Copyright © 2020 mycujoo. All rights reserved.
//

import UIKit

extension UIColor {
    convenience init(fromHex hex: String) {
        let scanner = Scanner(string: hex)

        var fullLengthWithAlpha = 8
        var fullLength = 6
        var smallLength = 3

        if hex.hasPrefix("#") {
            scanner.scanLocation += 1
            fullLengthWithAlpha += 1
            fullLength += 1
            smallLength += 1
        }

        var code: UInt32 = 0
        scanner.scanHexInt32(&code)

        var r: Int = 0
        var g: Int = 0
        var b: Int = 0
        var a: Int = 0

        if hex.count == fullLength {
            let mask = 0x000000ff
            r = Int(code >> 16) & mask
            g = Int(code >>  8) & mask
            b = Int(code >>  0) & mask
            a = 255
        } else if hex.count == fullLengthWithAlpha {
            let mask = 0x00000000ff
            r = Int(code >> 24) & mask
            g = Int(code >> 16) & mask
            b = Int(code >>  8) & mask
            a = Int(code >>  0) & mask
        } else if hex.count == smallLength {
            let mask = 0x000f
            r = Int(code >> 8) & mask * 0x11
            g = Int(code >> 4) & mask * 0x11
            b = Int(code >> 0) & mask * 0x11
            a = 255
        }

        self.init(red:   CGFloat(r) / 255,
                  green: CGFloat(g) / 255,
                  blue:  CGFloat(b) / 255,
                  alpha: CGFloat(a) / 255)
    }
}

