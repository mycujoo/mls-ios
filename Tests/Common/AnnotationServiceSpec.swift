//
// Copyright © 2020 mycujoo. All rights reserved.
//

import Foundation
import Quick
import Nimble
@testable import MLSSDK


class AnnotationServiceSpec: QuickSpec {

    var annotationService: AnnotationService!

    override func setUp() {
         continueAfterFailure = false
    }

    override func spec() {
        beforeEach {
            self.annotationService = AnnotationService()
        }

        describe("timeline markers") {
            var actions: [AnnotationAction]!
            var input: AnnotationService.EvaluationInput!

            beforeEach {
                actions = self.makeAnnotationActionsFromJSON("testAnnotationService_timelineMarkers")
                input = AnnotationService.EvaluationInput(
                    actions: actions,
                    activeOverlayIds: Set(),
                    currentTime: 10000,
                    currentDuration: 20000)
            }

            it("returns correct position") {
                waitUntil { done in
                    self.annotationService.evaluate(input) { (output) in
                        guard output.showTimelineMarkers.count == 2 else { fail("Wrong array count"); done(); return }

                        expect(output.showTimelineMarkers[0].position).to(equal(0.25))
                        expect(output.showTimelineMarkers[1].position).to(equal(0.75))

                        done()
                    }
                }
            }

            it("returns correct color") {
                waitUntil { done in
                    self.annotationService.evaluate(input) { (output) in
                        guard output.showTimelineMarkers.count == 2 else { fail("Wrong array count"); done(); return }

                        expect(output.showTimelineMarkers[0].timelineMarker.color).to(equal(UIColor(hex: "#ffffff")))
                        expect(output.showTimelineMarkers[1].timelineMarker.color).to(equal(UIColor(hex: "#cccccc")))
                        done()
                    }
                }
            }
        }

        describe("show overlay") {
            var actions: [AnnotationAction]!
            var input: AnnotationService.EvaluationInput!

            describe("basic case") {
                beforeEach {
                    actions = self.makeAnnotationActionsFromJSON("testAnnotationService_basicShowOverlay")
                }

                it("shows a scoreboard overlay at 10s") {
                    input = AnnotationService.EvaluationInput(
                        actions: actions,
                        activeOverlayIds: Set(),
                        currentTime: 10000,
                        currentDuration: 20000)

                    waitUntil { done in
                        self.annotationService.evaluate(input) { (output) in
                            guard output.showOverlays.count == 1 else { fail("Wrong array count"); done(); return }

                            expect(output.showOverlays[0].overlayId).to(equal("scoreboard1"))
                            expect(output.showOverlays[0].animateDuration).to(equal(300))
                            expect(output.showOverlays[0].animateType).to(equal(OverlayAnimateinType.fadeIn))
                            done()
                        }
                    }
                }

                it("shows an announcement overlay at 15s") {
                    input = AnnotationService.EvaluationInput(
                        actions: actions,
                        activeOverlayIds: Set(["scoreboard1"]),
                        currentTime: 15000,
                        currentDuration: 20000)

                    waitUntil { done in
                        self.annotationService.evaluate(input) { (output) in
                            guard output.showOverlays.count == 1 else { fail("Wrong array count"); done(); return }

                            expect(output.showOverlays[0].overlayId).to(equal("gagj9j9agj9a"))
                            expect(output.showOverlays[0].animateDuration).to(equal(500))
                            expect(output.showOverlays[0].animateType).to(equal(OverlayAnimateinType.slideFromRight))
                            done()
                        }
                    }
                }

                it("shows both overlays 15s when no active overlays are present") {
                    input = AnnotationService.EvaluationInput(
                        actions: actions,
                        activeOverlayIds: Set(),
                        currentTime: 15000,
                        currentDuration: 20000)

                    waitUntil { done in
                        self.annotationService.evaluate(input) { (output) in
                            guard output.showOverlays.count == 2 else { fail("Wrong array count"); done(); return }

                            let sortedShowOverlays = output.showOverlays.sorted { (lhs, rhs) -> Bool in
                                lhs.overlayId < rhs.overlayId
                            }

                            expect(sortedShowOverlays[0].overlayId).to(equal("gagj9j9agj9a"))
                            expect(sortedShowOverlays[1].overlayId).to(equal("scoreboard1"))
                            done()
                        }
                    }
                }
            }

            it("removes animations when seeking after initial animation point") {
                actions = self.makeAnnotationActionsFromJSON("testAnnotationService_showOverlayCorrectlyWithoutAnimation")

                input = AnnotationService.EvaluationInput(
                    actions: actions,
                    activeOverlayIds: Set(),
                    currentTime: 16000,
                    currentDuration: 20000)

                waitUntil { done in
                    self.annotationService.evaluate(input) { (output) in
                        guard output.showOverlays.count == 2 else { fail("Wrong array count"); done(); return }

                        let sortedShowOverlays = output.showOverlays.sorted { (lhs, rhs) -> Bool in
                            lhs.overlayId < rhs.overlayId
                        }

                        // The overlay for "gagj9j9agj9a" (at 15s) should still show with an animation because it is within animation duration + 1s
                        expect(sortedShowOverlays[0].animateDuration).toNot(equal(0))
                        // The overlay for scoreboard is too long ago and should show instantly.
                        expect(sortedShowOverlays[1].animateDuration).to(equal(0))
                        done()
                    }
                }
            }
        }

        describe("hide overlay") {
            var actions: [AnnotationAction]!
            var input: AnnotationService.EvaluationInput!

            describe("by dedicated action") {
                beforeEach {
                    actions = self.makeAnnotationActionsFromJSON("testAnnotationService_basicHideOverlay")
                }

                it("does not hide overlays when none are active yet") {
                    input = AnnotationService.EvaluationInput(
                        actions: actions,
                        activeOverlayIds: Set(),
                        currentTime: 0,
                        currentDuration: 20000)

                    waitUntil { done in
                        self.annotationService.evaluate(input) { (output) in
                            expect(output.hideOverlays.count).to(equal(0))
                            done()
                        }
                    }
                }

                it("hides correctly") {
                    input = AnnotationService.EvaluationInput(
                        actions: actions,
                        activeOverlayIds: Set(["scoreboard1"]),
                        currentTime: 16000,
                        currentDuration: 20000)

                    waitUntil { done in
                        self.annotationService.evaluate(input) { (output) in
                            guard output.hideOverlays.count == 1 else { fail("Wrong array count"); done(); return }

                            expect(output.hideOverlays[0].overlayId).to(equal("scoreboard1"))
                            expect(output.hideOverlays[0].animateDuration).to(equal(300))
                            expect(output.hideOverlays[0].animateType).to(equal(OverlayAnimateoutType.fadeOut))

                            done()
                        }
                    }
                }
            }

            describe("by show overlay duration expiration") {
                beforeEach {
                    actions = self.makeAnnotationActionsFromJSON("testAnnotationService_hideOverlayAfterDuration")
                }

                it("does not hide overlays when none are active yet") {
                    input = AnnotationService.EvaluationInput(
                        actions: actions,
                        activeOverlayIds: Set(),
                        currentTime: 0,
                        currentDuration: 20000)

                    waitUntil { done in
                        self.annotationService.evaluate(input) { (output) in
                            expect(output.hideOverlays.count).to(equal(0))
                            done()
                        }
                    }
                }

                it("does not hide too soon") {
                    input = AnnotationService.EvaluationInput(
                        actions: actions,
                        activeOverlayIds: Set(["gagj9j9agj9a"]),
                        currentTime: 11000,
                        currentDuration: 20000)

                    waitUntil { done in
                        self.annotationService.evaluate(input) { (output) in
                            expect(output.hideOverlays.count).to(equal(0))
                            done()
                        }
                    }
                }

                it("hides correctly") {
                    input = AnnotationService.EvaluationInput(
                        actions: actions,
                        activeOverlayIds: Set(["gagj9j9agj9a"]),
                        currentTime: 15000,
                        currentDuration: 20000)

                    waitUntil { done in
                        self.annotationService.evaluate(input) { (output) in
                            guard output.hideOverlays.count == 1 else { fail("Wrong array count"); done(); return }

                            expect(output.hideOverlays[0].overlayId).to(equal("gagj9j9agj9a"))
                            expect(output.hideOverlays[0].animateDuration).to(equal(500))
                            expect(output.hideOverlays[0].animateType).to(equal(OverlayAnimateoutType.slideToLeft))

                            done()
                        }
                    }
                }
            }
        }

        describe("variables") {
            var actions: [AnnotationAction]!
            var input: AnnotationService.EvaluationInput!

            describe("setting") {
                describe("basic case") {
                    beforeEach {
                        actions = self.makeAnnotationActionsFromJSON("testAnnotationService_createVariables")
                    }

                    it("creates variable at the right time") {
                        input = AnnotationService.EvaluationInput(
                            actions: actions,
                            activeOverlayIds: Set(),
                            currentTime: 0,
                            currentDuration: 20000)

                        waitUntil { done in
                            self.annotationService.evaluate(input) { (output) in
                                guard output.variables.count == 1 else { fail("Wrong array count"); done(); return }
                                guard output.variables["$homeScore"] != nil else { fail("Missing value in dict"); done(); return }

                                expect(output.variables["$homeScore"]!.stringValue).to(beNil())
                                expect(output.variables["$homeScore"]!.doubleValue).to(beNil())
                                expect(output.variables["$homeScore"]!.longValue).to(equal(0))

                                done()
                            }
                        }
                    }

                    it("creates variable at the right time later in timeline") {
                        input = AnnotationService.EvaluationInput(
                            actions: actions,
                            activeOverlayIds: Set(),
                            currentTime: 15000,
                            currentDuration: 20000)

                        waitUntil { done in
                            self.annotationService.evaluate(input) { (output) in
                                guard output.variables.count == 2 else { fail("Wrong array count"); done(); return }
                                guard output.variables["$awayScore"] != nil else { fail("Missing value in dict"); done(); return }

                                expect(output.variables["$awayScore"]!.stringValue).to(beNil())
                                expect(output.variables["$awayScore"]!.doubleValue).to(beNil())
                                expect(output.variables["$awayScore"]!.longValue).to(equal(2))

                                done()
                            }
                        }
                    }
                }

                describe("overwriting existing variables") {
                    beforeEach {
                        actions = self.makeAnnotationActionsFromJSON("testAnnotationService_updateVariables")
                    }

                    it("does not exist before declaration") {
                        input = AnnotationService.EvaluationInput(
                            actions: actions,
                            activeOverlayIds: Set(),
                            currentTime: 0,
                            currentDuration: 20000)

                        waitUntil { done in
                            self.annotationService.evaluate(input) { (output) in
                                guard output.variables.count == 0 else { fail("Wrong array count"); done(); return }
                                done()
                            }
                        }
                    }

                    it("has correct value before overwrite") {
                        input = AnnotationService.EvaluationInput(
                            actions: actions,
                            activeOverlayIds: Set(),
                            currentTime: 5000,
                            currentDuration: 20000)

                        waitUntil { done in
                            self.annotationService.evaluate(input) { (output) in
                                guard output.variables.count == 1 else { fail("Wrong array count"); done(); return }
                                guard output.variables["$homeScore"] != nil else { fail("Missing value in dict"); done(); return }

                                expect(output.variables["$homeScore"]!.longValue).to(equal(0))

                                done()
                            }
                        }
                    }

                    it("has correct value after overwrite") {
                        input = AnnotationService.EvaluationInput(
                            actions: actions,
                            activeOverlayIds: Set(),
                            currentTime: 15000,
                            currentDuration: 20000)

                        waitUntil { done in
                            self.annotationService.evaluate(input) { (output) in
                                guard output.variables.count == 1 else { fail("Wrong array count"); done(); return }
                                guard output.variables["$homeScore"] != nil else { fail("Missing value in dict"); done(); return }

                                expect(output.variables["$homeScore"]!.longValue).to(equal(20))

                                done()
                            }
                        }
                    }

                }

                describe("overwrite existing variables to other type") {
                    beforeEach {
                        actions = self.makeAnnotationActionsFromJSON("testAnnotationService_updateVariableToDifferentType")
                    }

                    it("starts as one type") {
                        input = AnnotationService.EvaluationInput(
                            actions: actions,
                            activeOverlayIds: Set(),
                            currentTime: 0,
                            currentDuration: 20000)

                        waitUntil { done in
                            self.annotationService.evaluate(input) { (output) in
                                guard output.variables.count == 1 else { fail("Wrong array count"); done(); return }
                                guard output.variables["$homeScore"] != nil else { fail("Missing value in dict"); done(); return }

                                expect(output.variables["$homeScore"]!.longValue).to(equal(0))
                                expect(output.variables["$homeScore"]!.stringValue).to(beNil())

                                done()
                            }
                        }
                    }

                    it("updates to other type") {
                        input = AnnotationService.EvaluationInput(
                            actions: actions,
                            activeOverlayIds: Set(),
                            currentTime: 12000,
                            currentDuration: 20000)

                        waitUntil { done in
                            self.annotationService.evaluate(input) { (output) in
                                guard output.variables.count == 1 else { fail("Wrong array count"); done(); return }
                                guard output.variables["$homeScore"] != nil else { fail("Missing value in dict"); done(); return }

                                expect(output.variables["$homeScore"]!.stringValue).to(equal("1"))
                                expect(output.variables["$homeScore"]!.longValue).to(beNil())

                                done()
                            }
                        }
                    }
                }
            }

            describe("incrementing") {
                describe("increments a long") {
                    beforeEach {
                        actions = self.makeAnnotationActionsFromJSON("testAnnotationService_incrementLongVariables")
                    }

                    it("updates after the set variable") {
                        input = AnnotationService.EvaluationInput(
                            actions: actions,
                            activeOverlayIds: Set(),
                            currentTime: 4000,
                            currentDuration: 20000)

                        waitUntil { done in
                            self.annotationService.evaluate(input) { (output) in
                                guard output.variables.count == 1 else { fail("Wrong array count"); done(); return }
                                guard output.variables["$homeScore"] != nil else { fail("Missing value in dict"); done(); return }

                                expect(output.variables["$homeScore"]!.longValue).to(equal(1))

                                done()
                            }
                        }
                    }

                    it("updates a series of values") {
                        input = AnnotationService.EvaluationInput(
                            actions: actions,
                            activeOverlayIds: Set(),
                            currentTime: 12000,
                            currentDuration: 20000)

                        waitUntil { done in
                            self.annotationService.evaluate(input) { (output) in
                                guard output.variables.count == 1 else { fail("Wrong array count"); done(); return }
                                guard output.variables["$homeScore"] != nil else { fail("Missing value in dict"); done(); return }

                                expect(output.variables["$homeScore"]!.longValue).to(equal(-4))

                                done()
                            }
                        }
                    }
                }

                describe("increments a double") {
                    beforeEach {
                        actions = self.makeAnnotationActionsFromJSON("testAnnotationService_incrementDoubleVariables")
                    }

                    it("updates after the set variable") {
                        input = AnnotationService.EvaluationInput(
                            actions: actions,
                            activeOverlayIds: Set(),
                            currentTime: 4000,
                            currentDuration: 20000)

                        waitUntil { done in
                            self.annotationService.evaluate(input) { (output) in
                                guard output.variables.count == 1 else { fail("Wrong array count"); done(); return }
                                guard output.variables["$homeScore"] != nil else { fail("Missing value in dict"); done(); return }

                                expect(output.variables["$homeScore"]!.doubleValue).to(equal(1))

                                done()
                            }
                        }
                    }

                    it("updates a series of values") {
                        input = AnnotationService.EvaluationInput(
                            actions: actions,
                            activeOverlayIds: Set(),
                            currentTime: 12000,
                            currentDuration: 20000)

                        waitUntil { done in
                            self.annotationService.evaluate(input) { (output) in
                                guard output.variables.count == 1 else { fail("Wrong array count"); done(); return }
                                guard output.variables["$homeScore"] != nil else { fail("Missing value in dict"); done(); return }

                                expect(output.variables["$homeScore"]!.doubleValue).to(equal(12.529))

                                done()
                            }
                        }
                    }
                }

                it("does not increment a non-existing variable") {
                    actions = self.makeAnnotationActionsFromJSON("testAnnotationService_incrementMissingVariable")

                    input = AnnotationService.EvaluationInput(
                        actions: actions,
                        activeOverlayIds: Set(),
                        currentTime: 4000,
                        currentDuration: 20000)

                    waitUntil { done in
                        self.annotationService.evaluate(input) { (output) in
                            guard output.variables.count == 1 else { fail("Wrong array count"); done(); return }
                            guard output.variables["$homeScore"] != nil else { fail("Missing value in dict"); done(); return }

                            expect(output.variables["$homeScore"]!.longValue).to(equal(0))

                            done()
                        }
                    }
                }

                it("does not increment a string variable") {
                    actions = self.makeAnnotationActionsFromJSON("testAnnotationService_incrementStringVariableDoesntWork")

                    input = AnnotationService.EvaluationInput(
                        actions: actions,
                        activeOverlayIds: Set(),
                        currentTime: 4000,
                        currentDuration: 20000)

                    waitUntil { done in
                        self.annotationService.evaluate(input) { (output) in
                            guard output.variables.count == 1 else { fail("Wrong array count"); done(); return }
                            guard output.variables["$homeScore"] != nil else { fail("Missing value in dict"); done(); return }

                            expect(output.variables["$homeScore"]!.stringValue).to(equal("0"))
                            expect(output.variables["$homeScore"]!.longValue).to(beNil())
                            expect(output.variables["$homeScore"]!.doubleValue).to(beNil())

                            done()
                        }
                    }
                }
            }
        }

        describe("timers") {
            var actions: [AnnotationAction]!
            var input: AnnotationService.EvaluationInput!

            it("creates") {
                actions = self.makeAnnotationActionsFromJSON("testAnnotationService_basicCreateTimer")
                input = AnnotationService.EvaluationInput(
                    actions: actions,
                    activeOverlayIds: Set(),
                    currentTime: 0,
                    currentDuration: 20000)

                waitUntil { done in
                    self.annotationService.evaluate(input) { (output) in
                        guard output.timers.count == 1 else { fail("Wrong array count"); done(); return }
                        guard output.timers["$scoreboardTimer"] != nil else { fail("Missing value in dict"); done(); return }

                        expect(output.timers["$scoreboardTimer"]!.humanFriendlyValue).to(equal("0"))

                        done()
                    }
                }
            }

            describe("recreation") {
                beforeEach {
                    actions = self.makeAnnotationActionsFromJSON("testAnnotationService_recreateTimer")
                }

                it("has a value before recreation") {
                    input = AnnotationService.EvaluationInput(
                        actions: actions,
                        activeOverlayIds: Set(),
                        currentTime: 5000,
                        currentDuration: 20000)

                    waitUntil { done in
                        self.annotationService.evaluate(input) { (output) in
                            guard output.timers.count == 1 else { fail("Wrong array count"); done(); return }
                            guard output.timers["$scoreboardTimer"] != nil else { fail("Missing value in dict"); done(); return }

                            expect(output.timers["$scoreboardTimer"]!.humanFriendlyValue).to(equal("5"))

                            done()
                        }
                    }
                }

                it("has a value after recreation, but does not keep running") {
                    input = AnnotationService.EvaluationInput(
                        actions: actions,
                        activeOverlayIds: Set(),
                        currentTime: 11000,
                        currentDuration: 20000)

                    waitUntil { done in
                        self.annotationService.evaluate(input) { (output) in
                            guard output.timers.count == 1 else { fail("Wrong array count"); done(); return }
                            guard output.timers["$scoreboardTimer"] != nil else { fail("Missing value in dict"); done(); return }

                            expect(output.timers["$scoreboardTimer"]!.humanFriendlyValue).to(equal("15"))

                            done()
                        }
                    }
                }
            }

            describe("prioritization") {
                beforeEach {
                    actions = self.makeAnnotationActionsFromJSON("testAnnotationService_timerPrioritization")
                }

                it("correctly orders timer actions at the same offset") {
                    input = AnnotationService.EvaluationInput(
                        actions: actions,
                        activeOverlayIds: Set(),
                        currentTime: 2000,
                        currentDuration: 20000)

                    waitUntil { done in
                        self.annotationService.evaluate(input) { (output) in
                            guard output.timers.count == 1 else { fail("Wrong array count"); done(); return }
                            guard output.timers["$scoreboardTimer"] != nil else { fail("Missing value in dict"); done(); return }

                            expect(output.timers["$scoreboardTimer"]!.humanFriendlyValue).to(equal("15"))
                            expect(output.timers["$scoreboardTimer"]!.isRunning).to(beFalse())

                            done()
                        }
                    }
                }
            }

            describe("formatting") {
                beforeEach {
                    actions = self.makeAnnotationActionsFromJSON("testAnnotationService_createMultipleTimers")
                }

                it("formats single values correctly") {
                    input = AnnotationService.EvaluationInput(
                        actions: actions,
                        activeOverlayIds: Set(),
                        currentTime: 700000,
                        currentDuration: 800000)

                    waitUntil { done in
                        self.annotationService.evaluate(input) { (output) in
                            guard output.timers.count == 4 else { fail("Wrong array count"); done(); return }
                            guard output.timers["$timer1"] != nil else { fail("Missing value in dict"); done(); return }

                            expect(output.timers["$timer1"]!.humanFriendlyValue).to(equal("695"))

                            done()
                        }
                    }
                }

                it("formats minutes:seconds correctly") {
                    input = AnnotationService.EvaluationInput(
                        actions: actions,
                        activeOverlayIds: Set(),
                        currentTime: 700000,
                        currentDuration: 800000)

                    waitUntil { done in
                        self.annotationService.evaluate(input) { (output) in
                            guard output.timers.count == 4 else { fail("Wrong array count"); done(); return }
                            guard output.timers["$timer2"] != nil else { fail("Missing value in dict"); done(); return }

                            expect(output.timers["$timer2"]!.humanFriendlyValue).to(equal("11:35"))

                            done()
                        }
                    }
                }
            }

            describe("downwards timers") {
                beforeEach {
                    actions = self.makeAnnotationActionsFromJSON("testAnnotationService_createMultipleTimers")
                }

                it("counts down instead of up") {
                    input = AnnotationService.EvaluationInput(
                        actions: actions,
                        activeOverlayIds: Set(),
                        currentTime: 700000,
                        currentDuration: 3600000)

                    waitUntil { done in
                        self.annotationService.evaluate(input) { (output) in
                            guard output.timers.count == 4 else { fail("Wrong array count"); done(); return }
                            guard output.timers["$timer3"] != nil else { fail("Missing value in dict"); done(); return }

                            expect(output.timers["$timer3"]!.humanFriendlyValue).to(equal("2005"))

                            done()
                        }
                    }
                }

                it("stops at the cap value") {
                    input = AnnotationService.EvaluationInput(
                        actions: actions,
                        activeOverlayIds: Set(),
                        currentTime: 3200000,
                        currentDuration: 3600000)

                    waitUntil { done in
                        self.annotationService.evaluate(input) { (output) in
                            guard output.timers.count == 4 else { fail("Wrong array count"); done(); return }
                            guard output.timers["$timer3"] != nil else { fail("Missing value in dict"); done(); return }

                            expect(output.timers["$timer3"]!.humanFriendlyValue).to(equal("400"))

                            done()
                        }
                    }
                }
            }

            describe("adjusting and skipping timers") {
                beforeEach {
                    actions = self.makeAnnotationActionsFromJSON("testAnnotationService_adjustAndSkipTimers")
                }

                it("skips") {
                    input = AnnotationService.EvaluationInput(
                        actions: actions,
                        activeOverlayIds: Set(),
                        currentTime: 2000,
                        currentDuration: 20000)

                    waitUntil { done in
                        self.annotationService.evaluate(input) { (output) in
                            guard output.timers.count == 1 else { fail("Wrong array count"); done(); return }
                            guard output.timers["$scoreboardTimer"] != nil else { fail("Missing value in dict"); done(); return }

                            expect(output.timers["$scoreboardTimer"]!.humanFriendlyValue).to(equal("12"))

                            done()
                        }
                    }
                }

                it("adjusts") {
                    input = AnnotationService.EvaluationInput(
                        actions: actions,
                        activeOverlayIds: Set(),
                        currentTime: 4000,
                        currentDuration: 20000)

                    waitUntil { done in
                        self.annotationService.evaluate(input) { (output) in
                            guard output.timers.count == 1 else { fail("Wrong array count"); done(); return }
                            guard output.timers["$scoreboardTimer"] != nil else { fail("Missing value in dict"); done(); return }

                            expect(output.timers["$scoreboardTimer"]!.humanFriendlyValue).to(equal("5"))

                            done()
                        }
                    }
                }

                it("skips negatively") {
                    input = AnnotationService.EvaluationInput(
                        actions: actions,
                        activeOverlayIds: Set(),
                        currentTime: 13000,
                        currentDuration: 20000)

                    waitUntil { done in
                        self.annotationService.evaluate(input) { (output) in
                            guard output.timers.count == 1 else { fail("Wrong array count"); done(); return }
                            guard output.timers["$scoreboardTimer"] != nil else { fail("Missing value in dict"); done(); return }

                            expect(output.timers["$scoreboardTimer"]!.humanFriendlyValue).to(equal("12"))

                            done()
                        }
                    }
                }

                it("drops into negative amounts") {
                    input = AnnotationService.EvaluationInput(
                        actions: actions,
                        activeOverlayIds: Set(),
                        currentTime: 14000,
                        currentDuration: 20000)

                    waitUntil { done in
                        self.annotationService.evaluate(input) { (output) in
                            guard output.timers.count == 1 else { fail("Wrong array count"); done(); return }
                            guard output.timers["$scoreboardTimer"] != nil else { fail("Missing value in dict"); done(); return }

                            expect(output.timers["$scoreboardTimer"]!.humanFriendlyValue).to(equal("-27"))

                            done()
                        }
                    }
                }
            }
        }
    }
}

extension AnnotationServiceSpec {
    /// Makes AnnotationAction objects from a JSON file.
    private func makeAnnotationActionsFromJSON(_ jsonFileName: String) -> [AnnotationAction] {
        if let path = Bundle(for: type(of: self)).path(forResource: jsonFileName, ofType: "json") {
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
