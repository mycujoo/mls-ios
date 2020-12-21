//
// Copyright © 2020 mycujoo. All rights reserved.
//

import UIKit

extension UIFont {
    var monospacedDigitFont: UIFont {
        let newFontDescriptor = fontDescriptor.monospacedDigitFontDescriptor
        return UIFont(descriptor: newFontDescriptor, size: 0)
    }
}

private extension UIFontDescriptor {
    var monospacedDigitFontDescriptor: UIFontDescriptor {
        let fontDescriptorFeatureSettings = [[UIFontDescriptor.FeatureKey.featureIdentifier: kNumberSpacingType,
                                              UIFontDescriptor.FeatureKey.typeIdentifier: kMonospacedNumbersSelector]]
        let fontDescriptorAttributes = [UIFontDescriptor.AttributeName.featureSettings: fontDescriptorFeatureSettings]
        let fontDescriptor = self.addingAttributes(fontDescriptorAttributes)
        return fontDescriptor
    }
}

extension UIFont {
    class func loadFonts(names: [String], forBundle bundle: Bundle) {
        for name in names {
            registerFontWithFilenameString(filenameString: name, bundle: bundle)
        }
    }

    private static func registerFontWithFilenameString(filenameString: String, bundle: Bundle) {
        if let pathForResourceString = bundle.path(forResource: filenameString, ofType: nil),
           let fontData = NSData(contentsOfFile: pathForResourceString),
           let dataProvider = CGDataProvider(data: fontData),
           let fontRef = CGFont(dataProvider) {

            var errorRef: Unmanaged<CFError>? = nil

            if (CTFontManagerRegisterGraphicsFont(fontRef, &errorRef) == false) {
                print("Failed to register font \(filenameString) - register graphics font failed - this font may have already been registered in this bundle.")
            }
        }
        else {
            print("Failed to register font \(filenameString).")
        }
    }
}
