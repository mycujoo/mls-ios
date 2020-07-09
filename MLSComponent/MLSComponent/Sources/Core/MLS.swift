//
// Copyright © 2020 mycujoo. All rights reserved.
//

import Foundation
import AVFoundation
import Moya

public struct Configuration {
    public init() { }
}

public class MLS {
    public var publicKey: String
    public let configuration: Configuration
    private lazy var moyaProviderMocked: MoyaProvider<API> = {
        return MoyaProvider<API>(stubClosure: MoyaProvider.immediatelyStub)
    }()
    private lazy var moyaProvider: MoyaProvider<API> = {
        let authPlugin = AccessTokenPlugin(tokenClosure: { [weak self] authType in
            return self?.publicKey ?? ""
        })
        return MoyaProvider<API>(plugins: [authPlugin])
    }()

    public init(publicKey: String, configuration: Configuration) {
        self.publicKey = publicKey
        self.configuration = configuration
    }

    /// Provides a VideoPlayer object.
    /// - parameter event: An optional MLS Event object. If provided, the associated stream on that object will be loaded into the player.
    /// - parameter seekTolerance: The seekTolerance can be configured to alter the accuracy with which the player seeks.
    ///   Set to `zero` for seeking with high accuracy at the cost of lower seek speeds. Defaults to `positiveInfinity` for faster seeking.
    public func videoPlayer(with event: Event? = nil, seekTolerance: CMTime = .positiveInfinity) -> VideoPlayer {
        let player = VideoPlayer()
        player.seekTolerance = seekTolerance

        // TODO: Move this logic elsewhere, because it does not trigger now when loading the event on the videoPlayer directly.
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
            moyaProviderMocked.request(.playerConfig(event.id)) { result in
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
//            moyaProviderMocked.request(.annotations(event.id)) { result in
            moyaProviderMocked.request(.annotations("brusquevsmanaus")) { result in
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

    /// Obtain a list of Events from the MLS API.
    /// - parameter completionHandler: gets called when the API response is available. Contains the desired list of Events, or nil if the request failed.
    public func eventList(completionHandler: @escaping ([Event]?) -> ()) {
        moyaProviderMocked.request(.events) { result in
            switch result {
            case .success(let response):
                let decoder = JSONDecoder()
                if let eventWrapper = try? decoder.decode(EventWrapper.self, from: response.data) {
                    // TODO: Return the pagination tokens as well
                    completionHandler(eventWrapper.events)
                    return
                }
            case .failure(_):
                break
            }
            completionHandler(nil)
        }
    }
}



