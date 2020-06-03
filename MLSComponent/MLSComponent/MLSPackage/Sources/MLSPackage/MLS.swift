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

    public func videoPlayerView(with event: Event? = nil) -> VideoPlayerView {
        let view = VideoPlayerView()
        if let streamURL = event?.streamURL {
            view.playVideo(with: streamURL)
        }
        // configuration attach
        return view
    }

    public func eventList(completionHandler: ([Event]) -> ()) {
        // server request
    }
}

public protocol PlayerDelegate: AnyObject {
    func playerDidUpdatePlaying(player: VideoPlayerView)
    func playerDidUpdateTime(player: VideoPlayerView)
    func playerFinishedTheVideo(player: VideoPlayerView)
}
