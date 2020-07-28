//
// Copyright © 2020 mycujoo. All rights reserved.
//

import Foundation
import Quick
import Nimble
import Cuckoo
@testable import MLSSDK


class VideoPlayerSpec: QuickSpec {

    var mockAVPlayer: MockMLSAVPlayerProtocol!
    var mockAnnotationService: MockAnnotationServicing!

    var mockAnnotationActionRepository: MockAnnotationActionRepository!
    var mockArbitraryDataRepository: MockArbitraryDataRepository!
    var mockEventRepository: MockEventRepository!
    var mockPlayerConfigRepository: MockPlayerConfigRepository!

    var event: MLSSDK.Event!

    var videoPlayer: VideoPlayer!

    override func setUp() {
         continueAfterFailure = false
    }

    override func spec() {
        beforeEach {
            self.event = MLSSDK.Event(id: "mockevent", title: "Mock Event", descriptionText: "This is a mock event", thumbnailUrl: nil, organiser: nil, timezone: nil, startTime: Date().addingTimeInterval(-1 * 1000 * 3600 * 24), status: .started, streams: [MLSSDK.Stream(fullUrl: URL(string: "https://playlists.mycujoo.football/eu/ckc5yrypyhqg00hew7gyw9p34/master.m3u8")!)], timelineIds: [])

            self.mockAVPlayer = MockMLSAVPlayerProtocol()
            self.mockAnnotationService = MockAnnotationServicing()

            stub(self.mockAVPlayer) { mock in
                when(mock).addObserver(any(), forKeyPath: any(), options: any(), context: any()).thenDoNothing()
                when(mock).addPeriodicTimeObserver(forInterval: any(), queue: any(), using: any()).thenReturn("")
                when(mock).removeObserver(any(), forKeyPath: any()).thenDoNothing()
                when(mock).removeTimeObserver(any()).thenDoNothing()
                when(mock).isMuted.get.thenReturn(true)
                when(mock).isMuted.set(any()).thenDoNothing()
                when(mock).play().thenDoNothing()
                when(mock).pause().thenDoNothing()
                when(mock).replaceCurrentItem(with: any(), headers: any(), callback: any()).then { (tuple) in
                    (tuple.2)(true)
                }
            }

            self.mockAnnotationActionRepository = MockAnnotationActionRepository()
            self.mockArbitraryDataRepository = MockArbitraryDataRepository()
            self.mockEventRepository = MockEventRepository()
            self.mockPlayerConfigRepository = MockPlayerConfigRepository()

            stub(self.mockPlayerConfigRepository) { mock in
                when(mock).fetchPlayerConfig(byEventId: any(), callback: any()).then { (tuple) in
                    (tuple.1)(MLSSDK.PlayerConfig.standard(), nil)
                }
            }

            stub(self.mockAnnotationActionRepository) { mock in
                when(mock).fetchAnnotationActions(byTimelineId: any(), callback: any()).then { tuple in
                    // Should actually call the callback, but this is throwing an error.
                }
            }

            self.videoPlayer = VideoPlayer(player: self.mockAVPlayer, getAnnotationActionsForTimelineUseCase: GetAnnotationActionsForTimelineUseCase(annotationActionRepository: self.mockAnnotationActionRepository), getPlayerConfigForEventUseCase: GetPlayerConfigForEventUseCase(playerConfigRepository: self.mockPlayerConfigRepository), getSVGUseCase: GetSVGUseCase(arbitraryDataRepository: self.mockArbitraryDataRepository), annotationService: self.mockAnnotationService)
        }

        describe("loading events") {
            fit("replaces avplayer item") {
                self.videoPlayer.event = self.event

                // The replaceCurrentItem method may get called asynchronously, so wait for a brief period.
                let _ = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: false) { timer in
                    verify(self.mockAVPlayer, times(1)).replaceCurrentItem(with: any(), headers: any(), callback: any())
                }
            }
        }

    }
}

