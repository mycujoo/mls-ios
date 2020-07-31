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

        var playButtonTapped: (() -> Void)? = nil

        beforeEach {
            currentDuration = 200
            currentTime = 90
            optimisticCurrentTime = 100

            self.event = MLSSDK.Event(id: "mockevent", title: "Mock Event", descriptionText: "This is a mock event", thumbnailUrl: nil, organiser: nil, timezone: nil, startTime: Date().addingTimeInterval(-1 * 1000 * 3600 * 24), status: .started, streams: [MLSSDK.Stream(fullUrl: URL(string: "https://playlists.mycujoo.football/eu/ckc5yrypyhqg00hew7gyw9p34/master.m3u8")!)], timelineIds: [])

            self.mockView = MockVideoPlayerViewProtocol()
            stub(self.mockView) { mock in
                var controlViewHasAlpha = false

                when(mock).videoSlider.get.thenReturn(VideoProgressSlider())

                when(mock).primaryColor.get.thenReturn(.white)
                when(mock).primaryColor.set(any()).thenDoNothing()
                when(mock).secondaryColor.get.thenReturn(.red)
                when(mock).secondaryColor.set(any()).thenDoNothing()
                when(mock).controlViewHasAlpha.get.then { _ -> Bool in
                    return controlViewHasAlpha
                }
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
                when(mock).setOnPlayButtonTapped(any()).then { action in
                    playButtonTapped = action
                }
                when(mock).setOnSkipBackButtonTapped(any()).thenDoNothing()
                when(mock).setOnSkipForwardButtonTapped(any()).thenDoNothing()
                when(mock).setOnTimeSliderSlide(any()).thenDoNothing()
                when(mock).setOnTimeSliderRelease(any()).thenDoNothing()
                when(mock).setControlViewVisibility(visible: any(), animated: any()).then { (tuple) in
                    controlViewHasAlpha = tuple.0
                }
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
            beforeEach {
                self.videoPlayer.event = self.event
            }

            it("sets the correct slider value on event load") {
                expect(self.mockView.videoSlider.value).to(equal(0.0))
            }

            describe("slider value") {
                it("it updaets the slider value when the duration/current time changes") {
                    updatePeriodicTimeObserver()
                    expect(self.mockView.videoSlider.value).toEventually(equal(optimisticCurrentTime / currentDuration))
                }
                it("it does not update the slider value while seeking and the time changes") {
                    let sliderValueBefore = self.mockView.videoSlider.value
                    stub(self.mockAVPlayer) { mock in
                        when(mock).isSeeking.get.thenReturn(true)
                    }
                    updatePeriodicTimeObserver()
                    expect(self.mockView.videoSlider.value).toEventually(equal(sliderValueBefore))
                }
            }

            describe("live state") {
                it("gets live state correctly") {
                     stub(self.mockAVPlayer) { mock in
                        when(mock).currentDuration.get.thenReturn(500)
                        when(mock).currentTime.get.thenReturn(500)
                        when(mock).optimisticCurrentTime.get.thenReturn(500)
                        when(mock).currentDurationAsCMTime.get.thenReturn(CMTime.positiveInfinity)
                    }

                    expect(self.videoPlayer.isLivestream).to(beTrue())

                    stub(self.mockAVPlayer) { mock in
                        when(mock).currentDuration.get.thenReturn(500)
                        when(mock).currentTime.get.thenReturn(0)
                        when(mock).optimisticCurrentTime.get.thenReturn(0)
                        when(mock).currentDurationAsCMTime.get.thenReturn(CMTime(seconds: 500, preferredTimescale: 1))
                    }

                    expect(self.videoPlayer.isLivestream).to(beFalse())
                }
            }

            describe("player state") {
                it("does not set state to ended when duration and currenttime match but it is a livestream") {

                }

                it("sets state to ended when duration and currenttime match and it is not a livestream") {

                }
            }

            it("calls delegate with slider update") {
                class Delegate: PlayerDelegate {
                    var called = false

                    func playerDidUpdatePlaying(player: VideoPlayer) {}
                    func playerDidUpdateState(player: VideoPlayer) {}
                    func playerDidUpdateFullscreen(player: VideoPlayer) {}
                    func playerDidUpdateTime(player: VideoPlayer) {
                        called = true
                    }
                }
                let delegate = Delegate()
                self.videoPlayer.delegate = delegate

                updatePeriodicTimeObserver()

                expect(delegate.called).toEventually(beTrue())
            }
        }

        describe("showing and hiding overlays") {
            beforeEach {
                self.videoPlayer.event = self.event
            }

            it("places, removes and replaces overlays when currentTime changes and annotation actions are triggered") {
                stub(self.mockAnnotationService) { mock in
                    var calledAmount = 0
                    when(mock).evaluate(any(), callback: any()).then { (tuple) in
                        let showOverlays: [MLSUI.ShowOverlayAction]
                        let hideOverlays: [MLSUI.HideOverlayAction]
                        switch calledAmount {
                        case 0:
                            showOverlays = []
                            hideOverlays = []
                        case 1:
                            showOverlays = [MLSUI.ShowOverlayAction(
                                actionId: "randshowaction1",
                                overlay: Overlay(id: "abc", svgURL: URL(string: "https://mocked.mycujoo.tv/mocked.svg")!),
                                position: AnnotationActionShowOverlay.Position(top: 5, bottom: nil, vcenter: nil, right: nil, left: 5, hcenter: nil),
                                size: AnnotationActionShowOverlay.Size(width: 20, height: nil),
                                animateType: .none,
                                animateDuration: 0.0,
                                variables: [])]
                            hideOverlays = []
                        case 2:
                            showOverlays = []
                            hideOverlays = [MLSUI.HideOverlayAction(
                                actionId: "randhideaction1",
                                overlayId: "abc",
                                animateType: .none,
                                animateDuration: 0.0)]
                        case 3:
                            showOverlays = [MLSUI.ShowOverlayAction(
                                actionId: "randshowaction2",
                                overlay: Overlay(id: "abc", svgURL: URL(string: "https://mocked.mycujoo.tv/mocked.svg")!),
                                position: AnnotationActionShowOverlay.Position(top: 5, bottom: nil, vcenter: nil, right: nil, left: 5, hcenter: nil),
                                size: AnnotationActionShowOverlay.Size(width: 20, height: nil),
                                animateType: .none,
                                animateDuration: 0.0,
                                variables: [])]
                            hideOverlays = []
                        case 4:
                            showOverlays = [MLSUI.ShowOverlayAction(
                                actionId: "randshowaction2",
                                overlay: Overlay(id: "abc", svgURL: URL(string: "https://mocked.mycujoo.tv/mocked.svg")!),
                                position: AnnotationActionShowOverlay.Position(top: 5, bottom: nil, vcenter: nil, right: nil, left: 5, hcenter: nil),
                                size: AnnotationActionShowOverlay.Size(width: 20, height: nil),
                                animateType: .none,
                                animateDuration: 0.0,
                                variables: [])]
                            hideOverlays = []
                        default:
                            hideOverlays = []
                            showOverlays = []
                        }

                        calledAmount += 1

                        (tuple.1)(AnnotationService.EvaluationOutput(showTimelineMarkers: [], showOverlays: showOverlays, hideOverlays: hideOverlays, activeOverlayIds: Set(), tovs: [:]))
                    }
                }

                waitUntil(timeout: 2.0) { done in
                    // The first call should not trigger a show overlay at all.
                    updatePeriodicTimeObserver()

                    // The showOverlays method may make calls asynchronously, so wait for a brief period.
                    let _ = Timer.scheduledTimer(withTimeInterval: 0.2, repeats: false) { timer in
                        verify(self.mockView, times(0)).placeOverlay(imageView: any(), size: any(), position: any(), animateType: any(), animateDuration: any())

                        // The second call should trigger a show overlay, which PLACES an overlay.
                        updatePeriodicTimeObserver()
                        let _ = Timer.scheduledTimer(withTimeInterval: 0.2, repeats: false) { timer in
                            verify(self.mockView, times(1)).placeOverlay(imageView: any(), size: any(), position: any(), animateType: any(), animateDuration: any())

                            // The third call should trigger a hide overlay.
                            updatePeriodicTimeObserver()
                            let _ = Timer.scheduledTimer(withTimeInterval: 0.2, repeats: false) { timer in
                                verify(self.mockView, times(1)).removeOverlay(containerView: any(), animateType: any(), animateDuration: any(), completion: any())

                                // The fourth call should trigger a show overlay, with PLACES an overlay again (because it was removed before).
                                updatePeriodicTimeObserver()
                                let _ = Timer.scheduledTimer(withTimeInterval: 0.2, repeats: false) { timer in
                                    verify(self.mockView, times(2)).placeOverlay(imageView: any(), size: any(), position: any(), animateType: any(), animateDuration: any())

                                    // The fifth call should trigger a show overlay, with REPLACES an overlay (because it already exists onscreen)
                                    updatePeriodicTimeObserver()
                                    let _ = Timer.scheduledTimer(withTimeInterval: 0.2, repeats: false) { timer in
                                        verify(self.mockView, times(1)).replaceOverlay(containerView: any(), imageView: any())
                                        done()
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }

        describe("control view visibility") {
            it("remains invisible after an event is loaded") {
                expect(self.mockView.controlViewHasAlpha).to(beFalse())

                self.videoPlayer.event = self.event

                expect(self.mockView.controlViewHasAlpha).toEventually(beFalse())
            }
        }

        describe("button interactions") {

            beforeEach {
                self.videoPlayer.event = self.event
            }

            describe("play button taps") {
                it("switches from pause to play") {
                    expect(self.videoPlayer.status).to(equal(.pause))
                    playButtonTapped?()
                    expect(self.videoPlayer.status).to(equal(.play))
                }

                it("switches from play to pause") {
                    expect(self.videoPlayer.status).to(equal(.pause))
                    playButtonTapped?()
                    playButtonTapped?()
                    expect(self.videoPlayer.status).to(equal(.pause))
                }

                it("Seeks to beginning if state is currently ended") {
                    // TODO: Set state to ended on videoPlayer.
                    // Then, evaluate behavior on play button tap.
                }
            }
        }
    }
}

