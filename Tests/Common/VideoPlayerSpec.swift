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

    var mockTimelineRepository: MockTimelineRepository!
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
        var periodicTimeObserverCallback: ((CMTime) -> Void)? = nil
        /// A helper to mock the duration on the video.
        var currentDuration: Double = 0
        /// A helper to mock the currentTime on the video.
        var currentTime: Double = 0
        /// A helper to mock the optimisticCurrentTime on the video.
        var optimisticCurrentTime: Double = 0

        var avPlayerStatus: AVPlayer.Status = .unknown

        /// Can be called to trigger an invokation on the Observer of time on the AVPlayer.
        /// - note: The duration and current time of the player will increase with 1 on every call to this method.
        func updatePeriodicTimeObserver() {
            currentDuration += 1
            currentTime += 1
            optimisticCurrentTime += 1

            periodicTimeObserverCallback?(CMTime(value: CMTimeValue(currentTime), timescale: 1))
        }

        func updateAVPlayerStatus(to status: AVPlayer.Status) {
            avPlayerStatus = status
            self.videoPlayer.observeValue(forKeyPath: "status", of: self.mockAVPlayer, change: [:], context: nil)
        }

        var playButtonTapped: (() -> Void)? = nil
        var infoButtonTapped: (() -> Void)? = nil
        var controlViewTapped: (() -> Void)? = nil

        beforeEach {
            currentDuration = 200
            currentTime = 90
            optimisticCurrentTime = 100

            self.event = EntityBuilder.buildEvent()

            self.mockView = MockVideoPlayerViewProtocol()
            stub(self.mockView) { mock in
                var controlViewHasAlpha = false
                var infoViewHasAlpha = false

                when(mock).videoSlider.get.thenReturn(VideoProgressSlider())

                when(mock).primaryColor.get.thenReturn(.white)
                when(mock).primaryColor.set(any()).thenDoNothing()
                when(mock).secondaryColor.get.thenReturn(.red)
                when(mock).secondaryColor.set(any()).thenDoNothing()
                when(mock).controlViewHasAlpha.get.then { _ -> Bool in
                    return controlViewHasAlpha
                }
                when(mock).infoViewHasAlpha.get.then { _ -> Bool in
                    return infoViewHasAlpha
                }
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
                when(mock).setControlViewVisibility(visible: any(), animated: any()).then { tuple in
                    controlViewHasAlpha = tuple.0
                }
                when(mock).setInfoViewVisibility(visible: any(), animated: any()).then { tuple in
                    infoViewHasAlpha = tuple.0
                }
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
                when(mock).setOnControlViewTapped(any()).then { action in
                    controlViewTapped = action
                }
                when(mock).setOnLiveButtonTapped(any()).thenDoNothing()
                when(mock).setOnFullscreenButtonTapped(any()).thenDoNothing()
                when(mock).setOnInfoButtonTapped(any()).then { action in
                    infoButtonTapped = action
                }
                when(mock).setFullscreenButtonTo(fullscreen: any()).thenDoNothing()
                when(mock).setSkipButtons(hidden: any()).thenDoNothing()
            }

            self.mockAVPlayer = MockMLSAVPlayerProtocol()
            stub(self.mockAVPlayer) { mock in
                when(mock).addObserver(any(), forKeyPath: any(), options: any(), context: any()).thenDoNothing()
                when(mock).addPeriodicTimeObserver(forInterval: any(), queue: any(), using: any()).then { (tuple) -> Any in
                    periodicTimeObserverCallback = tuple.2
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
                when(mock).status.get.then { _ -> AVPlayer.Status in
                    return avPlayerStatus
                }
                when(mock).isSeeking.get.thenReturn(false)
                when(mock).isMuted.get.thenReturn(true)
                when(mock).isMuted.set(any()).thenDoNothing()
                when(mock).play().thenDoNothing()
                when(mock).pause().thenDoNothing()
                when(mock).replaceCurrentItem(with: any(), headers: any(), callback: any()).then { (tuple) in
                    (tuple.2)(true)
                }
                when(mock).seek(by: any(), toleranceBefore: any(), toleranceAfter: any(), debounceSeconds: any(), completionHandler: any()).then { (tuple) in
                    (tuple.4)(true)
                }
                when(mock).seek(to: any(), toleranceBefore: any(), toleranceAfter: any(), debounceSeconds: any(), completionHandler: any()).then { (tuple) in
                    (tuple.4)(true)
                }
                when(mock).seek(to: any(), toleranceBefore: any(), toleranceAfter: any(), completionHandler: any()).then { (tuple) in
                    (tuple.3)(true)
                }
            }

            self.mockAnnotationService = MockAnnotationServicing()
            stub(self.mockAnnotationService) { mock in
                when(mock).evaluate(any(), callback: any()).then { (tuple) in
                    (tuple.1)(AnnotationService.EvaluationOutput(showTimelineMarkers: [], showOverlays: [], hideOverlays: [], activeOverlayIds: Set(), tovs: [:]))
                }
            }

            self.mockTimelineRepository = MockTimelineRepository()
            self.mockArbitraryDataRepository = MockArbitraryDataRepository()
            self.mockEventRepository = MockEventRepository()
            self.mockPlayerConfigRepository = MockPlayerConfigRepository()

            stub(self.mockEventRepository) { mock in
                when(mock).startEventUpdates(for: any(), callback: any()).thenDoNothing()
                when(mock).stopEventUpdates(for: any()).thenDoNothing()
            }

            stub(self.mockPlayerConfigRepository) { mock in
                when(mock).fetchPlayerConfig(callback: any()).then { callback in
                    callback(MLSSDK.PlayerConfig.standard(), nil)
                }
            }

            stub(self.mockTimelineRepository) { mock in
                when(mock).fetchAnnotationActions(byTimelineId: any(), callback: any()).then { tuple in
                    (tuple.1)([], nil)
                }
                when(mock).startTimelineUpdates(for: any(), callback: any()).thenDoNothing()
                when(mock).stopTimelineUpdates(for: any()).thenDoNothing()
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

            self.videoPlayer = VideoPlayer(view: self.mockView, player: self.mockAVPlayer, getEventUpdatesUseCase: GetEventUpdatesUseCase(eventRepository: self.mockEventRepository), getAnnotationActionsForTimelineUseCase: GetAnnotationActionsForTimelineUseCase(timelineRepository: self.mockTimelineRepository), getPlayerConfigUseCase: GetPlayerConfigUseCase(playerConfigRepository: self.mockPlayerConfigRepository), getSVGUseCase: GetSVGUseCase(arbitraryDataRepository: self.mockArbitraryDataRepository), annotationService: self.mockAnnotationService)
        }

        describe("loading events") {
            it("replaces avplayer item") {
                waitUntil { done in
                    self.videoPlayer.event = self.event

                    // The replaceCurrentItem method may get called asynchronously, so wait for a brief period.
                    let _ = Timer.scheduledTimer(withTimeInterval: 0.2, repeats: false) { timer in
                        verify(self.mockAVPlayer, times(1)).replaceCurrentItem(with: any(), headers: any(), callback: any())

                        done()
                    }
                }

            }

            it("it replaces avplayer item when the stream id is the same but the url became available") {
                waitUntil { done in
                    self.videoPlayer.event = EntityBuilder.buildEvent(withRandomId: false, withStream: true, withStreamURL: false)

                    // The replaceCurrentItem method may get called asynchronously, so wait for a brief period.
                    let _ = Timer.scheduledTimer(withTimeInterval: 0.2, repeats: false) { timer in
                        verify(self.mockAVPlayer, times(1)).replaceCurrentItem(with: Cuckoo.isNil(), headers: any(), callback: any())

                        self.videoPlayer.event = EntityBuilder.buildEvent(withRandomId: false, withStream: true, withStreamURL: true)
                        let _ = Timer.scheduledTimer(withTimeInterval: 0.2, repeats: false) { timer in
                            verify(self.mockAVPlayer, times(1)).replaceCurrentItem(with: Cuckoo.notNil(), headers: any(), callback: any())

                            done()
                        }
                    }
                }
            }

            it("does not replace avplayer item when the stream url for the same stream id changes to another stream url") {
                waitUntil { done in
                    self.videoPlayer.event = EntityBuilder.buildEvent(withRandomId: false, withStream: true, withStreamURL: true, withRandomStreamURL: true)

                    // The replaceCurrentItem method may get called asynchronously, so wait for a brief period.
                    let _ = Timer.scheduledTimer(withTimeInterval: 0.2, repeats: false) { timer in
                        verify(self.mockAVPlayer, times(1)).replaceCurrentItem(with: any(), headers: any(), callback: any())

                        self.videoPlayer.event = EntityBuilder.buildEvent(withRandomId: false, withStream: true, withStreamURL: true, withRandomStreamURL: true)

                        let _ = Timer.scheduledTimer(withTimeInterval: 0.2, repeats: false) { timer in
                            // The item should not have been replaced.
                            verify(self.mockAVPlayer, times(1)).replaceCurrentItem(with: any(), headers: any(), callback: any())

                            done()
                        }
                    }
                }
            }
        }

        describe("info layer") {
            it("shows the info layer when there is no stream") {
                verify(self.mockView, times(0)).setInfoViewVisibility(visible: true, animated: any())

                self.videoPlayer.event = EntityBuilder.buildEvent(withStream: true, withStreamURL: false)

                verify(self.mockView, times(1)).setInfoViewVisibility(visible: true, animated: any())
            }

            it("does not allow info layer dismissal when there is no stream") {
                self.videoPlayer.event = EntityBuilder.buildEvent(withStream: true, withStreamURL: false)

                verify(self.mockView, times(1)).setInfoViewVisibility(visible: true, animated: any())

                controlViewTapped?()

                // Verify the count did not go up.
                verify(self.mockView, times(1)).setInfoViewVisibility(visible: true, animated: any())
            }

            it("dismisses info layer on controlview tapped when there is a stream") {
                self.videoPlayer.event = EntityBuilder.buildEvent(withStream: true, withStreamURL: true)

                verify(self.mockView, times(1)).setInfoViewVisibility(visible: false, animated: any())

                infoButtonTapped?()

                verify(self.mockView, times(1)).setInfoViewVisibility(visible: true, animated: any())

                controlViewTapped?()

                verify(self.mockView, times(2)).setInfoViewVisibility(visible: false, animated: any())
            }

            it("hides the info layer when a stream url appears on a previously loaded event") {
                self.videoPlayer.event = EntityBuilder.buildEvent(withRandomId: false, withStream: true, withStreamURL: false)

                verify(self.mockView, times(1)).setInfoViewVisibility(visible: true, animated: any())

                self.videoPlayer.event = EntityBuilder.buildEvent(withRandomId: false, withStream: true, withStreamURL: true)

                verify(self.mockView, times(1)).setInfoViewVisibility(visible: false, animated: any())
            }

            it("does not show info layer again when the same event/stream is updated") {
                let event = EntityBuilder.buildEvent(withRandomId: false, withStream: true, withStreamURL: false)
                self.videoPlayer.event = event

                verify(self.mockView, times(1)).setInfoViewVisibility(visible: true, animated: any())

                self.videoPlayer.event = event

                verify(self.mockView, times(1)).setInfoViewVisibility(visible: true, animated: any())
            }

            it("shows an upcoming poster and no info view when it is available and there is no stream") {

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
                beforeEach {
                    updateAVPlayerStatus(to: .readyToPlay)
                }
                it("does not set state to ended when duration and currenttime match but it is a livestream") {
                    stub(self.mockAVPlayer) { mock in
                        when(mock).currentDuration.get.thenReturn(500)
                        when(mock).currentTime.get.thenReturn(500)
                        when(mock).optimisticCurrentTime.get.thenReturn(500)
                        when(mock).currentDurationAsCMTime.get.thenReturn(.positiveInfinity)
                    }

                    expect(self.videoPlayer.state).to(equal(.readyToPlay))

                    periodicTimeObserverCallback?(CMTime(seconds: 500, preferredTimescale: 1))

                    expect(self.videoPlayer.state).toEventually(equal(.readyToPlay))
                }

                it("sets state to ended when duration and currenttime match and it is not a livestream") {
                    stub(self.mockAVPlayer) { mock in
                        when(mock).currentDuration.get.thenReturn(500)
                        when(mock).currentTime.get.thenReturn(500)
                        when(mock).optimisticCurrentTime.get.thenReturn(500)
                        when(mock).currentDurationAsCMTime.get.thenReturn(CMTime(seconds: 500, preferredTimescale: 1))
                    }

                    expect(self.videoPlayer.state).to(equal(.readyToPlay))

                    periodicTimeObserverCallback?(CMTime(seconds: 500, preferredTimescale: 1))

                    expect(self.videoPlayer.state).toEventually(equal(.ended))
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
                    // Keep in mind that this is initial status is dependent on autoplay being set on the PlayerConfig.
                    expect(self.videoPlayer.status).to(equal(.play))
                    playButtonTapped?()
                    expect(self.videoPlayer.status).to(equal(.pause))
                }

                it("switches from play to pause") {
                    expect(self.videoPlayer.status).to(equal(.play))
                    playButtonTapped?()
                    playButtonTapped?()
                    expect(self.videoPlayer.status).to(equal(.play))
                }

                it("Seeks to beginning if state is currently ended") {
                    updateAVPlayerStatus(to: .readyToPlay)
                    stub(self.mockAVPlayer) { mock in
                        when(mock).currentDuration.get.thenReturn(500)
                        when(mock).currentTime.get.thenReturn(500)
                        when(mock).optimisticCurrentTime.get.thenReturn(500)
                        when(mock).currentDurationAsCMTime.get.thenReturn(CMTime(seconds: 500, preferredTimescale: 1))
                    }

                    waitUntil { done in
                        // Force the player to set the .ended state by updating the current time info.
                        periodicTimeObserverCallback?(CMTime(seconds: 500, preferredTimescale: 1))
                        let _ = Timer.scheduledTimer(withTimeInterval: 0.2, repeats: false) { timer in
                            playButtonTapped?()
                            verify(self.mockAVPlayer).seek(to: any(), toleranceBefore: any(), toleranceAfter: any(), completionHandler: any())
                            done()
                        }
                    }
                }
            }
        }
    }
}

