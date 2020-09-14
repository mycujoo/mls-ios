//
// Copyright © 2020 mycujoo. All rights reserved.
//

import Foundation


/// A set of configurable properties for the VideoPlayer.
public struct PlayerConfig {
    /// The primary color determines the color of various visual elements within the video player, e.g. the color of the controls. This should be a hexadecimal color code (e.g. #FFFFFF)
    let primaryColor: String
    /// The secondary color will be used in the future to determine the color of various visual elements, but is not used yet. This should be a hexadecimal color code (e.g. #000000)
    let secondaryColor: String
    /// Autoplay determines whether a video stream should start playing immediately after it is loaded into the VideoPlayer, or if it should wait for the user to press play.
    let autoplay: Bool
    /// Indicates whether the 10s backwards/forwards buttons should be shown (true) or hidden (false).
    let showBackForwardsButtons: Bool
    /// Indicates whether the number of concurrent viewers on a live stream should be shown (true) or hidden (false).
    let showLiveViewers: Bool
    /// Indicates whether the "info" button in the top-right corner of the video player should be shown (true) or hidden (false).
    let showEventInfoButton: Bool

    public init(
            primaryColor: String,
            secondaryColor: String,
            autoplay: Bool,
            showBackForwardsButtons: Bool,
            showLiveViewers: Bool,
            showEventInfoButton: Bool
    ) {
        self.primaryColor = primaryColor
        self.secondaryColor = secondaryColor
        self.autoplay = autoplay
        self.showBackForwardsButtons = showBackForwardsButtons
        self.showLiveViewers = showLiveViewers
        self.showEventInfoButton = showEventInfoButton
    }
}

public extension PlayerConfig {
    /// Generates a standard player configuration, with default values.
    static func standard() -> PlayerConfig {
        let config = self.init(primaryColor: "#ffffff", secondaryColor: "#000000", autoplay: true, showBackForwardsButtons: true, showLiveViewers: true, showEventInfoButton: true)
        return config
    }
}
