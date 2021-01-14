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
            posterUrl: nil,
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
            error: withError ? MLSSDK.Stream.Err.init(code: .geoblocked, message: "") : nil)
    }

    static func buildAnnotationActionForShowOverlay() -> MLSSDK.AnnotationAction {
        return MLSSDK.AnnotationAction(
            id: randomString(length: 20),
            offset: 2000,
            timestamp: 0,
            data: AnnotationActionData
                .showOverlay(
                    AnnotationActionShowOverlay(
                        customId: "scoreboard",
                        svgURL: URL(string: "https://svg.mycujoo.com/v1/0zkVKiFpwFvVNxtvIf_vZDeqgJc.svg")!,
                        position: .init(top: 5, bottom: nil, vcenter: nil, right: 5, left: nil, hcenter: nil),
                        size: .init(width: 23, height: nil),
                        animateinType: .fadeIn,
                        animateoutType: .fadeOut,
                        animateinDuration: 300,
                        animateoutDuration: 300,
                        duration: nil,
                        variables: ["$home_score", "$away_score", "$main_timer"])))
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
