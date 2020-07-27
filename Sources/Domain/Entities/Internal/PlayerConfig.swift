//
// Copyright © 2020 mycujoo. All rights reserved.
//

import Foundation

struct PlayerConfig {
    let primaryColor: String
    let secondaryColor: String
    let autoplay: Bool
    let showBackForwardsButtons: Bool
    let showLiveViewers: Bool
    let showEventInfoButton: Bool

    init(
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

extension PlayerConfig {
    /// Generates a standard player configuration, with default values.
    static func standard() -> PlayerConfig {
        let config = self.init(primaryColor: "#ffffff", secondaryColor: "#000000", autoplay: true, showBackForwardsButtons: true, showLiveViewers: true, showEventInfoButton: true)
        return config
    }
}
