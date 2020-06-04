//
// Copyright © 2020 mycujoo. All rights reserved.
//

import Foundation

public struct Configuration {
    public init() { }
}

public struct Event {
    public let id: AnyHashable
    public let streamURL: URL

    public init(id: AnyHashable, streamURL: URL) {
        self.id = id
        self.streamURL = streamURL
    }
}

public class MLS {
    public let publicKey: String
    public let configuration: Configuration

    public init(publicKey: String, configuration: Configuration) {
        self.publicKey = publicKey
        self.configuration = configuration
    }

    public func videoPlayer(with event: Event? = nil) -> VideoPlayer {
        let player = VideoPlayer()
        if let event = event {
            player.playVideo(with: event)
        }
        // configuration attach
        return player
    }

    public func eventList(completionHandler: ([Event]) -> ()) {
        // server request
    }
}
