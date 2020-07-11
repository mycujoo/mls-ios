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
    lazy var annotationService: AnnotationServicing = {
        return AnnotationService()
    }()

    lazy var dataProvider: DataProvider = {
        return DataProvider(apiService: apiService)
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
        let player = VideoPlayer(apiService: apiService, annotationService: annotationService)
        player.seekTolerance = seekTolerance

        player.event = event

        return player
    }

    /// Provides a DataProvider object that can be used to retrieve data from the MLS API directly.
    public func getDataProvider() -> DataProvider {
        return dataProvider
    }
}



