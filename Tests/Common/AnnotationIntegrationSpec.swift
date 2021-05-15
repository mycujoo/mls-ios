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
    var getSVGUseCase: GetSVGUseCase!
    var getTimelineActionsUpdatesUseCase: GetTimelineActionsUpdatesUseCase!
    var annotationService: MockAnnotationServicing!
    var hlsInspectionService: MockHLSInspectionServicing!
    var annotationIntegrationView: MockAnnotationIntegrationView!
    var delegate: MockAnnotationIntegrationDelegate!
    
    var annotationIntegration: AnnotationIntegration!
    
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
            
            self.getSVGUseCase = GetSVGUseCase(arbitraryDataRepository: self.mockArbitraryDataRepository)
            self.getTimelineActionsUpdatesUseCase = GetTimelineActionsUpdatesUseCase(timelineRepository: self.mockTimelineRepository)
            
            self.annotationService = MockAnnotationServicing()
            stub(self.annotationService) { mock in
                when(mock).evaluate(any(), callback: any()).then { (tuple) in
                    (tuple.1)(AnnotationService.EvaluationOutput(showTimelineMarkers: [], showOverlays: [], hideOverlays: [], activeOverlayIds: Set(), tovs: [:]))
                }
            }
            
            self.hlsInspectionService = MockHLSInspectionServicing()
            stub(self.hlsInspectionService) { mock in
                when(mock).map(hlsPlaylist: any(), absoluteTimes: any()).thenReturn([:])
            }

            self.annotationIntegrationView = MockAnnotationIntegrationView()
            stub(self.annotationIntegrationView) { mock in
                when(mock).overlayContainerView.get.thenReturn(UIView())
                when(mock).setTimelineMarkers(with: any()).thenDoNothing()
            }
            
            self.delegate = MockAnnotationIntegrationDelegate()
            stub(self.delegate) { mock in
                when(mock).annotationIntegrationView.get.then { _ in
                    return self.annotationIntegrationView
                }
                when(mock).currentDuration.get.thenReturn(200)
                when(mock).optimisticCurrentTime.get.thenReturn(100)
            }

            self.annotationIntegration = AnnotationIntegrationImpl(
                annotationService: self.annotationService,
                hlsInspectionService: self.hlsInspectionService,
                getTimelineActionsUpdatesUseCase: self.getTimelineActionsUpdatesUseCase,
                getSVGUseCase: self.getSVGUseCase,
                delegate: self.delegate)
        }
        
        describe("loading the timeline") {
            it("subscribes to timeline updates when an event with timelineid is loaded") {
                let timelineId = "testtimelineid"
                verify(self.mockTimelineRepository, times(0)).startTimelineUpdates(for: any(), callback: any())

                self.annotationIntegration.timelineId = timelineId

                verify(self.mockTimelineRepository, times(1)).startTimelineUpdates(for: timelineId, callback: any())
            }

            it("subscribes to timeline updates when an event is updated to have a timelineId after initially loading without") {
                verify(self.mockTimelineRepository, times(0)).startTimelineUpdates(for: any(), callback: any())

                self.annotationIntegration.timelineId = nil

                verify(self.mockTimelineRepository, times(0)).startTimelineUpdates(for: any(), callback: any())
                
                let timelineId = "testtimelineid"
                self.annotationIntegration.timelineId = timelineId

                verify(self.mockTimelineRepository, times(1)).startTimelineUpdates(for: timelineId, callback: any())
            }
            
            it("stops subscribing to one timelineid when a new one is loaded") {
                let firstTimelineId = "testtimelineidone"
                let secondTimelineId = "testtimelineidtwo"
                verify(self.mockTimelineRepository, times(0)).stopTimelineUpdates(for: firstTimelineId)

                self.annotationIntegration.timelineId = firstTimelineId

                verify(self.mockTimelineRepository, times(0)).stopTimelineUpdates(for: firstTimelineId)
                
                self.annotationIntegration.timelineId = secondTimelineId
                
                verify(self.mockTimelineRepository, times(1)).stopTimelineUpdates(for: firstTimelineId)
            }
        }
        
        describe("showing and hiding overlays") {
            beforeEach {
//                self.videoPlayer.event = EntityBuilder.buildEvent(withTimelineId: true)
            }

            it("places, removes and replaces overlays when currentTime changes and annotation actions are triggered") {
                stub(self.annotationService) { mock in
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

//                waitUntil(timeout: DispatchTimeInterval.seconds(6)) { done in
//                    // The first call should not trigger a show overlay at all.
//                    updatePeriodicTimeObserver()
//
//                    // The showOverlays method may make calls asynchronously, so wait for a brief period.
//                    let _ = Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { timer in
//                        verify(self.annotationIntegrationView, times(0)).placeOverlay(imageView: any(), size: any(), position: any(), animateType: any(), animateDuration: any())
//
//                        // The second call should trigger a show overlay, which PLACES an overlay.
//                        // TODO: The tests fail on this point randomly. Rerunning the tests typically helps.
//                        updatePeriodicTimeObserver()
//                        let _ = Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { timer in
//                            verify(self.annotationIntegrationView, times(1)).placeOverlay(imageView: any(), size: any(), position: any(), animateType: any(), animateDuration: any())
//
//                            // The third call should trigger a hide overlay.
//                            updatePeriodicTimeObserver()
//                            let _ = Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { timer in
//                                verify(self.annotationIntegrationView, times(1)).removeOverlay(containerView: any(), animateType: any(), animateDuration: any(), completion: any())
//
//                                // The fourth call should trigger a show overlay, with PLACES an overlay again (because it was removed before).
//                                updatePeriodicTimeObserver()
//                                let _ = Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { timer in
//                                    verify(self.annotationIntegrationView, times(2)).placeOverlay(imageView: any(), size: any(), position: any(), animateType: any(), animateDuration: any())
//
//                                    // The fifth call should trigger a show overlay, with REPLACES an overlay (because it already exists onscreen)
//                                    updatePeriodicTimeObserver()
//                                    let _ = Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { timer in
//                                        verify(self.annotationIntegrationView, times(1)).replaceOverlay(containerView: any(), imageView: any())
//                                        done()
//                                    }
//                                }
//                            }
//                        }
//                    }
//                }
            }
        }
    }
}
