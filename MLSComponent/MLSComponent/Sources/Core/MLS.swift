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

    // MARK: - Depencency injection

    /// An internally available service that can be overwritten for the purpose of testing.
    lazy var apiService: APIServicing = {
        var moyaProvider: MoyaProvider<API> = {
            return MoyaProvider<API>(stubClosure: MoyaProvider.immediatelyStub)
        }()
        //        var moyaProvider: MoyaProvider<API> = {
        //            let authPlugin = AccessTokenPlugin(tokenClosure: { [weak self] authType in
        //                return self?.publicKey ?? ""
        //            })
        //            return MoyaProvider<API>(plugins: [authPlugin])
        //        }()

        return APIService(api: moyaProvider)
    }()
    /// An internally available service that can be overwritten for the purpose of testing.
    var annotationService: AnnotationServicing = AnnotationService()

    public init(publicKey: String, configuration: Configuration) {
        self.publicKey = publicKey
        self.configuration = configuration
    }

    /// Provides a VideoPlayer object.
    /// - parameter event: An optional MLS Event object. If provided, the associated stream on that object will be loaded into the player.
    /// - parameter seekTolerance: The seekTolerance can be configured to alter the accuracy with which the player seeks.
    ///   Set to `zero` for seeking with high accuracy at the cost of lower seek speeds. Defaults to `positiveInfinity` for faster seeking.
    public func videoPlayer(with event: Event? = nil, seekTolerance: CMTime = .positiveInfinity) -> VideoPlayer {
        let player = VideoPlayer(apiService: apiService, annotationService: annotationService)
        player.seekTolerance = seekTolerance

        player.event = event

        return player
    }

    /// Obtain a list of Events from the MLS API.
    /// - parameter completionHandler: gets called when the API response is available. Contains the desired list of Events, or nil if the request failed.
    public func eventList(completionHandler: @escaping ([Event]?) -> ()) {
        apiService.fetchEvents { (events, _) in
            if let events = events {
                completionHandler(events)
                return
            }
            completionHandler(nil)
        }
    }
}



