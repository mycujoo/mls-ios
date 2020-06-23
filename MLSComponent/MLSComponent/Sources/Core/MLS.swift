//
// Copyright © 2020 mycujoo. All rights reserved.
//

import Foundation
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

    public func videoPlayer(with event: Event? = nil, autoplay: Bool = true) -> VideoPlayer {
        let player = VideoPlayer()
        player.view.primaryColor = UIColor(hex: "#38d430")
        if let event = event {
            player.playVideo(with: event, autoplay: autoplay)

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



