//
// Copyright © 2020 mycujoo. All rights reserved.
//

import UIKit

extension UIColor {
    var components: (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat)? {
        var r: CGFloat = 0, g: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
        return getRed(&r, green: &g, blue: &b, alpha: &a) ? (r,g,b,a) : nil
    }

    var hex: String {
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0

        getRed(&r, green: &g, blue: &b, alpha: &a)

        let rr = Int(r) * 255
        let gg = Int(g) * 255
        let bb = Int(b) * 255

        let aa = String(format: "#%02x%02x%02x", rr, gg, bb)
        return aa
    }

    convenience init(hex: String) {
        let scanner = Scanner(string: hex)

        var fullLength = 6
        var smallLength = 3

        if hex.hasPrefix("#") {
            scanner.scanLocation += 1
            fullLength += 1
            smallLength += 1
        }

        var rgb: UInt32 = 0
        scanner.scanHexInt32(&rgb)

        var r: Int = 0
        var g: Int = 0
        var b: Int = 0

        if hex.count == fullLength {
            let mask = 0x000000ff
            r = Int(rgb >> 16) & mask
            g = Int(rgb >>  8) & mask
            b = Int(rgb >>  0) & mask
        } else if hex.count == smallLength {
            let mask = 0x000f
            r = Int(rgb >> 8) & mask * 0x11
            g = Int(rgb >> 4) & mask * 0x11
            b = Int(rgb >> 0) & mask * 0x11
        }

        self.init(red:   CGFloat(r) / 255,
                  green: CGFloat(g) / 255,
                  blue:  CGFloat(b) / 255,
                  alpha: 1)
    }

    /// Compares two UIColor objects by their RGB integer values (it does not consider the alpha channel!).
    func isSimilar(_ color: UIColor?) -> Bool {
        guard let c1 = self.components, let c2 = color?.components else { return false }

        return (Int(c1.red * 255) == Int(c2.red * 255) && Int(c1.green * 255) == Int(c2.green * 255) && Int(c1.blue * 255) == Int(c2.blue * 255))
    }

    /// - returns: Either white or black, depending on which one is more pleasant to read.
    var isDarkColor: Bool {
        guard let components = self.components else { return true }

        return (((components.red * 299) + (components.green * 587) + (components.blue * 114)) / 1000) < 0.5
    }

    /// - returns: Luminosity of this color, expressed as a value between 0-255
    var luminosity: Int {
        guard let components = self.components else { return 0 }

        let fractal: CGFloat = (0.2126 * components.red + 0.7152 * components.green + 0.0722 * components.blue)
        return Int(round(255 * fractal)) // per ITU-R BT.709
    }
}

