//
// Copyright © 2020 mycujoo. All rights reserved.
//

import Foundation

struct PlayerConfig: Decodable {
    let primaryColor: String
    let secondaryColor: String
    let autoplay: Bool
    let showBackForwardsButtons: Bool
    let showLiveViewers: Bool
    let showEventInfoButton: Bool
}

extension PlayerConfig {
    enum CodingKeys: String, CodingKey {
        case primaryColor = "primary_color"
        case secondaryColor = "secondary_color"
        case autoplay
        case showBackForwardsButtons = "back_forward_buttons"
        case showLiveViewers = "live_viewers"
        case showEventInfoButton = "event_info_button"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let primaryColor: String = (try? container.decode(String.self, forKey: .primaryColor)) ?? "#ffffff"
        let secondaryColor: String = (try? container.decode(String.self, forKey: .secondaryColor)) ?? "#000000"
        let autoplay: Bool = (try? container.decode(Bool.self, forKey: .autoplay)) ?? true
        let showBackForwardsButtons: Bool = (try? container.decode(Bool.self, forKey: .showBackForwardsButtons)) ?? true
        let showLiveViewers: Bool = (try? container.decode(Bool.self, forKey: .showLiveViewers)) ?? true
        let showEventInfoButton: Bool = (try? container.decode(Bool.self, forKey: .showEventInfoButton)) ?? true

        self.init(primaryColor: primaryColor, secondaryColor: secondaryColor, autoplay: autoplay, showBackForwardsButtons: showBackForwardsButtons, showLiveViewers: showLiveViewers, showEventInfoButton: showEventInfoButton)
    }

    /// Generates a standard player configuration, with default values.
    static func standard() -> PlayerConfig {
        let config = self.init(primaryColor: "#ffffff", secondaryColor: "#000000", autoplay: true, showBackForwardsButtons: true, showLiveViewers: true, showEventInfoButton: true)
        return config
    }
}
