//
// Copyright © 2020 mycujoo. All rights reserved.
//

import Foundation
import AVFoundation
#if canImport(YouboraAVPlayerAdapter) && canImport(YouboraLib)
import YouboraAVPlayerAdapter
import YouboraLib

class YouboraVideoAnalyticsService: VideoAnalyticsServicing {
    
    private let pseudoUserId: String
    private var plugin: YBPlugin?

    private let defaultAnalyticsAccount = "mycujoo"
    private let NA = "N/A"

    init(pseudoUserId: String) {
        self.pseudoUserId = pseudoUserId
        
        let options = YBOptions()
        options.accountCode = defaultAnalyticsAccount
        options.username = pseudoUserId
        options.contentCustomDimension12 = pseudoUserId // default
        self.plugin = YBPlugin(options: options)
    }
    
    var userId: String? = nil {
        didSet {
            plugin?.options.contentCustomDimension12 = userId ?? pseudoUserId
        }
    }
    
    var analyticsAccount: String? {
        get {
            return plugin?.options.accountCode
        }
        set {
            plugin?.options.accountCode = newValue ?? defaultAnalyticsAccount
        }
    }

    func create(with player: MLSPlayerProtocol) {
        // Only add the adapter in real scenarios. When running unit tests with a mocked player, there will not be a youbora plugin.
        guard let mlsPlayer = player as? AVPlayer else { return }

        plugin?.adapter = YBAVPlayerAdapterSwiftTranformer.transform(from: YBAVPlayerAdapter(player: mlsPlayer))
        
        isNativeMLS = true
    }

    func stop() {
        plugin?.fireStop()
        plugin?.removeAdapter()
        plugin?.adapter?.dispose()
    }

    var currentItemTitle: String? {
        didSet {
            plugin?.options.contentTitle = currentItemTitle ?? NA
        }
    }

    var currentItemEventId: String? {
        didSet {
            plugin?.options.contentCustomDimension2 = currentItemEventId ?? NA
        }
    }

    var currentItemStreamId: String? {
        didSet {
            plugin?.options.contentCustomDimension15 = currentItemStreamId ?? NA
        }
    }

    var currentItemStreamURL: URL? {
        didSet {
            plugin?.options.contentResource = currentItemStreamURL?.absoluteString ?? NA
        }
    }

    var currentItemIsLive: Bool? {
        didSet {
            plugin?.options.contentIsLive = (currentItemIsLive ?? false) as NSValue
        }
    }

    var isNativeMLS: Bool? {
        didSet {
            plugin?.options.contentCustomDimension14 = (isNativeMLS ?? true) ? "MLS" : "NonNativeMLS"
        }
    }
    
    var customData: VideoAnalyticsCustomData? = nil {
        didSet {
            plugin?.options.contentCustomDimension1 = customData?.youboraData?.contentCustomDimension1 ?? NA
            plugin?.options.contentCustomDimension3 = customData?.youboraData?.contentCustomDimension3 ?? NA
            plugin?.options.contentCustomDimension4 = customData?.youboraData?.contentCustomDimension4 ?? NA
            plugin?.options.contentCustomDimension5 = customData?.youboraData?.contentCustomDimension5 ?? NA
            plugin?.options.contentCustomDimension6 = customData?.youboraData?.contentCustomDimension6 ?? NA
            plugin?.options.contentCustomDimension7 = customData?.youboraData?.contentCustomDimension7 ?? NA
            plugin?.options.contentCustomDimension8 = customData?.youboraData?.contentCustomDimension8 ?? NA
            plugin?.options.contentCustomDimension9 = customData?.youboraData?.contentCustomDimension9 ?? NA
            plugin?.options.contentCustomDimension10 = customData?.youboraData?.contentCustomDimension10 ?? NA
            plugin?.options.contentCustomDimension11 = customData?.youboraData?.contentCustomDimension11 ?? NA
            plugin?.options.contentCustomDimension13 = customData?.youboraData?.contentCustomDimension13 ?? NA
        }
    }
}
#else
/* If Youbora cannot be imported, fallback to a non-functional, empty service. */
class YouboraVideoAnalyticsService: VideoAnalyticsServicing {
    var analyticsAccount: String?
    
    var customData: VideoAnalyticsCustomData?
    
    private let pseudoUserId: String

    init(pseudoUserId: String) {
        self.pseudoUserId = pseudoUserId
    }
    
    var userId: String? = nil

    func create(with player: MLSPlayerProtocol) {
    }

    func stop() {
    }

    var currentItemTitle: String? = nil

    var currentItemEventId: String? = nil

    var currentItemStreamId: String? = nil

    var currentItemStreamURL: URL? = nil

    var currentItemIsLive: Bool? = nil

    var isNativeMLS: Bool? = nil
}
#endif
