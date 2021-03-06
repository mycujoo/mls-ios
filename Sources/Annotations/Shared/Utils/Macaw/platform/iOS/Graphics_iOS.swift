//
//  Graphics_iOS.swift
//  Macaw
//
//  Created by Daniil Manin on 8/17/17.
//  Copyright © 2017 Exyte. All rights reserved.
//

import Foundation

#if os(iOS) || os(tvOS)
import UIKit

func MGraphicsGetCurrentContext() -> CGContext? {
    return UIGraphicsGetCurrentContext()
}

func MGraphicsGetImageFromCurrentImageContext() -> MImage! {
    return UIGraphicsGetImageFromCurrentImageContext()
}

func MGraphicsPushContext(_ context: CGContext) {
    UIGraphicsPushContext(context)
}

func MGraphicsPopContext() {
    UIGraphicsPopContext()
}

func MGraphicsEndImageContext() {
    UIGraphicsEndImageContext()
}

func MImagePNGRepresentation(_ image: MImage) -> Data? {
    return image.pngData()
}

func MImageJPEGRepresentation(_ image: MImage, _ quality: CGFloat = 0.8) -> Data? {
    return image.jpegData(compressionQuality: quality)
}

func MMainScreen() -> MScreen? {
    return MScreen.main
}

func MGraphicsBeginImageContextWithOptions(_ size: CGSize, _ opaque: Bool, _ scale: CGFloat) {
    UIGraphicsBeginImageContextWithOptions(size, opaque, scale)
}

func MNoIntrinsicMetric() -> CGFloat {
    return UIView.noIntrinsicMetric
}

#endif
