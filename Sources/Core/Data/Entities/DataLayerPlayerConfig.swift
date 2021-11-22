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
        let showSeekbar: Bool
        let showTimers: Bool
        let imaAdUnit: String?
        let analyticsAccount: String?
        #if os(iOS)
        let showEventInfoButton: Bool
        let showFullscreen: Bool
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
        case showSeekbar = "seekbar"
        case showTimers = "timers"
        case imaAdUnit = "ima_ad_unit"
        case analyticsAccount = "analytics_account"
        #if os(iOS)
        case showEventInfoButton = "event_info_button"
        case showFullscreen = "fullscreen"
        #endif
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let primaryColor: String = (try? container.decode(String.self, forKey: .primaryColor)) ?? "#ffffff"
        let secondaryColor: String = (try? container.decode(String.self, forKey: .secondaryColor)) ?? "#000000"
        let autoplay: Bool = (try? container.decode(Bool.self, forKey: .autoplay)) ?? true
        let showBackForwardsButtons: Bool = (try? container.decode(Bool.self, forKey: .showBackForwardsButtons)) ?? true
        let showLiveViewers: Bool = (try? container.decode(Bool.self, forKey: .showLiveViewers)) ?? true
        let showSeekbar: Bool = (try? container.decode(Bool.self, forKey: .showSeekbar)) ?? true
        let showTimers: Bool = (try? container.decode(Bool.self, forKey: .showTimers)) ?? true
        let imaAdUnit: String? = try? container.decode(String.self, forKey: .imaAdUnit)
        let analyticsAccount: String? = try? container.decode(String.self, forKey: .analyticsAccount)

        #if os(tvOS)
        self.init(primaryColor: primaryColor, secondaryColor: secondaryColor, autoplay: autoplay, showBackForwardsButtons: showBackForwardsButtons, showLiveViewers: showLiveViewers, showSeekbar: showSeekbar, showTimers: showTimers, imaAdUnit: imaAdUnit, analyticsAccount: analyticsAccount)
        #else
        let showEventInfoButton: Bool = (try? container.decode(Bool.self, forKey: .showEventInfoButton)) ?? true
        let showFullscreen: Bool = (try? container.decode(Bool.self, forKey: .showFullscreen)) ?? false

        self.init(primaryColor: primaryColor, secondaryColor: secondaryColor, autoplay: autoplay, showBackForwardsButtons: showBackForwardsButtons, showLiveViewers: showLiveViewers, showSeekbar: showSeekbar, showTimers: showTimers, imaAdUnit: imaAdUnit, analyticsAccount: analyticsAccount, showEventInfoButton: showEventInfoButton, showFullscreen: showFullscreen)
        #endif
    }
}


// - MARK: Mappers

extension DataLayer.PlayerConfig {
    var toDomain: MLSSDK.PlayerConfig {
        #if os(tvOS)
        return MLSSDK.PlayerConfig(primaryColor: self.primaryColor, secondaryColor: self.secondaryColor, autoplay: self.autoplay, showBackForwardsButtons: self.showBackForwardsButtons, showLiveViewers: self.showLiveViewers, showSeekbar: self.showSeekbar, showTimers: self.showTimers, imaAdUnit: self.imaAdUnit)
        #else
        return MLSSDK.PlayerConfig(primaryColor: self.primaryColor, secondaryColor: self.secondaryColor, autoplay: self.autoplay, showBackForwardsButtons: self.showBackForwardsButtons, showLiveViewers: self.showLiveViewers, showEventInfoButton: self.showEventInfoButton, showSeekbar: self.showSeekbar, showFullscreen: self.showFullscreen, showTimers: self.showTimers, imaAdUnit: self.imaAdUnit)
        #endif
    }
}
