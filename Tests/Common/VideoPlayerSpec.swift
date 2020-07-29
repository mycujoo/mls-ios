//
// Copyright © 2020 mycujoo. All rights reserved.
//

import Foundation
import Quick
import Nimble
import Cuckoo
import AVFoundation
@testable import MLSSDK


class VideoPlayerSpec: QuickSpec {

    var mockView: MockVideoPlayerViewProtocol!
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
        /// Should be set by the `addPeriodicTimeObserver` mock.
        var _periodicTimeObserverCallback: ((CMTime) -> Void)? = nil
        /// A helper to mock the duration on the video.
        var currentDuration: Double = 0
        /// A helper to mock the currentTime on the video.
        var currentTime: Double = 0
        /// A helper to mock the optimisticCurrentTime on the video.
        var optimisticCurrentTime: Double = 0

        /// Can be called to trigger an invokation on the Observer of time on the AVPlayer.
        /// - note: The duration and current time of the player will increase with 1 on every call to this method.
        func updatePeriodicTimeObserver() {
            currentDuration += 1
            currentTime += 1
            optimisticCurrentTime += 1

            _periodicTimeObserverCallback?(CMTime(value: CMTimeValue(currentTime), timescale: 1))
        }

        beforeEach {
            currentDuration = 200
            currentTime = 90
            optimisticCurrentTime = 100

            self.event = MLSSDK.Event(id: "mockevent", title: "Mock Event", descriptionText: "This is a mock event", thumbnailUrl: nil, organiser: nil, timezone: nil, startTime: Date().addingTimeInterval(-1 * 1000 * 3600 * 24), status: .started, streams: [MLSSDK.Stream(fullUrl: URL(string: "https://playlists.mycujoo.football/eu/ckc5yrypyhqg00hew7gyw9p34/master.m3u8")!)], timelineIds: [])

            self.mockView = MockVideoPlayerViewProtocol()
            stub(self.mockView) { mock in
                when(mock).videoSlider.get.thenReturn(VideoProgressSlider())

                when(mock).primaryColor.get.thenReturn(.white)
                when(mock).primaryColor.set(any()).thenDoNothing()
                when(mock).secondaryColor.get.thenReturn(.red)
                when(mock).secondaryColor.set(any()).thenDoNothing()
                when(mock).controlViewHasAlpha.get.thenReturn(false)
                when(mock).infoViewHasAlpha.get.thenReturn(false)
                when(mock).infoTitleLabel.get.thenReturn(UILabel())
                when(mock).infoDateLabel.get.thenReturn(UILabel())
                when(mock).infoDescriptionLabel.get.thenReturn(UILabel())
                when(mock).controlView.get.thenReturn(UIView())
                when(mock).playerLayer.get.thenReturn(AVPlayerLayer())
                when(mock).topControlsStackView.get.thenReturn(UIStackView())
                when(mock).fullscreenButtonIsHidden.get.thenReturn(false)
                when(mock).fullscreenButtonIsHidden.set(any()).thenDoNothing()
                when(mock).tapGestureRecognizer.get.thenReturn(UITapGestureRecognizer())

                when(mock).drawPlayer(with: any()).thenDoNothing()
                when(mock).setOnPlayButtonTapped(any()).thenDoNothing()
                when(mock).setOnSkipBackButtonTapped(any()).thenDoNothing()
                when(mock).setOnSkipForwardButtonTapped(any()).thenDoNothing()
                when(mock).setOnTimeSliderSlide(any()).thenDoNothing()
                when(mock).setOnTimeSliderRelease(any()).thenDoNothing()
                when(mock).setControlViewVisibility(visible: any(), animated: any()).thenDoNothing()
                when(mock).setInfoViewVisibility(visible: any(), animated: any()).thenDoNothing()
                when(mock).setPlayButtonTo(state: any()).thenDoNothing()
                when(mock).setLiveButtonTo(state: any()).thenDoNothing()
                when(mock).setBufferIcon(hidden: any()).thenDoNothing()
                when(mock).setInfoButtonAndView(hidden: any()).thenDoNothing()
                when(mock).setTimeIndicatorLabel(elapsedText: any(), totalText: any()).thenDoNothing()
                when(mock).setTimelineMarkers(with: any()).thenDoNothing()
                when(mock).placeOverlay(imageView: any(), size: any(), position: any(), animateType: any(), animateDuration: any()).thenReturn(UIView())
                when(mock).replaceOverlay(containerView: any(), imageView: any()).thenDoNothing()
                when(mock).removeOverlay(containerView: any(), animateType: any(), animateDuration: any(), completion: any()).then { (tuple) in
                    (tuple.3)()
                }
                when(mock).setOnControlViewTapped(any()).thenDoNothing()
                when(mock).setOnLiveButtonTapped(any()).thenDoNothing()
                when(mock).setOnFullscreenButtonTapped(any()).thenDoNothing()
                when(mock).setOnInfoButtonTapped(any()).thenDoNothing()
                when(mock).setFullscreenButtonTo(fullscreen: any()).thenDoNothing()
                when(mock).setSkipButtons(hidden: any()).thenDoNothing()
            }

            self.mockAVPlayer = MockMLSAVPlayerProtocol()
            stub(self.mockAVPlayer) { mock in
                when(mock).addObserver(any(), forKeyPath: any(), options: any(), context: any()).thenDoNothing()
                when(mock).addPeriodicTimeObserver(forInterval: any(), queue: any(), using: any()).then { (tuple) -> Any in
                    _periodicTimeObserverCallback = tuple.2
                    return ""
                }
                when(mock).removeObserver(any(), forKeyPath: any()).thenDoNothing()
                when(mock).removeTimeObserver(any()).thenDoNothing()
                when(mock).currentDuration.get.then { _ -> Double in
                    return currentDuration
                }
                when(mock).currentDurationAsCMTime.get.then { _ -> CMTime? in
                    return CMTime(seconds: currentDuration, preferredTimescale: 1)
                }
                when(mock).currentTime.get.then { _ -> Double in
                    return currentTime
                }
                when(mock).optimisticCurrentTime.get.then { _ -> Double in
                    return optimisticCurrentTime
                }
                when(mock).isSeeking.get.thenReturn(false)
                when(mock).isMuted.get.thenReturn(true)
                when(mock).isMuted.set(any()).thenDoNothing()
                when(mock).play().thenDoNothing()
                when(mock).pause().thenDoNothing()
                when(mock).replaceCurrentItem(with: any(), headers: any(), callback: any()).then { (tuple) in
                    (tuple.2)(true)
                }
            }

            self.mockAnnotationService = MockAnnotationServicing()
            stub(self.mockAnnotationService) { mock in
                when(mock).evaluate(any(), callback: any()).then { (tuple) in
                    (tuple.1)(AnnotationService.EvaluationOutput(showTimelineMarkers: [], showOverlays: [], hideOverlays: [], activeOverlayIds: Set(), tovs: [:]))
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
                    (tuple.1)([], nil)
                }
            }

            stub(self.mockArbitraryDataRepository) { mock in
                when(mock).fetchDataAsString(byURL: any(), callback: any()).then { tuple in
                    if tuple.0.absoluteString.contains(".svg"), let path = Bundle(for: type(of: self)).path(forResource: "scoreboard_and_timer", ofType: "svg") {
                        do {
                            let svg = try String(contentsOf: URL(fileURLWithPath: path))
                            (tuple.1)(svg, nil)
                        } catch {}
                    }
                }
            }

            self.videoPlayer = VideoPlayer(view: self.mockView, player: self.mockAVPlayer, getAnnotationActionsForTimelineUseCase: GetAnnotationActionsForTimelineUseCase(annotationActionRepository: self.mockAnnotationActionRepository), getPlayerConfigForEventUseCase: GetPlayerConfigForEventUseCase(playerConfigRepository: self.mockPlayerConfigRepository), getSVGUseCase: GetSVGUseCase(arbitraryDataRepository: self.mockArbitraryDataRepository), annotationService: self.mockAnnotationService)
        }

        describe("loading events") {
            it("replaces avplayer item") {
                self.videoPlayer.event = self.event

                // The replaceCurrentItem method may get called asynchronously, so wait for a brief period.
                let _ = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: false) { timer in
                    verify(self.mockAVPlayer, times(1)).replaceCurrentItem(with: any(), headers: any(), callback: any())
                }
            }
        }

        describe("updates as consequence of current time change") {
            it("correctly sets videoslider value") {

            }

            it("calls delegate with slider update") {

            }

            it("does not change anything when seeking") {

            }
        }

        describe("showing overlays") {

            it("shows an overlay as a consequence of a current time change") {
                var calledAmount = 0

                stub(self.mockAnnotationService) { mock in
                    when(mock).evaluate(any(), callback: any()).then { (tuple) in
                        let showOverlays: [MLSUI.ShowOverlayAction]
                        if calledAmount == 0 {
                            // On the first time change, do NOT set any show overlays.
                            showOverlays = []
                        }
                        else {
                            showOverlays = [MLSUI.ShowOverlayAction(
                                actionId: "abc",
                                overlay: Overlay(id: "abc", svgURL: URL(string: "https://mocked.mycujoo.tv/mocked.svg")!),
                                position: AnnotationActionShowOverlay.Position(top: 5, bottom: nil, vcenter: nil, right: nil, left: 5, hcenter: nil),
                                size: AnnotationActionShowOverlay.Size(width: 20, height: nil),
                                animateType: .none,
                                animateDuration: 0.0,
                                variables: [])]
                        }

                        calledAmount += 1

                        (tuple.1)(AnnotationService.EvaluationOutput(showTimelineMarkers: [], showOverlays: showOverlays, hideOverlays: [], activeOverlayIds: Set(), tovs: [:]))
                    }
                }

                updatePeriodicTimeObserver()

                // TODO: Mock the view so that it can be spied.


            }


        }

    }
}

