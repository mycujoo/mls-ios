//
// Copyright © 2021 mycujoo. All rights reserved.
//

import Foundation
import MLSSDK


public class IMAIntegrationFactory {
    public static func build(videoPlayer: VideoPlayer, delegate: IMAIntegrationDelegate, adTagBaseURL: URL = URL(string: "https://pubads.g.doubleclick.net/gampad/ads")!) -> IMAIntegration {
        return IMAIntegrationImpl(videoPlayer: videoPlayer, delegate: delegate, adTagBaseURL: adTagBaseURL)
    }
}
