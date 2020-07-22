//
// Copyright © 2020 mycujoo. All rights reserved.
//

import XCTest
@testable import MLSSDK
import Cuckoo

class AnnotationServiceTests: XCTestCase {

    var annotationService: AnnotationService!
    var annotationActions: [AnnotationAction]!

    var currentTestName: String {
        return self.name.replacingOccurrences(of: "-[AnnotationServiceTests ", with: "").replacingOccurrences(of: "]", with: "")
    }

    override func setUp() {
        super.setUp()

        continueAfterFailure = false
    }

    override func setUpWithError() throws {
        annotationService = AnnotationService()
        annotationActions = makeAnnotationActionsFromJSON()
    }

    override func tearDownWithError() throws {
    }

    func testAnnotationService_timelineMarkers() {
        let expectation = XCTestExpectation(description: "Timeline markers are included in response")

        let input = AnnotationService.EvaluationInput(
            actions: annotationActions,
            activeOverlayIds: Set(),
            currentTime: 10,
            currentDuration: 20)

        annotationService.evaluate(input) { (output) in
            XCTAssertEqual(output.showTimelineMarkers.count, 2)
            XCTAssertEqual(output.showTimelineMarkers[0].position, 0.25)
            XCTAssertEqual(output.showTimelineMarkers[1].position, 0.75)
            XCTAssertEqual(output.showTimelineMarkers[0].timelineMarker.color, UIColor(hex: "#ffffff"))
            XCTAssertEqual(output.showTimelineMarkers[1].timelineMarker.color, UIColor(hex: "#cccccc"))

            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1.0)
    }

    func testAnnotationService_basicShowOverlay() {
        let expectation1 = XCTestExpectation(description: "Shows one overlay at 10s")
        let expectation2 = XCTestExpectation(description: "Shows one more overlay at 15s")
        let expectation3 = XCTestExpectation(description: "Shows both overlays at 15s when activeOverlayIds is empty")

        annotationService.evaluate(
            AnnotationService.EvaluationInput(
                actions: annotationActions,
                activeOverlayIds: Set(),
                currentTime: 10,
                currentDuration: 20)
        ) { (output) in
            XCTAssertEqual(output.showOverlays.count, 1)
            XCTAssertEqual(output.showOverlays[0].overlayId, "scoreboard1")
            XCTAssertEqual(output.showOverlays[0].animateDuration, 300)
            XCTAssertEqual(output.showOverlays[0].animateType, OverlayAnimateinType.fadeIn)

            expectation1.fulfill()
        }

        annotationService.evaluate(
            AnnotationService.EvaluationInput(
                actions: annotationActions,
                activeOverlayIds: Set(["scoreboard1"]),
                currentTime: 15,
                currentDuration: 20)
        ) { (output) in
            XCTAssertEqual(output.showOverlays.count, 1)
            XCTAssertEqual(output.showOverlays[0].overlayId, "gagj9j9agj9a")
            XCTAssertEqual(output.showOverlays[0].animateDuration, 500)
            XCTAssertEqual(output.showOverlays[0].animateType, OverlayAnimateinType.slideFromRight)

            expectation2.fulfill()
        }

        annotationService.evaluate(
            AnnotationService.EvaluationInput(
                actions: annotationActions,
                activeOverlayIds: Set(),
                currentTime: 15,
                currentDuration: 20)
        ) { (output) in
            XCTAssertEqual(output.showOverlays.count, 2)
            XCTAssertTrue(output.showOverlays.map { $0.overlayId }.contains("scoreboard1"))
            XCTAssertTrue(output.showOverlays.map { $0.overlayId }.contains("gagj9j9agj9a"))

            expectation3.fulfill()
        }

        wait(for: [expectation1, expectation2, expectation3], timeout: 1.0)
    }

    func testAnnotationService_showOverlayCorrectlyWithoutAnimation() {
        let expectation = XCTestExpectation(description: "Shows overlays with the correct animation duration")

        annotationService.evaluate(
            AnnotationService.EvaluationInput(
                actions: annotationActions,
                activeOverlayIds: Set(),
                currentTime: 16,
                currentDuration: 20)
        ) { (output) in
            let sortedOverlays = output.showOverlays.sorted { (lhs, rhs) -> Bool in
                lhs.overlayId < rhs.overlayId
            }

            XCTAssertEqual(sortedOverlays.count, 2)
            // The overlay for "gagj9j9agj9a" (at 15s) should still show with an animation because it is within animation duration + 1s
            XCTAssertNotEqual(sortedOverlays[0].animateDuration, 0)
            // The overlay for scoreboard is too long ago and should show instantly.
            XCTAssertEqual(sortedOverlays[1].animateDuration, 0)

            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1.0)
    }

    func testAnnotationService_basicHideOverlay() throws {
        self.continueAfterFailure = false

        let expectation1 = XCTestExpectation(description: "Hide overlay does not trigger when there are no overlays yet")
        let expectation2 = XCTestExpectation(description: "Hide overlay triggers through a dedicated hideoverlay action")

        annotationService.evaluate(
            AnnotationService.EvaluationInput(
                actions: annotationActions,
                activeOverlayIds: Set(),
                currentTime: 0,
                currentDuration: 20)
        ) { (output) in
            XCTAssertEqual(output.hideOverlays.count, 0)

            expectation1.fulfill()
        }

        annotationService.evaluate(
            AnnotationService.EvaluationInput(
                actions: annotationActions,
                activeOverlayIds: Set(["scoreboard1"]),
                currentTime: 15,
                currentDuration: 20)
        ) { (output) in
            XCTAssertTrue(false)
            XCTAssertEqual(output.hideOverlays.count, 1)

            XCTAssert(output.hideOverlays[0].overlayId == "scoreboard1")
//
//            XCTAssertEqual(output.hideOverlays[0].overlayId, "scoreboard1")
//            XCTAssertEqual(output.hideOverlays[0].animateDuration, 500)
//            XCTAssertEqual(output.hideOverlays[0].animateType, OverlayAnimateoutType.slideToRight)

            expectation2.fulfill()
        }

        wait(for: [expectation1, expectation2], timeout: 1.0)
    }
//
//    func testAnnotationService_updatesActiveOverlayIds() {
//        let expectation = XCTestExpectation(description: "")
//
//        let input = AnnotationService.EvaluationInput(
//            actions: annotationActions,
//            activeOverlayIds: Set(),
//            currentTime: 10,
//            currentDuration: 20)
//
//        annotationService.evaluate(input) { (output) in
//
//            expectation.fulfill()
//        }
//
//        wait(for: [expectation], timeout: 1.0)
//    }
//
//    func testAnnotationService_createVariables() {
//        let expectation = XCTestExpectation(description: "")
//
//        let input = AnnotationService.EvaluationInput(
//            actions: annotationActions,
//            activeOverlayIds: Set(),
//            currentTime: 10,
//            currentDuration: 20)
//
//        annotationService.evaluate(input) { (output) in
//
//            expectation.fulfill()
//        }
//
//        wait(for: [expectation], timeout: 1.0)
//    }
//
//    func testAnnotationService_variablesMissing() {
//        let expectation = XCTestExpectation(description: "")
//
//        let input = AnnotationService.EvaluationInput(
//            actions: annotationActions,
//            activeOverlayIds: Set(),
//            currentTime: 10,
//            currentDuration: 20)
//
//        annotationService.evaluate(input) { (output) in
//
//            expectation.fulfill()
//        }
//
//        wait(for: [expectation], timeout: 1.0)
//    }
//
//    func testAnnotationService_updateVariables() {
//        let expectation = XCTestExpectation(description: "")
//
//        let input = AnnotationService.EvaluationInput(
//            actions: annotationActions,
//            activeOverlayIds: Set(),
//            currentTime: 10,
//            currentDuration: 20)
//
//        annotationService.evaluate(input) { (output) in
//
//            expectation.fulfill()
//        }
//
//        wait(for: [expectation], timeout: 1.0)
//    }
//
//    func testAnnotationService_updateVariableToDifferentType() {
//        let expectation = XCTestExpectation(description: "")
//
//        let input = AnnotationService.EvaluationInput(
//            actions: annotationActions,
//            activeOverlayIds: Set(),
//            currentTime: 10,
//            currentDuration: 20)
//
//        annotationService.evaluate(input) { (output) in
//
//            expectation.fulfill()
//        }
//
//        wait(for: [expectation], timeout: 1.0)
//    }
//
//    func testAnnotationService_incrementVariables() {
//        let expectation = XCTestExpectation(description: "")
//
//        let input = AnnotationService.EvaluationInput(
//            actions: annotationActions,
//            activeOverlayIds: Set(),
//            currentTime: 10,
//            currentDuration: 20)
//
//        annotationService.evaluate(input) { (output) in
//
//            expectation.fulfill()
//        }
//
//        wait(for: [expectation], timeout: 1.0)
//    }
//
//    func testAnnotationService_incrementStringVariableDoesntWork() {
//        let expectation = XCTestExpectation(description: "")
//
//        let input = AnnotationService.EvaluationInput(
//            actions: annotationActions,
//            activeOverlayIds: Set(),
//            currentTime: 10,
//            currentDuration: 20)
//
//        annotationService.evaluate(input) { (output) in
//
//            expectation.fulfill()
//        }
//
//        wait(for: [expectation], timeout: 1.0)
//    }

}

extension AnnotationServiceTests {
    /// Makes AnnotationAction objects from a JSON file. If no jsonFileName is provided, the test name is used as the JSON file name.
    private func makeAnnotationActionsFromJSON(jsonFileName: String? = nil) -> [AnnotationAction] {
        if let path = Bundle(for: type(of: self)).path(forResource: (jsonFileName ?? currentTestName), ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)

                let decoder = JSONDecoder()
                let decoded = (try? decoder.decode(AnnotationActionWrapper.self, from: data))

                return decoded?.actions ?? []
            } catch {}
        }

        return []
    }
}
