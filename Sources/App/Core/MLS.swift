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

    // TODO: Inject this dependency graph, rather than building it here.

    private lazy var api: MoyaProvider<API> = {
        return MoyaProvider<API>(stubClosure: MoyaProvider.immediatelyStub)
    }()

    private lazy var annotationActionRepository: AnnotationActionRepository = {
        return AnnotationActionRepositoryImpl(api: api)
    }()
    private lazy var eventRepository: EventRepository = {
        return EventRepositoryImpl(api: api)
    }()
    private lazy var playerConfigRepository: PlayerConfigRepository = {
        return PlayerConfigRepositoryImpl(api: api)
    }()
    private lazy var arbitraryDataRepository: ArbitraryDataRepository = {
        return ArbitraryDataRepositoryImpl()
    }()

    lazy var getAnnotationActionsForTimelineUseCase: GetAnnotationActionsForTimelineUseCase = {
        return GetAnnotationActionsForTimelineUseCase(annotationActionRepository: annotationActionRepository)
    }()
    lazy var getEventUseCase: GetEventUseCase = {
        return GetEventUseCase(eventRepository: eventRepository)
    }()
    lazy var getPlayerConfigForEventUseCase: GetPlayerConfigForEventUseCase = {
        return GetPlayerConfigForEventUseCase(playerConfigRepository: playerConfigRepository)
    }()
    lazy var listEventsUseCase: ListEventsUseCase = {
        return ListEventsUseCase(eventRepository: eventRepository)
    }()
    lazy var getSVGUseCase: GetSVGUseCase = {
        return GetSVGUseCase(arbitraryDataRepository: arbitraryDataRepository)
    }()

    /// An internally available service that can be overwritten for the purpose of testing.
    lazy var annotationService: AnnotationServicing = {
        return AnnotationService()
    }()

    lazy var dataProvider_: DataProvider = {
        return DataProvider(listEventsUseCase: listEventsUseCase)
    }()

    private var _injectedAVPlayer: MLSAVPlayerProtocol? = nil
    /// Injects an AVPlayer into the MLS component. Will be used by `buildAVPlayer()`
    func inject(avPlayer: MLSAVPlayerProtocol) {
        _injectedAVPlayer = avPlayer
    }

    /// - returns: A new instance of MLSAVPlayerProtocol, unless an AVPlayer was injected at some point, then that injected value is returned instead.
    func buildAVPlayer() -> MLSAVPlayerProtocol {
        return _injectedAVPlayer ?? MLSAVPlayer()
    }

    public init(publicKey: String, configuration: Configuration) {
        self.publicKey = publicKey
        self.configuration = configuration
    }

    /// Provides a VideoPlayer object.
    /// - parameter event: An optional MLS Event object. If provided, the associated stream on that object will be loaded into the player.
    /// - parameter seekTolerance: The seekTolerance can be configured to alter the accuracy with which the player seeks.
    ///   Set to `zero` for seeking with high accuracy at the cost of lower seek speeds. Defaults to `positiveInfinity` for faster seeking.
    public func videoPlayer(with event: Event? = nil, seekTolerance: CMTime = .positiveInfinity) -> VideoPlayer {
        let player = VideoPlayer(
            player: buildAVPlayer(),
            getAnnotationActionsForTimelineUseCase: getAnnotationActionsForTimelineUseCase,
            getPlayerConfigForEventUseCase: getPlayerConfigForEventUseCase,
            getSVGUseCase: getSVGUseCase,
            annotationService: annotationService,
            seekTolerance: seekTolerance)

        player.event = event

        return player
    }

    /// Provides a DataProvider object that can be used to retrieve data from the MLS API directly.
    public func dataProvider() -> DataProvider {
        return dataProvider_
    }
}



