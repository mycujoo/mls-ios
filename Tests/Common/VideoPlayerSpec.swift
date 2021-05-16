//
// Copyright © 2020 mycujoo. All rights reserved.
//

import Foundation
import Quick
import Nimble
import Cuckoo
import AVFoundation
@testable import MLSSDK
@testable import MLSSDK_Annotations


class VideoPlayerSpec: QuickSpec {

    var mockView: MockVideoPlayerViewProtocol!
    var mockMLSPlayer: MockMLSPlayerProtocol!
    var mockIMAIntegration: MockIMAIntegration!
    var mockVideoAnalyticsService: MockVideoAnalyticsServicing!

    var mockEventRepository: MockMLSEventRepository!
    var mockPlayerConfigRepository: MockMLSPlayerConfigRepository!
    var mockDRMRepository: MockMLSDRMRepository!
    
    var annotationIntegration: MockAnnotationIntegration!

    var event: MLSSDK.Event!

    var videoPlayer: VideoPlayerImpl!

    override func setUp() {
         continueAfterFailure = false
    }

    override func spec() {
        /// A helper to mock the duration on the video.
        var currentDuration: Double = 0
        /// A helper to mock the currentTime on the video.
        var currentTime: Double = 0
        /// A helper to mock the optimisticCurrentTime on the video.
        var optimisticCurrentTime: Double = 0
        
        var timelineId: String?

        var avPlayerStatus: AVPlayer.Status = .unknown

        var playButtonTapped: (() -> Void)? = nil
        var infoButtonTapped: (() -> Void)? = nil
        var controlViewTapped: (() -> Void)? = nil
        var stateObserverCallback: (() -> Void)? = nil
        var timeObserverCallback: (() -> Void)? = nil
        var playObserverCallback: ((Bool) -> Void)? = nil

        /// Can be called to trigger an invokation on the Observer of time on the AVPlayer.
        /// - note: The duration and current time of the player will increase with 1 on every call to this method.
        func updatePeriodicTimeObserver() {
            currentDuration += 1
            currentTime += 1
            optimisticCurrentTime += 1

            timeObserverCallback?()
        }

        func updateAVPlayerStatus(to status: AVPlayer.Status) {
            avPlayerStatus = status
        }

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
                when(mock).topLeadingControlsStackView.get.thenReturn(UIStackView())
                when(mock).topTrailingControlsStackView.get.thenReturn(UIStackView())
                when(mock).fullscreenButtonIsHidden.get.thenReturn(false)
                when(mock).fullscreenButtonIsHidden.set(any()).thenDoNothing()
                when(mock).tapGestureRecognizer.get.thenReturn(UITapGestureRecognizer())
                when(mock).setNumberOfViewersTo(amount: any()).thenDoNothing()

                when(mock).drawPlayer(with: any()).thenDoNothing()
                when(mock).setOnPlayButtonTapped(any()).then { action in
                    playButtonTapped = action
                }
                when(mock).setOnSkipBackButtonTapped(any()).thenDoNothing()
                when(mock).setOnSkipForwardButtonTapped(any()).thenDoNothing()
                when(mock).setOnTimeSliderSlide(any()).thenDoNothing()
                when(mock).setOnTimeSliderRelease(any()).thenDoNothing()
                when(mock).setControlViewVisibility(visible: any(), withAnimationDuration: any()).then { tuple in
                    controlViewHasAlpha = tuple.0
                }
                when(mock).setInfoViewVisibility(visible: any(), withAnimationDuration: any()).then { tuple in
                    infoViewHasAlpha = tuple.0
                }
                when(mock).setPlayButtonTo(state: any()).thenDoNothing()
                when(mock).setLiveButtonTo(state: any()).thenDoNothing()
                when(mock).setControlView(hidden: any()).thenDoNothing()
                when(mock).setBufferIcon(hidden: any()).thenDoNothing()
                when(mock).setInfoButton(hidden: any()).thenDoNothing()
                when(mock).setAirplayButton(hidden: any()).thenDoNothing()
                when(mock).setTimeIndicatorLabel(elapsedText: any(), totalText: any()).thenDoNothing()
                when(mock).setTimelineMarkers(with: any()).thenDoNothing()
                when(mock).setOnControlViewTapped(any()).then { action in
                    controlViewTapped = action
                }
                when(mock).setTimeIndicatorLabel(hidden: any()).thenDoNothing()
                when(mock).setSeekbar(hidden: any()).thenDoNothing()
                when(mock).setOnLiveButtonTapped(any()).thenDoNothing()
                when(mock).setOnFullscreenButtonTapped(any()).thenDoNothing()
                when(mock).setOnInfoButtonTapped(any()).then { action in
                    infoButtonTapped = action
                }
                when(mock).setFullscreenButtonTo(fullscreen: any()).thenDoNothing()
                when(mock).setSkipButtons(hidden: any()).thenDoNothing()
            }

            self.mockMLSPlayer = MockMLSPlayerProtocol()
            stub(self.mockMLSPlayer) { mock in
                when(mock).state.get.thenReturn(.readyToPlay)
                when(mock).currentDuration.get.then { _ -> Double in
                    return currentDuration
                }
                when(mock).currentItemEnded.get.then { _ -> Bool in
                    return self.mockMLSPlayer.currentDuration > 0 && self.mockMLSPlayer.currentDuration <= self.mockMLSPlayer.optimisticCurrentTime && !self.mockMLSPlayer.isLivestream
                }
                when(mock).isLivestream.get.then { _ -> Bool in
                    return false
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
                when(mock).allowsExternalPlayback.get.thenReturn(true)
                when(mock).allowsExternalPlayback.set(any()).thenDoNothing()
                when(mock).isBuffering.get.thenReturn(false)
                when(mock).isSeeking.get.thenReturn(false)
                when(mock).isMuted.get.thenReturn(true)
                when(mock).isMuted.set(any()).thenDoNothing()
                when(mock).rate.get.thenReturn(1.0)
                when(mock).setRate(any()).thenDoNothing()
                when(mock).replaceCurrentItem(with: any(), headers: any(), resourceLoaderDelegate: any(), callback: any()).then { (tuple) in
                    (tuple.3)(true)
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
                when(mock).stateObserverCallback.get.thenReturn(stateObserverCallback)
                when(mock).stateObserverCallback.set(any()).then { obj in
                    stateObserverCallback = obj
                }
                when(mock).timeObserverCallback.get.thenReturn(timeObserverCallback)
                when(mock).timeObserverCallback.set(any()).then { obj in
                    timeObserverCallback = obj
                }
                when(mock).playObserverCallback.get.thenReturn(playObserverCallback)
                when(mock).playObserverCallback.set(any()).then { obj in
                    playObserverCallback = obj
                }
            }

            self.mockIMAIntegration = MockIMAIntegration()
            stub(self.mockIMAIntegration) { mock in
                when(mock).setAVPlayer(any()).thenDoNothing()
                when(mock).setAdUnit(any()).thenDoNothing()
                when(mock).setBasicCustomParameters(eventId: any(), streamId: any(), eventStatus: any()).thenDoNothing()
                when(mock).isShowingAd().thenReturn(false)
                when(mock).resume().thenDoNothing()
                when(mock).pause().thenDoNothing()
                when(mock).playPostroll().thenDoNothing()
                when(mock).playPreroll().then { _ in
                    // Do not actually process any preroll but forward the play call directly to the player.
                    self.videoPlayer.play()
                }
            }

            self.mockVideoAnalyticsService = MockVideoAnalyticsServicing()
            stub(self.mockVideoAnalyticsService) { mock in
                when(mock).create(with: any()).thenDoNothing()
                when(mock).stop().thenDoNothing()
                when(mock).currentItemTitle.get.thenReturn(self.event.title)
                when(mock).currentItemEventId.get.thenReturn(self.event.id)
                when(mock).currentItemStreamId.get.thenReturn(self.event.streams.first?.id)
                when(mock).currentItemStreamURL.get.thenReturn(self.event.streams.first?.url)
                when(mock).isNativeMLS.get.thenReturn(self.event.isMLS)
                when(mock).currentItemIsLive.get.thenReturn(true)
                when(mock).currentItemTitle.set(any()).thenDoNothing()
                when(mock).currentItemEventId.set(any()).thenDoNothing()
                when(mock).currentItemStreamId.set(any()).thenDoNothing()
                when(mock).currentItemStreamURL.set(any()).thenDoNothing()
                when(mock).currentItemIsLive.set(any()).thenDoNothing()
                when(mock).isNativeMLS.set(any()).thenDoNothing()
            }

            self.mockEventRepository = MockMLSEventRepository()
            self.mockPlayerConfigRepository = MockMLSPlayerConfigRepository()
            self.mockDRMRepository = MockMLSDRMRepository()

            stub(self.mockEventRepository) { mock in
                when(mock).startEventUpdates(for: any(), callback: any()).thenDoNothing()
                when(mock).stopEventUpdates(for: any()).thenDoNothing()
            }

            stub(self.mockPlayerConfigRepository) { mock in
                when(mock).fetchPlayerConfig(callback: any()).then { callback in
                    callback(MLSSDK.PlayerConfig.standard(), nil)
                }
            }

            stub(self.mockDRMRepository) { mock in
                when(mock).fetchCertificate(byURL: any(), callback: any()).thenDoNothing()
                when(mock).fetchLicense(byURL: any(), spcData: any(), callback: any()).thenDoNothing()
            }
            
            self.annotationIntegration = MockAnnotationIntegration()
            stub(self.annotationIntegration) { mock in
                when(mock).timelineId.get.then { _ in
                    return timelineId
                }
                when(mock).timelineId.set(any()).then { v in
                    timelineId = v
                }
                when(mock).evaluate().thenDoNothing()
            }

            self.videoPlayer = VideoPlayerImpl(
                view: self.mockView,
                avPlayer: self.mockMLSPlayer,
                getEventUpdatesUseCase: GetEventUpdatesUseCase(eventRepository: self.mockEventRepository),
                getPlayerConfigUseCase: GetPlayerConfigUseCase(playerConfigRepository: self.mockPlayerConfigRepository),
                getCertificateDataUseCase: GetCertificateDataUseCase(drmRepository: self.mockDRMRepository),
                getLicenseDataUseCase: GetLicenseDataUseCase(drmRepository: self.mockDRMRepository),
                videoAnalyticsService: self.mockVideoAnalyticsService,
                pseudoUserId: "test_account",
                publicKey: "123")
            
            self.videoPlayer.playerConfig = PlayerConfig.standard()
            self.videoPlayer.annotationIntegration = self.annotationIntegration
        }

        describe("loading streams and events") {
            it("replaces avplayer item when setting a stream") {
                waitUntil { done in
                    self.videoPlayer.stream = EntityBuilder.buildStream(withURL: true)

                    // The replaceCurrentItem method may get called asynchronously, so wait for a brief period.
                    let _ = Timer.scheduledTimer(withTimeInterval: 0.2, repeats: false) { timer in
                        verify(self.mockMLSPlayer, times(1)).replaceCurrentItem(with: Cuckoo.notNil(), headers: any(), resourceLoaderDelegate: any(), callback: any())

                        done()
                    }
                }
            }

            it("replaces avplayer item when setting an event") {
                waitUntil { done in
                    self.videoPlayer.event = self.event

                    // The replaceCurrentItem method may get called asynchronously, so wait for a brief period.
                    let _ = Timer.scheduledTimer(withTimeInterval: 0.2, repeats: false) { timer in
                        verify(self.mockMLSPlayer, times(1)).replaceCurrentItem(with: Cuckoo.notNil(), headers: any(), resourceLoaderDelegate: any(), callback: any())

                        done()
                    }
                }
            }

            it("it replaces avplayer item when the stream id is the same but the url became available") {
                waitUntil { done in
                    self.videoPlayer.event = EntityBuilder.buildEvent(withRandomId: false, withStream: true, withStreamURL: false)

                    // The replaceCurrentItem method may get called asynchronously, so wait for a brief period.
                    let _ = Timer.scheduledTimer(withTimeInterval: 0.2, repeats: false) { timer in
                        verify(self.mockMLSPlayer, times(1)).replaceCurrentItem(with: Cuckoo.isNil(), headers: any(), resourceLoaderDelegate: any(), callback: any())

                        self.videoPlayer.event = EntityBuilder.buildEvent(withRandomId: false, withStream: true, withStreamURL: true)
                        let _ = Timer.scheduledTimer(withTimeInterval: 0.2, repeats: false) { timer in
                            verify(self.mockMLSPlayer, times(1)).replaceCurrentItem(with: Cuckoo.notNil(), headers: any(), resourceLoaderDelegate: any(), callback: any())

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
                        verify(self.mockMLSPlayer, times(1)).replaceCurrentItem(with: any(), headers: any(), resourceLoaderDelegate: any(), callback: any())

                        self.videoPlayer.event = EntityBuilder.buildEvent(withRandomId: false, withStream: true, withStreamURL: true, withRandomStreamURL: true)

                        let _ = Timer.scheduledTimer(withTimeInterval: 0.2, repeats: false) { timer in
                            // The item should not have been replaced.
                            verify(self.mockMLSPlayer, times(1)).replaceCurrentItem(with: any(), headers: any(), resourceLoaderDelegate: any(), callback: any())

                            done()
                        }
                    }
                }
            }

            it("removes avplayer item when the stream url for the same stream id was previously known and now it is unpublished") {
                waitUntil { done in
                    self.videoPlayer.event = EntityBuilder.buildEvent(withRandomId: false, withStream: true, withStreamURL: true, withRandomStreamURL: true)

                    // The replaceCurrentItem method may get called asynchronously, so wait for a brief period.
                    let _ = Timer.scheduledTimer(withTimeInterval: 0.2, repeats: false) { timer in
                        verify(self.mockMLSPlayer, times(1)).replaceCurrentItem(with: any(), headers: any(), resourceLoaderDelegate: any(), callback: any())

                        self.videoPlayer.event = EntityBuilder.buildEvent(withRandomId: false, withStream: true, withStreamURL: false, withRandomStreamURL: false)

                        let _ = Timer.scheduledTimer(withTimeInterval: 0.2, repeats: false) { timer in
                            // The item should not have been replaced.
                            verify(self.mockMLSPlayer, times(2)).replaceCurrentItem(with: any(), headers: any(), resourceLoaderDelegate: any(), callback: any())

                            done()
                        }
                    }
                }
            }

            it("subscribes to timeline updates when an event with timelineid is loaded") {
                verify(self.annotationIntegration, times(0)).timelineId.set(any())

                let event = EntityBuilder.buildEvent(withRandomId: false, withStream: true, withStreamURL: true, withRandomStreamURL: true, withTimelineId: true)
                
                expect(event.timelineIds.first).toNot(beNil())

                self.videoPlayer.event = event

                verify(self.annotationIntegration, times(1)).timelineId.set(any())
                expect(self.annotationIntegration.timelineId).toNot(beNil())
            }

            it("subscribes to timeline updates when an event is updated to have a timelineId after initially loading without") {
                verify(self.annotationIntegration, times(0)).timelineId.set(any())

                let eventWithoutTimelineId = EntityBuilder.buildEvent(withRandomId: false, withStream: true, withStreamURL: true, withRandomStreamURL: true, withTimelineId: false)
                
                expect(eventWithoutTimelineId.timelineIds.first).to(beNil())

                self.videoPlayer.event = eventWithoutTimelineId
                
                verify(self.annotationIntegration, times(1)).timelineId.set(any())
                expect(self.annotationIntegration.timelineId).to(beNil())

                let eventWithTimelineId = EntityBuilder.buildEvent(withRandomId: false, withStream: true, withStreamURL: true, withRandomStreamURL: true, withTimelineId: true)
                
                expect(eventWithTimelineId.timelineIds.first).toNot(beNil())

                self.videoPlayer.event = eventWithTimelineId

                verify(self.annotationIntegration, times(2)).timelineId.set(any())
                expect(self.annotationIntegration.timelineId).toNot(beNil())
            }
        }


        describe("info layer") {
            it("shows the info layer when there is no stream") {
                verify(self.mockView, times(0)).setInfoViewVisibility(visible: true, withAnimationDuration: any())

                self.videoPlayer.event = EntityBuilder.buildEvent(withStream: false, withStreamURL: false)

                verify(self.mockView, times(1)).setInfoViewVisibility(visible: true, withAnimationDuration: any())
            }

            it("shows the info layer when there is no stream url") {
                verify(self.mockView, times(0)).setInfoViewVisibility(visible: true, withAnimationDuration: any())

                self.videoPlayer.event = EntityBuilder.buildEvent(withStream: true, withStreamURL: false)

                verify(self.mockView, times(1)).setInfoViewVisibility(visible: true, withAnimationDuration: any())
            }

            it("does not allow info layer dismissal when there is no stream") {
                self.videoPlayer.event = EntityBuilder.buildEvent(withStream: true, withStreamURL: false)

                verify(self.mockView, times(1)).setInfoViewVisibility(visible: true, withAnimationDuration: any())

                controlViewTapped?()

                // Verify the count did not go up.
                verify(self.mockView, times(0)).setInfoViewVisibility(visible: false, withAnimationDuration: any())
            }

            it("dismisses info layer on controlview tapped when there is a stream") {
                self.videoPlayer.event = EntityBuilder.buildEvent(withStream: true, withStreamURL: true)

                verify(self.mockView, times(1)).setInfoViewVisibility(visible: false, withAnimationDuration: any())

                infoButtonTapped?()

                verify(self.mockView, times(1)).setInfoViewVisibility(visible: true, withAnimationDuration: any())

                controlViewTapped?()

                verify(self.mockView, times(2)).setInfoViewVisibility(visible: false, withAnimationDuration: any())
            }

            it("hides the info layer when a stream url appears on a previously loaded event") {
                self.videoPlayer.event = EntityBuilder.buildEvent(withRandomId: false, withStream: true, withStreamURL: false)

                verify(self.mockView, times(1)).setInfoViewVisibility(visible: true, withAnimationDuration: any())

                self.videoPlayer.event = EntityBuilder.buildEvent(withRandomId: false, withStream: true, withStreamURL: true)

                verify(self.mockView, times(1)).setInfoViewVisibility(visible: false, withAnimationDuration: any())
            }

            it("does not show info layer again when the same event/stream is updated") {
                let event = EntityBuilder.buildEvent(withRandomId: false, withStream: true, withStreamURL: false)
                self.videoPlayer.event = event

                verify(self.mockView, times(1)).setInfoViewVisibility(visible: true, withAnimationDuration: any())

                self.videoPlayer.event = event

                verify(self.mockView, times(1)).setInfoViewVisibility(visible: true, withAnimationDuration: any())
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
                it("it updates the slider value when the duration/current time changes") {
                    updatePeriodicTimeObserver()
                    expect(self.mockView.videoSlider.value).toEventually(equal(optimisticCurrentTime / currentDuration))
                }
                it("it does not update the slider value while seeking and the time changes") {
                    let sliderValueBefore = self.mockView.videoSlider.value
                    stub(self.mockMLSPlayer) { mock in
                        when(mock).isSeeking.get.thenReturn(true)
                    }
                    updatePeriodicTimeObserver()
                    expect(self.mockView.videoSlider.value).toEventually(equal(sliderValueBefore))
                }
            }

            it("calls delegate with slider update") {
                class Delegate: VideoPlayerDelegate {
                    var called = false
                    
                    func playerDidUpdateStream(stream: MLSSDK.Stream?, player: VideoPlayer) {}
                    func playerDidUpdatePlaying(player: VideoPlayer) {}
                    func playerDidUpdateState(player: VideoPlayer) {}
                    func playerDidUpdateFullscreen(player: VideoPlayer) {}
                    func playerDidUpdateControlVisibility(toVisible: Bool, withAnimationDuration: Double, player: VideoPlayer) {}
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

        describe("control view visibility") {
            it("remains invisible after an event is loaded") {
                expect(self.mockView.controlViewHasAlpha).to(beFalse())

                self.videoPlayer.event = self.event

                expect(self.mockView.controlViewHasAlpha).toEventually(beFalse())
            }
        }

        describe("autoplay") {
            describe("without ima integration") {
                it("autoplays with autoplay set to true") {
                    expect(self.videoPlayer.status).to(equal(.unknown))
                    self.videoPlayer.playerConfig = PlayerConfig(autoplay: true, imaAdUnit: nil)
                    self.videoPlayer.event = self.event
                    expect(self.videoPlayer.status).to(equal(.play))
                }

                it("does not autoplay with autoplay set to false") {
                    expect(self.videoPlayer.status).to(equal(.unknown))
                    self.videoPlayer.playerConfig = PlayerConfig(autoplay: false, imaAdUnit: nil)
                    self.videoPlayer.event = self.event
                    expect(self.videoPlayer.status).to(equal(.unknown))
                }

                it("plays when calling play() with autoplay set to false") {
                    expect(self.videoPlayer.status).to(equal(.unknown))
                    self.videoPlayer.playerConfig = PlayerConfig(autoplay: false, imaAdUnit: nil)
                    self.videoPlayer.event = self.event
                    expect(self.videoPlayer.status).to(equal(.unknown))
                    self.videoPlayer.play()
                    expect(self.videoPlayer.status).to(equal(.play))
                }
            }
        }

        describe("ima") {
            beforeEach {
                self.videoPlayer.imaIntegration = self.mockIMAIntegration
            }

            it("autoplays with autoplay set to true") {
                expect(self.videoPlayer.status).to(equal(.unknown))
                self.videoPlayer.playerConfig = PlayerConfig(autoplay: true, imaAdUnit: "123456")
                self.videoPlayer.event = self.event
                expect(self.videoPlayer.status).to(equal(.play))
            }

            it("does not autoplay with autoplay set to false") {
                expect(self.videoPlayer.status).to(equal(.unknown))
                self.videoPlayer.playerConfig = PlayerConfig(autoplay: false, imaAdUnit: "123456")
                self.videoPlayer.event = self.event
                expect(self.videoPlayer.status).to(equal(.unknown))
            }

            it("plays ad directly upon autoplay") {
                verify(self.mockIMAIntegration, times(0)).playPreroll()
                self.videoPlayer.playerConfig = PlayerConfig(autoplay: true, imaAdUnit: "123456")
                self.videoPlayer.event = self.event
                verify(self.mockIMAIntegration, times(1)).playPreroll()
            }

            it("does not play ad directly with autoplay off") {
                verify(self.mockIMAIntegration, times(0)).playPreroll()
                self.videoPlayer.playerConfig = PlayerConfig(autoplay: false, imaAdUnit: "123456")
                self.videoPlayer.event = self.event
                verify(self.mockIMAIntegration, times(0)).playPreroll()
            }

            it("plays ad upon first calling play manually on videoplayer with autoplay off") {
                verify(self.mockIMAIntegration, times(0)).playPreroll()
                self.videoPlayer.playerConfig = PlayerConfig(autoplay: false, imaAdUnit: "123456")
                self.videoPlayer.event = self.event
                verify(self.mockIMAIntegration, times(0)).playPreroll()

                self.videoPlayer.play()
                verify(self.mockIMAIntegration, times(1)).playPreroll()

                // Also ensure the playPreroll does not get triggered a second time when calling play.
                self.videoPlayer.play()
                verify(self.mockIMAIntegration, times(1)).playPreroll()
            }
        }

        describe("button interactions") {
            describe("play button taps") {
                it("switches from pause to play") {
                    self.videoPlayer.event = self.event
                    // Keep in mind that this is initial status is dependent on autoplay being set on the PlayerConfig.
                    expect(self.videoPlayer.status).to(equal(.play))
                    playButtonTapped?()
                    expect(self.videoPlayer.status).to(equal(.pause))
                }

                it("switches from play to pause") {
                    self.videoPlayer.event = self.event
                    expect(self.videoPlayer.status).to(equal(.play))
                    playButtonTapped?()
                    playButtonTapped?()
                    expect(self.videoPlayer.status).to(equal(.play))
                }

                it("does nothing to the video player status while an ad is playing") {
                    stub(self.mockIMAIntegration) { mock in
                        when(mock).isShowingAd().thenReturn(true)
                    }

                    self.videoPlayer.imaIntegration = self.mockIMAIntegration
                    self.videoPlayer.playerConfig = PlayerConfig(imaAdUnit: "123456")
                    self.videoPlayer.event = self.event
                    expect(self.videoPlayer.status).to(equal(.unknown))
                    playButtonTapped?()
                    expect(self.videoPlayer.status).to(equal(.unknown))
                }

                it("Seeks to beginning if state is currently ended") {
                    self.videoPlayer.event = self.event
                    updateAVPlayerStatus(to: .readyToPlay)
                    stub(self.mockMLSPlayer) { mock in
                        when(mock).currentItemEnded.get.thenReturn(true)
                    }

                    waitUntil { done in
                        // Force the player to set the .ended state by updating the current time info.
                        timeObserverCallback?()
                        let _ = Timer.scheduledTimer(withTimeInterval: 0.2, repeats: false) { timer in
                            playButtonTapped?()
                            verify(self.mockMLSPlayer).seek(to: any(), toleranceBefore: any(), toleranceAfter: any(), completionHandler: any())
                            done()
                        }
                    }
                }
            }
        }

        describe("player configuration") {
            describe("disabling controls") {
                it("does not show the control view") {
                    waitUntil { done in
                        let _ = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: false) { timer in
                            // Our initial player config setup (see setup) will initially make the control view visible.
                            verify(self.mockView, times(1)).setControlView(hidden: false)

                            // Now set the new player config.
                            self.videoPlayer.playerConfig = PlayerConfig(enableControls: false)

                            let _ = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: false) { timer in
                                verify(self.mockView, times(1)).setControlView(hidden: true)

                                done()
                            }
                        }
                    }
                }
            }
        }
    }
}

