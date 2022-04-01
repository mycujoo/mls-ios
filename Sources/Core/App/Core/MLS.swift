//
// Copyright © 2020 mycujoo. All rights reserved.
//

import Foundation
import AVFoundation
import UIKit
import Moya


fileprivate struct UserDefaultsContracts {
    static let PseudoUserId = "mls_pseudo_user_id"
}

public struct Configuration {
    public enum LogLevel: Int {
        /// Logs as few as possible messages to the console
        case minimal = 10
        /// Logs relevant messages to the console
        case info = 20
        /// Logs all possible messages to the console
        case verbose = 30
    }

    /// The level at which the SDK outputs debugging information to the console. Defaults to .minimal
    let logLevel: LogLevel
    let seekTolerance: CMTime
    let playerConfig: PlayerConfig
    /// An identifier that uniquely identifies this (anonymous) user. If not provided, an MCLS-chosen identifier will be used.
    let customPseudoUserId: String?

    /// - parameter seekTolerance: The seekTolerance can be configured to alter the accuracy with which the player seeks.
    ///   Set to `zero` for seeking with high accuracy at the cost of lower seek speeds. Defaults to `positiveInfinity` for faster seeking.
    /// - parameter l10nBundle: A custom Bundle that contains localized strings. This should be left to `nil` in most cases.
    ///   It is possible to provide a Bundle that provides partial translations; in cases of missing strings it will fallback to the standard SDK translations.
    public init(
        logLevel: LogLevel = .minimal,
        seekTolerance: CMTime = .positiveInfinity,
        playerConfig: PlayerConfig = PlayerConfig.standard(),
        customPseudoUserId: String? = nil,
        l10nBundle: Bundle? = nil) {
        self.logLevel = logLevel
        self.seekTolerance = seekTolerance
        self.playerConfig = playerConfig
        self.customPseudoUserId = customPseudoUserId

        if let l10nBundle = l10nBundle {
            Bundle.mlsLocalizationBundle = l10nBundle
        }
    }
}

/// The class that should be used to interact with MLS components.
/// - note: Make sure to retain an instance of this class as long as you use any of its components.
public class MLS {
    public var publicKey: String
    /// A MCLS identity token that uniquely identifies the user.
    /// This token can be obtained by calling the MCLS API from a trusted environment (e.g. a backend).
    /// This is needed for working with MCLS entitlements. If entitlements are not needed to work, this can be left to nil.
    public var identityToken: String?
    public let configuration: Configuration
    public let enableConcurrencyControl: Bool
    // TODO: Inject this dependency graph, rather than building it here.

    private lazy var api: MoyaProvider<API> = {
        let authPlugin = AccessTokenPlugin(tokenClosure: { [weak self] _ in
            return [self?.publicKey, self?.identityToken].compactMap { $0 }.joined(separator: ",")
        })

        switch configuration.logLevel {
        case .info:
            return MoyaProvider<API>(
                plugins: [authPlugin, NetworkLoggerPlugin(configuration: NetworkLoggerPlugin.Configuration(logOptions:.`default`))])
        case .verbose:
            return MoyaProvider<API>(
                plugins: [authPlugin, NetworkLoggerPlugin(configuration: NetworkLoggerPlugin.Configuration(logOptions:.verbose))])
        case .minimal:
            return MoyaProvider<API>(plugins: [authPlugin])
        }

    }()

    private lazy var ws: WebSocketConnection = {
        return WebSocketConnection(sessionId: pseudoUserId, printToConsole: configuration.logLevel == .verbose)
    }()

    private lazy var fwsFactory: (_ eventId: String) -> FeaturedWebsocketConnection = {
        return { [weak self] eventId in
            FeaturedWebsocketConnection(eventId: eventId, sessionId: self?.pseudoUserId ?? "", identityToken: self?.identityToken, printToConsole: self?.configuration.logLevel == .verbose)
        }
    }()
    
    private var pseudoUserId: String {
        return configuration.customPseudoUserId ?? mlsPseudoUserId
    }

    private lazy var mlsPseudoUserId: String = {
        if let v = UserDefaults.standard.string(forKey: UserDefaultsContracts.PseudoUserId) {
            return v
        }
        let v = UUID().uuidString
        UserDefaults.standard.setValue(v, forKey: UserDefaultsContracts.PseudoUserId)
        return v
    }()

    private lazy var timelineRepository: MLSTimelineRepository = {
        return TimelineRepositoryImpl(api: api, ws: ws)
    }()
    private lazy var eventRepository: MLSEventRepository = {
        return EventRepositoryImpl(api: api, ws: ws, fwsFactory: fwsFactory, enableConcurrencyControl: enableConcurrencyControl)
    }()
    private lazy var playerConfigRepository: MLSPlayerConfigRepository = {
        return PlayerConfigRepositoryImpl(api: api)
    }()
    private lazy var arbitraryDataRepository: MLSArbitraryDataRepository = {
        return ArbitraryDataRepositoryImpl()
    }()
    private lazy var drmRepository: MLSDRMRepository = {
        return DRMRepositoryImpl()
    }()
    private lazy var getEventUseCase: GetEventUseCase = {
        return GetEventUseCase(eventRepository: eventRepository)
    }()
    private lazy var getEventUpdatesUseCase: GetEventUpdatesUseCase = {
        return GetEventUpdatesUseCase(eventRepository: eventRepository)
    }()
    private lazy var getPlayerConfigUseCase: GetPlayerConfigUseCase = {
        return GetPlayerConfigUseCase(playerConfigRepository: playerConfigRepository)
    }()
    private lazy var listEventsUseCase: ListEventsUseCase = {
        return ListEventsUseCase(eventRepository: eventRepository)
    }()
    private lazy var getCertificateDataUseCase: GetCertificateDataUseCase = {
        return GetCertificateDataUseCase(drmRepository: drmRepository)
    }()
    private lazy var getLicenseDataUseCase: GetLicenseDataUseCase = {
        return GetLicenseDataUseCase(drmRepository: drmRepository)
    }()
    private lazy var youboraVideoAnalyticsService: VideoAnalyticsServicing = {
        return YouboraVideoAnalyticsService(pseudoUserId: pseudoUserId)
    }()

    private lazy var dataProvider_: DataProvider = {
        return DataProvider(getEventUseCase: getEventUseCase, listEventsUseCase: listEventsUseCase)
    }()

    /// A helper for `initGlobalPrereq()`
    private static var initGlobalPrereqDone = false
    /// An internal method that needs to be called once to setup some global requirements.
    /// This only needs to run once, even if multiple MLS instances are created.
    private static func initGlobalPrereq() {
        if initGlobalPrereqDone { return }
        initGlobalPrereqDone = true

        // TODO: Move this font array elsewhere.
        if let bundle = Bundle.mlsResourceBundle {
            UIFont.loadFonts(names: ["RobotoMono-Regular.ttf", "RobotoMono-Bold.ttf", "NotoSansMono_ExtraCondensed-Regular.ttf"], forBundle: bundle)
        }
    }

    public init(publicKey: String, configuration: Configuration) {
        if publicKey.isEmpty {
            fatalError("Please insert your publicKey in the MLS component. You can obtain one through https://mls.mycujoo.tv")
        }
        MLS.initGlobalPrereq()

        self.publicKey = publicKey
        self.configuration = configuration
        self.enableConcurrencyControl = configuration.playerConfig.enableConcurrencyControl
    }
    
    /// Set the user id that your systems use to identify this individual. This user id will be logged to the video analytics service that is used (if any).
    public func setUserId(userId: String?) {
        self.youboraVideoAnalyticsService.userId = userId
    }
    
    /// Provides a VideoPlayer object.
    /// - parameter event: An optional MLS Event object. If provided, the associated stream on that object will be loaded into the player.
    /// - parameter attachView: A boolean indicating whether the VideoPlayer should have its own view (default) or not.
    ///   If not, you should create your own AVPlayerLayer and controls, or use AVPlayerViewController.
    public func videoPlayer(with event: Event? = nil, attachView: Bool = true) -> VideoPlayer {
        let player = VideoPlayerImpl(
            view: attachView ? VideoPlayerView() : nil,
            avPlayer: MLSPlayer(),
            getEventUpdatesUseCase: getEventUpdatesUseCase,
            getPlayerConfigUseCase: getPlayerConfigUseCase,
            getCertificateDataUseCase: getCertificateDataUseCase,
            getLicenseDataUseCase: getLicenseDataUseCase,
            videoAnalyticsService: youboraVideoAnalyticsService,
            seekTolerance: configuration.seekTolerance,
            pseudoUserId: pseudoUserId,
            publicKey: { [weak self] in return self?.publicKey },
            identityToken: { [weak self] in return self?.identityToken })

        player.playerConfig = configuration.playerConfig
        player.event = event

        return player
    }
    
    /// Prepares a Factory class to work correctly by injecting some general dependencies.
    public func prepare<T: IntegrationFactoryProtocol>(_ factory: T) -> T {
        factory.inject(
            timelineRepository: timelineRepository,
            eventRepository: eventRepository,
            playerConfigRepository: playerConfigRepository,
            arbitraryDataRepository: arbitraryDataRepository,
            drmRepository: drmRepository)
        return factory
    }

    /// Provides a DataProvider object that can be used to retrieve data from the MLS API directly.
    public func dataProvider() -> DataProvider {
        return dataProvider_
    }
    
    public func takeObjectThatNeedsTimelineAndArbitraryRepos() -> Bool { // SameObject {
        return false // todo
    }
}


extension Configuration.LogLevel: Comparable {
    public static func < (lhs: Configuration.LogLevel, rhs: Configuration.LogLevel) -> Bool {
        return lhs.rawValue < rhs.rawValue
    }
}
