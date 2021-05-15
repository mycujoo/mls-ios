//
// Copyright © 2021 mycujoo. All rights reserved.
//

import Foundation
import MLSSDK
import UIKit
import GoogleCast


/// The SDK user should implement this protocol on the delegate (typically on a UIViewController).
/// - note: Some methods are optional and have an empty implementation, but can be overwritten for more specialized features (e.g. styling the mini controller).
public protocol CastIntegrationDelegate: AnyObject {

    /// Should be implemented by the SDK user. Should return an array of UIViews to which this SDK can add Google Cast buttons (in the desired tint color for each).
    /// At least one should be provided, but more can be added (e.g. if a second one should be added to a UINavigationBar).
    /// - note: It is recommended that the SDK user places a UIView from this array inside the `topTrailingControlsStackView` UIStackView on the VideoPlayer.
    /// - note: The GCKUICastButton will be constrained to the center X and Y coordinates of the parent view, so the parentView must be sized independently.
    ///   Width and height of 40 pts is recommended.
    func getCastButtonParentViews() -> [(parentView: UIView, tintColor: UIColor)]

    /// Should be implemented by the SDK user. Should return a UIView to which this SDK can add the Google Cast mini-controller as a subview. Nil if the mini controller is not desired.
    /// - important: If you add a height contraint to this UIView, make sure it is not of a required priority, since the SDK will automatically adjust this height constraint to the correct constant.
    ///   The SDK will also automatically toggle the `hidden` property as needed.
    /// - seeAlso: `getMiniControllerParentViewController`
    func getMiniControllerParentView() -> UIView?

    /// Should be implemented by the SDK user. Should return a UIViewController to which this SDK can add the Google Cast mini-controller as a subview. Nil if the mini controller is not desired.
    /// - seeAlso: `getMiniControllerParentView`
    func getMiniControllerParentViewController() -> UIViewController?

    /// - returns: Whether the expanded media controls should appear when the mini controller is tapped.
    ///   This does nothing if the mini-controller related methods are not implemented on this delegate.
    func useDefaultExpandedMediaControls() -> Bool

    /// Optional method.
    /// Can be implemented to provide a custom style that will be used for the Chromecast-related elements (except the cast button). 
    /// For a full table of possibilities, [see this section](https://developers.google.com/cast/docs/ios_sender/customize_ui#apply_custom_styles_to_your_ios_app).
    /// - important: You do not have to call `apply()` on this style yourself after completing the styling. The MLSSDK will do this.
    func customizeStyle(_ style: GCKUIStyle)

    /// Gets called whenever the video player connects to a Chromecast device or gets disconnected.
    func castingStateChanged(to isCasting: Bool)
}

public extension CastIntegrationDelegate {
    func getMiniControllerParentView() -> UIView? {
        return nil
    }

    /// Should be implemented by the SDK user. Should return a UIViewController to which this SDK can add the Google Cast mini-controller as a subview. Nil if the mini controller is not desired.
    /// - seeAlso: `getMiniControllerParentView`
    func getMiniControllerParentViewController() -> UIViewController? {
        return nil
    }

    func useDefaultExpandedMediaControls() -> Bool {
        return false
    }

    func customizeStyle(_ style: GCKUIStyle) {}

    func castingStateChanged(to isCasting: Bool) {}
}
