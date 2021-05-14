//
// Copyright © 2021 mycujoo. All rights reserved.
//

import Foundation
import Quick
import Nimble
import Cuckoo
import AVFoundation
@testable import MLSSDK
@testable import MLSSDK_Annotations


class AnnotationIntegrationSpec: QuickSpec {
    
    var mockTimelineRepository: MockMLSTimelineRepository!
    var mockArbitraryDataRepository: MockMLSArbitraryDataRepository!
    
    override func setUp() {
         continueAfterFailure = false
    }
    
    override func spec() {
        
        beforeEach {
            self.mockTimelineRepository = MockMLSTimelineRepository()
            self.mockArbitraryDataRepository = MockMLSArbitraryDataRepository()
            
            stub(self.mockTimelineRepository) { mock in
                when(mock).fetchAnnotationActions(byTimelineId: any(), updateId: any(), callback: any()).then { tuple in
                    (tuple.2)([], nil)
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
        }
        
        describe("loading the timeline") {
            
//            it("subscribes to timeline updates when an event with timelineid is loaded") {
//                verify(self.mockTimelineRepository, times(0)).startTimelineUpdates(for: any(), callback: any())
//
//                let event = EntityBuilder.buildEvent(withRandomId: false, withStream: true, withStreamURL: true, withRandomStreamURL: true, withTimelineId: true)
//
//                self.videoPlayer.event = event
//
//                verify(self.mockTimelineRepository, times(1)).startTimelineUpdates(for: event.timelineIds.first!, callback: any())
//            }
//
//            it("subscribes to timeline updates when an event is updated to have a timelineId after initially loading without") {
//                verify(self.mockTimelineRepository, times(0)).startTimelineUpdates(for: any(), callback: any())
//
//                let eventWithoutTimelineId = EntityBuilder.buildEvent(withRandomId: false, withStream: true, withStreamURL: true, withRandomStreamURL: true, withTimelineId: false)
//
//                self.videoPlayer.event = eventWithoutTimelineId
//
//                verify(self.mockTimelineRepository, times(0)).startTimelineUpdates(for: any(), callback: any())
//
//                let eventWithTimelineId = EntityBuilder.buildEvent(withRandomId: false, withStream: true, withStreamURL: true, withRandomStreamURL: true, withTimelineId: true)
//
//                self.videoPlayer.event = eventWithTimelineId
//
//                verify(self.mockTimelineRepository, times(1)).startTimelineUpdates(for: eventWithTimelineId.timelineIds.first!, callback: any())
//            }
        }
    }
    
    // TODO
//        describe("loading local annotations") {
//            it("calls evaluation function for local annotations") {
//                verify(self.mockAnnotationService, times(0)).evaluate(ParameterMatcher { $0.actions.count == 0 }, callback: any())
//
//                self.videoPlayer.localAnnotationActions = [EntityBuilder.buildAnnotationActionForShowOverlay()]
//
//                verify(self.mockAnnotationService, times(1)).evaluate(ParameterMatcher { $0.actions.count == 1 }, callback: any())
//            }
//        }
    
    // TODO
//        describe("showing and hiding overlays") {
//            beforeEach {
//                self.videoPlayer.event = EntityBuilder.buildEvent(withTimelineId: true)
//            }
//
//            it("places, removes and replaces overlays when currentTime changes and annotation actions are triggered") {
//                stub(self.mockAnnotationService) { mock in
//                    var calledAmount = 0
//                    when(mock).evaluate(any(), callback: any()).then { (tuple) in
//                        let showOverlays: [MLSUI.ShowOverlayAction]
//                        let hideOverlays: [MLSUI.HideOverlayAction]
//                        switch calledAmount {
//                        case 0:
//                            showOverlays = []
//                            hideOverlays = []
//                        case 1:
//                            showOverlays = [MLSUI.ShowOverlayAction(
//                                actionId: "randshowaction1",
//                                overlay: Overlay(id: "abc", svgURL: URL(string: "https://mocked.mycujoo.tv/mocked.svg")!),
//                                position: AnnotationActionShowOverlay.Position(top: 5, bottom: nil, vcenter: nil, right: nil, left: 5, hcenter: nil),
//                                size: AnnotationActionShowOverlay.Size(width: 20, height: nil),
//                                animateType: .none,
//                                animateDuration: 0.0,
//                                variables: [])]
//                            hideOverlays = []
//                        case 2:
//                            showOverlays = []
//                            hideOverlays = [MLSUI.HideOverlayAction(
//                                actionId: "randhideaction1",
//                                overlayId: "abc",
//                                animateType: .none,
//                                animateDuration: 0.0)]
//                        case 3:
//                            showOverlays = [MLSUI.ShowOverlayAction(
//                                actionId: "randshowaction2",
//                                overlay: Overlay(id: "abc", svgURL: URL(string: "https://mocked.mycujoo.tv/mocked.svg")!),
//                                position: AnnotationActionShowOverlay.Position(top: 5, bottom: nil, vcenter: nil, right: nil, left: 5, hcenter: nil),
//                                size: AnnotationActionShowOverlay.Size(width: 20, height: nil),
//                                animateType: .none,
//                                animateDuration: 0.0,
//                                variables: [])]
//                            hideOverlays = []
//                        case 4:
//                            showOverlays = [MLSUI.ShowOverlayAction(
//                                actionId: "randshowaction2",
//                                overlay: Overlay(id: "abc", svgURL: URL(string: "https://mocked.mycujoo.tv/mocked.svg")!),
//                                position: AnnotationActionShowOverlay.Position(top: 5, bottom: nil, vcenter: nil, right: nil, left: 5, hcenter: nil),
//                                size: AnnotationActionShowOverlay.Size(width: 20, height: nil),
//                                animateType: .none,
//                                animateDuration: 0.0,
//                                variables: [])]
//                            hideOverlays = []
//                        default:
//                            hideOverlays = []
//                            showOverlays = []
//                        }
//
//                        calledAmount += 1
//
//                        (tuple.1)(AnnotationService.EvaluationOutput(showTimelineMarkers: [], showOverlays: showOverlays, hideOverlays: hideOverlays, activeOverlayIds: Set(), tovs: [:]))
//                    }
//                }
//
//                waitUntil(timeout: DispatchTimeInterval.seconds(6)) { done in
//                    // The first call should not trigger a show overlay at all.
//                    updatePeriodicTimeObserver()
//
//                    // The showOverlays method may make calls asynchronously, so wait for a brief period.
//                    let _ = Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { timer in
//                        verify(self.mockView, times(0)).placeOverlay(imageView: any(), size: any(), position: any(), animateType: any(), animateDuration: any())
//
//                        // The second call should trigger a show overlay, which PLACES an overlay.
//                        // TODO: The tests fail on this point randomly. Rerunning the tests typically helps.
//                        updatePeriodicTimeObserver()
//                        let _ = Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { timer in
//                            verify(self.mockView, times(1)).placeOverlay(imageView: any(), size: any(), position: any(), animateType: any(), animateDuration: any())
//
//                            // The third call should trigger a hide overlay.
//                            updatePeriodicTimeObserver()
//                            let _ = Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { timer in
//                                verify(self.mockView, times(1)).removeOverlay(containerView: any(), animateType: any(), animateDuration: any(), completion: any())
//
//                                // The fourth call should trigger a show overlay, with PLACES an overlay again (because it was removed before).
//                                updatePeriodicTimeObserver()
//                                let _ = Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { timer in
//                                    verify(self.mockView, times(2)).placeOverlay(imageView: any(), size: any(), position: any(), animateType: any(), animateDuration: any())
//
//                                    // The fifth call should trigger a show overlay, with REPLACES an overlay (because it already exists onscreen)
//                                    updatePeriodicTimeObserver()
//                                    let _ = Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { timer in
//                                        verify(self.mockView, times(1)).replaceOverlay(containerView: any(), imageView: any())
//                                        done()
//                                    }
//                                }
//                            }
//                        }
//                    }
//                }
//            }
//        }
    
    
}
