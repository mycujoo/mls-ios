//
// Copyright © 2020 mycujoo. All rights reserved.
//

import Foundation

public struct Configuration {
    public init() { }
}

public struct Stream {

    public let urls: NonEmptyArray<URL>

    /// - Parameter urls: nonempty collection of URLs. Could be initialized with a single URL .init(streamURL)
    /// or with multiple URLs separated by coma .init(streamURL, streamURL)
    public init(urls: NonEmptyArray<URL>) {
        self.urls = urls
    }
}

public struct Event {
    public let id: AnyHashable
    public let stream: Stream

    public init(id: AnyHashable, stream: Stream) {
        self.id = id
        self.stream = stream
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
