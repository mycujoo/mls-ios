//
// Copyright © 2020 mycujoo. All rights reserved.
//

import Foundation
@testable import MLSSDK

class EntityBuilder {
    static func buildEvent(withRandomId: Bool = true, withStream: Bool = true, withStreamURL: Bool = true, withRandomStreamURL: Bool = false, withTimelineId: Bool = false) -> MLSSDK.Event {
        return MLSSDK.Event(
            id: withRandomId ? randomString(length: 20) : "mockevent",
            title: "Mock Event",
            descriptionText: "This is a mock event",
            thumbnailUrl: nil,
            organiser: nil,
            timezone: nil,
            startTime: Date().addingTimeInterval(-1 * 1000 * 3600 * 24),
            status: .started,
            streams: withStream ? [buildStream(withRandomId: withRandomId, withURL: withStreamURL, withRandomURL: withRandomStreamURL)] : [],
            timelineIds: withTimelineId ? ["randomTimelineId"] : [], isMLS: true)
    }

    static func buildStream(withRandomId: Bool = true, withURL: Bool = true, withRandomURL: Bool = false, withShortDVRWindow: Bool = false, withError: Bool = false) -> MLSSDK.Stream {
        return MLSSDK.Stream(
            id: withRandomId ? randomString(length: 20) : "mockstream",
            fullUrl: !withError && withURL ? URL(string: "https://playlists.mycujoo.football/eu/ckc5yrypyhqg00hew7gyw9p34/master.m3u8" + (withRandomURL ? "?randomizer=" + randomString(length: 20) : ""))! : nil,
            fairplay: nil,
            dvrWindowSize: withShortDVRWindow ? 40000 : 7200000,
            errorCode: withError ? .geoblocked : nil)
    }

    private static func randomString(length: Int) -> String {
        let letters : NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        let len = UInt32(letters.length)

        var randomString = ""

        for _ in 0 ..< length {
            let rand = arc4random_uniform(len)
            var nextChar = letters.character(at: Int(rand))
            randomString += NSString(characters: &nextChar, length: 1) as String
        }

        return randomString
    }
}
