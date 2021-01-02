//
// Copyright © 2020 mycujoo. All rights reserved.
//

import Foundation

#if os(tvOS)
/// A set of configurable properties for the VideoPlayer.
public struct PlayerConfig {
    /// The primary color determines the color of various visual elements within the video player, e.g. the color of the controls. This should be a hexadecimal color code (e.g. #FFFFFF)
    public let primaryColor: String
    /// The secondary color will be used in the future to determine the color of various visual elements, but is not used yet. This should be a hexadecimal color code (e.g. #000000)
    public let secondaryColor: String
    /// Autoplay determines whether a video stream should start playing immediately after it is loaded into the VideoPlayer, or if it should wait for the user to press play.
    public let autoplay: Bool
    /// Indicates whether there entire control layer should ever be used. This defaults to true. If set to false, there is no way for the user to see any controls, and is not generally recommended.
    /// For more fine-grained control over particular buttons or other visual elements, look at the other properties on this PlayerConfig.
    public let enableControls: Bool
    /// Indicates whether the 10s backwards/forwards buttons should be shown (true) or hidden (false).
    public let showBackForwardsButtons: Bool
    /// Indicates whether the number of concurrent viewers on a live stream should be shown (true) or hidden (false).
    public let showLiveViewers: Bool
    /// Indicates whether the seekbar should be shown (true) or hidden (false).
    public let showSeekbar: Bool
    /// Indicates whether the elapsed time and duration should be shown (true) or hidden (false).
    public let showTimers: Bool

    public init(
            primaryColor: String = "#FFFFFF",
            secondaryColor: String = "#FF0000",
            autoplay: Bool = true,
            enableControls: Bool = true,
            showBackForwardsButtons: Bool = true,
            showLiveViewers: Bool = true,
            showSeekbar: Bool = true,
            showTimers: Bool = true
    ) {
        self.primaryColor = primaryColor
        self.secondaryColor = secondaryColor
        self.autoplay = autoplay
        self.enableControls = enableControls
        self.showBackForwardsButtons = showBackForwardsButtons
        self.showLiveViewers = showLiveViewers
        self.showSeekbar = showSeekbar
        self.showTimers = showTimers
    }

    /// A convenience method to rebuild a PlayerConfig based on this one, but with a different enableControls value.
    public func new(enableControls: Bool) -> PlayerConfig {
        return PlayerConfig(
            primaryColor: primaryColor,
            secondaryColor: secondaryColor,
            autoplay: autoplay,
            enableControls: enableControls,
            showBackForwardsButtons: showBackForwardsButtons,
            showLiveViewers: showLiveViewers,
            showSeekbar: showSeekbar,
            showTimers: showTimers)
    }
}
#else
/// A set of configurable properties for the VideoPlayer.
public struct PlayerConfig {
    /// The primary color determines the color of various visual elements within the video player, e.g. the color of the controls. This should be a hexadecimal color code (e.g. #FFFFFF)
    public let primaryColor: String
    /// The secondary color will be used in the future to determine the color of various visual elements, but is not used yet. This should be a hexadecimal color code (e.g. #000000)
    public let secondaryColor: String
    /// Autoplay determines whether a video stream should start playing immediately after it is loaded into the VideoPlayer, or if it should wait for the user to press play.
    public let autoplay: Bool
    /// Indicates whether there entire control layer should ever be used. This defaults to true. If set to false, there is no way for the user to see any controls, and is not generally recommended.
    /// For more fine-grained control over particular buttons or other visual elements, look at the other properties on this PlayerConfig.
    public let enableControls: Bool
    /// Indicates whether the play/pause button should be shown (true) or hidden (false)
    public let showPlayAndPause: Bool
    /// Indicates whether the 10s backwards/forwards buttons should be shown (true) or hidden (false).
    public let showBackForwardsButtons: Bool
    /// Indicates whether the number of concurrent viewers on a live stream should be shown (true) or hidden (false).
    public let showLiveViewers: Bool
    /// Indicates whether the "info" button in the top-right corner of the video player should be shown (true) or hidden (false).
    public let showEventInfoButton: Bool
    /// Indicates whether the seekbar should be shown (true) or hidden (false).
    public let showSeekbar: Bool
    /// Indicates whether the fullscreen button should be shown (true) or hidden (false).
    public let showFullscreen: Bool
    /// Indicates whether the elapsed time and duration should be shown (true) or hidden (false).
    public let showTimers: Bool

    public init(
            primaryColor: String = "#FFFFFF",
            secondaryColor: String = "#FF0000",
            autoplay: Bool = true,
            enableControls: Bool = true,
            showPlayAndPause: Bool = true,
            showBackForwardsButtons: Bool = true,
            showLiveViewers: Bool = true,
            showEventInfoButton: Bool = true,
            showSeekbar: Bool = true,
            showFullscreen: Bool = false,
            showTimers: Bool = true
    ) {
        self.primaryColor = primaryColor
        self.secondaryColor = secondaryColor
        self.autoplay = autoplay
        self.enableControls = enableControls
        self.showPlayAndPause = showPlayAndPause
        self.showBackForwardsButtons = showBackForwardsButtons
        self.showLiveViewers = showLiveViewers
        self.showEventInfoButton = showEventInfoButton
        self.showSeekbar = showSeekbar
        self.showFullscreen = showFullscreen
        self.showTimers = showTimers
    }

    /// A convenience method to rebuild a PlayerConfig based on an existing one, but with a different enableControls value.
    public func new(enableControls: Bool) -> PlayerConfig {
        return PlayerConfig(
            primaryColor: primaryColor,
            secondaryColor: secondaryColor,
            autoplay: autoplay,
            enableControls: enableControls,
            showPlayAndPause: showPlayAndPause,
            showBackForwardsButtons: showBackForwardsButtons,
            showLiveViewers: showLiveViewers,
            showEventInfoButton: showEventInfoButton,
            showSeekbar: showSeekbar,
            showFullscreen: showFullscreen,
            showTimers: showTimers)
    }
}
#endif

public extension PlayerConfig {
    /// Generates a standard player configuration, with default values.
    static func standard() -> PlayerConfig {
        let config = self.init()
        return config
    }
}
