//
// Copyright © 2020 mycujoo. All rights reserved.
//

import Foundation
import Quick
import Nimble
import Cuckoo
@testable import MLSSDK


class VideoPlayerSpec: QuickSpec {

    var mockAVPlayer: MLSAVPlayerProtocol!
    var mockAnnotationService: AnnotationServicing!

    var mockAnnotationActionRepository: AnnotationActionRepository!
    var mockArbitraryDataRepository: ArbitraryDataRepository!
    var mockEventRepository: EventRepository!
    var mockPlayerConfigRepository: PlayerConfigRepository!


    var videoPlayer: VideoPlayer!

    override func setUp() {
         continueAfterFailure = false
    }

    override func spec() {
        beforeEach {
            self.mockAVPlayer = MockMLSAVPlayerProtocol()
            self.mockAnnotationService = MockAnnotationServicing()

            stub(self.mockAVPlayer as! MockMLSAVPlayerProtocol) { mock in
                when(mock).addObserver(any(), forKeyPath: any(), options: any(), context: any()).thenDoNothing()
                when(mock).addPeriodicTimeObserver(forInterval: any(), queue: any(), using: any()).thenReturn("")
                when(mock).removeObserver(any(), forKeyPath: any()).thenDoNothing()
                when(mock).removeTimeObserver(any()).thenDoNothing()
                when(mock).isMuted.get.thenReturn(true)
                when(mock).isMuted.set(any()).thenDoNothing()
            }

            self.mockAnnotationActionRepository = MockAnnotationActionRepository()
            self.mockArbitraryDataRepository = MockArbitraryDataRepository()
            self.mockEventRepository = MockEventRepository()
            self.mockPlayerConfigRepository = MockPlayerConfigRepository()

            self.videoPlayer = VideoPlayer(player: self.mockAVPlayer, getAnnotationActionsForTimelineUseCase: GetAnnotationActionsForTimelineUseCase(annotationActionRepository: self.mockAnnotationActionRepository), getPlayerConfigForEventUseCase: GetPlayerConfigForEventUseCase(playerConfigRepository: self.mockPlayerConfigRepository), getSVGUseCase: GetSVGUseCase(arbitraryDataRepository: self.mockArbitraryDataRepository), annotationService: self.mockAnnotationService)
        }

        fit("first test") {
            expect(true).to(beTrue())
        }

    }
}

