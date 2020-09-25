//
// Copyright © 2020 mycujoo. All rights reserved.
//

import Foundation

extension DataLayer {
    struct PlayerConfig: Decodable {
        let primaryColor: String
        let secondaryColor: String
        let autoplay: Bool
        let showBackForwardsButtons: Bool
        let showLiveViewers: Bool
        let showEventInfoButton: Bool
        let showSeekbar: Bool
        let showFullscreen: Bool
        #if os(iOS)
        let showTimers: Bool
        #endif
    }
}

extension DataLayer.PlayerConfig {
    enum CodingKeys: String, CodingKey {
        case primaryColor = "primary_color"
        case secondaryColor = "secondary_color"
        case autoplay
        case showBackForwardsButtons = "back_forward_buttons"
        case showLiveViewers = "live_viewers"
        case showEventInfoButton = "event_info_button"
        case showSeekbar = "seekbar"
        case showFullscreen = "fullscreen"
        case showTimers = "timers"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let primaryColor: String = (try? container.decode(String.self, forKey: .primaryColor)) ?? "#ffffff"
        let secondaryColor: String = (try? container.decode(String.self, forKey: .secondaryColor)) ?? "#000000"
        let autoplay: Bool = (try? container.decode(Bool.self, forKey: .autoplay)) ?? true
        let showBackForwardsButtons: Bool = (try? container.decode(Bool.self, forKey: .showBackForwardsButtons)) ?? true
        let showLiveViewers: Bool = (try? container.decode(Bool.self, forKey: .showLiveViewers)) ?? true
        let showEventInfoButton: Bool = (try? container.decode(Bool.self, forKey: .showEventInfoButton)) ?? true
        let showSeekbar: Bool = (try? container.decode(Bool.self, forKey: .showSeekbar)) ?? true
        let showFullscreen: Bool = (try? container.decode(Bool.self, forKey: .showFullscreen)) ?? false
        let showTimers: Bool = (try? container.decode(Bool.self, forKey: .showTimers)) ?? true

        #if os(tvOS)
        self.init(primaryColor: primaryColor, secondaryColor: secondaryColor, autoplay: autoplay, showBackForwardsButtons: showBackForwardsButtons, showLiveViewers: showLiveViewers, showEventInfoButton: showEventInfoButton, showSeekbar: showSeekbar, showFullscreen: showFullscreen)
        #else
        self.init(primaryColor: primaryColor, secondaryColor: secondaryColor, autoplay: autoplay, showBackForwardsButtons: showBackForwardsButtons, showLiveViewers: showLiveViewers, showEventInfoButton: showEventInfoButton, showSeekbar: showSeekbar, showFullscreen: showFullscreen, showTimers: showTimers)
        #endif
    }
}


// - MARK: Mappers

extension DataLayer.PlayerConfig {
    var toDomain: MLSSDK.PlayerConfig {

        #if os(tvOS)
        return MLSSDK.PlayerConfig(primaryColor: self.primaryColor, secondaryColor: self.secondaryColor, autoplay: self.autoplay, showBackForwardsButtons: self.showBackForwardsButtons, showLiveViewers: self.showLiveViewers, showEventInfoButton: self.showEventInfoButton, showSeekbar: self.showSeekbar, showFullscreen: self.showFullscreen)
        #else
        return MLSSDK.PlayerConfig(primaryColor: self.primaryColor, secondaryColor: self.secondaryColor, autoplay: self.autoplay, showBackForwardsButtons: self.showBackForwardsButtons, showLiveViewers: self.showLiveViewers, showEventInfoButton: self.showEventInfoButton, showSeekbar: self.showSeekbar, showFullscreen: self.showFullscreen, showTimers: self.showTimers)
        #endif
    }
}
