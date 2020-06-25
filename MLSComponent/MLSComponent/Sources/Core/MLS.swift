//
// Copyright © 2020 mycujoo. All rights reserved.
//

import Foundation
import AVFoundation
import Moya

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
    public let id: String
    public let stream: Stream?

    public init(id: String, stream: Stream?) {
        self.id = id
        self.stream = stream
    }
}

public class MLS {
    public let publicKey: String
    public let configuration: Configuration
    private var moyaProvider: MoyaProvider<API>

    public init(publicKey: String, configuration: Configuration) {
        self.publicKey = publicKey
        self.configuration = configuration
        self.moyaProvider = MoyaProvider<API>(stubClosure: MoyaProvider.immediatelyStub)
    }

    /// Provides a VideoPlayer object.
    /// - parameter event: An optional MLS Event object. If provided, the associated stream on that object will be loaded into the player.
    /// - parameter seekTolerance: The seekTolerance can be configured to alter the accuracy with which the player seeks.
    ///   Set to `zero` for seeking with high accuracy at the cost of lower seek speeds. Defaults to `positiveInfinity` for faster seeking.
    public func videoPlayer(with event: Event? = nil, seekTolerance: CMTime = .positiveInfinity) -> VideoPlayer {
        let player = VideoPlayer()
        player.seekTolerance = seekTolerance

        if let event = event {
            var playVideoWasCalled = false
            let playVideoWorkItem = DispatchWorkItem() {
                if !playVideoWasCalled {
                    playVideoWasCalled = true
                    player.playVideo(with: event)
                }
            }

            // Schedule the player to start playing in 3 seconds if the API does not respond by then.
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0, execute: playVideoWorkItem)
            moyaProvider.request(.playerConfig(event.id)) { result in
                switch result {
                case .success(let response):
                    let decoder = JSONDecoder()
                    if let config = try? decoder.decode(PlayerConfig.self, from: response.data) {
                        player.playerConfig = config
                        DispatchQueue.main.async(execute: playVideoWorkItem)
                    }
                case .failure(_):
                    break
                }
            }

            // TODO: Should not pass eventId but timelineId
//            moyaProvider.request(.annotations(event.id)) { result in
            moyaProvider.request(.annotations("timelineMarkers")) { result in
                switch result {
                case .success(let response):
                    let decoder = JSONDecoder()
                    if let annotationWrapper = try? decoder.decode(AnnotationWrapper.self, from: response.data) {
                        player.updateAnnotations(annotations: annotationWrapper.annotations)
                    }
                case .failure(_):
                    break
                }
            }
        }

        // configuration attach
        return player
    }

    public func eventList(completionHandler: ([Event]) -> ()) {
        // server request
    }
}



