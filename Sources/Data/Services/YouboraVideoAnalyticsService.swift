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

    private let NA = "N/A"

    init(pseudoUserId: String) {
        self.pseudoUserId = pseudoUserId
    }

    func create(with player: MLSAVPlayerProtocol) {
        // Only add the adapter in real scenarios. When running unit tests with a mocked player, there will not be a youbora plugin.
        guard let avPlayer = player as? AVPlayer else { return }

        let options = YBOptions()
        options.accountCode = "mycujoo"
        options.username = pseudoUserId
        plugin = YBPlugin(options: options)
        plugin?.adapter = YBAVPlayerAdapterSwiftTranformer.transform(from: YBAVPlayerAdapter(player: avPlayer))
        
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
}
#else
/* If Youbora cannot be imported, fallback to a non-functional, empty service. */
class YouboraVideoAnalyticsService: VideoAnalyticsServicing {
    private let pseudoUserId: String

    init(pseudoUserId: String) {
        self.pseudoUserId = pseudoUserId
    }

    func create(with player: MLSAVPlayerProtocol) {
    }

    func stop() {
    }

    var currentItemTitle: String? = nil

    var currentItemEventId: String? = nil

    var currentItemStreamId: String? = nil

    var currentItemStreamURL: URL? = nil

    var currentItemIsLive: Bool? = nil
}
#endif
