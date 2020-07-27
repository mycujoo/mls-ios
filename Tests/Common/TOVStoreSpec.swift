//
// Copyright © 2020 mycujoo. All rights reserved.
//

import Foundation
import Quick
import Nimble
@testable import MLSSDK

//
//class TOVStoreSpec: QuickSpec {
//
//    var tovStore: TOVStore!
//
//    override func setUp() {
//         continueAfterFailure = false
//    }
//
//    override func spec() {
//        beforeEach {
//            self.tovStore = TOVStore()
//        }
//
//        describe("saving and retrieving") {
//            it("saves and retrieves variables") {
//                let variables = [
//                    "variable1": AnnotationService.Variable(name: "variable1", stringValue: "abc", doubleValue: nil, longValue: nil, doublePrecision: nil),
//                    "variable2": TOVStore.Variable(name: "variable2", stringValue: nil, doubleValue: 200.2828, longValue: nil, doublePrecision: 2),
//                    "variable3": TOVStore.Variable(name: "variable3", stringValue: nil, doubleValue: nil, longValue: 500, doublePrecision: nil),
//                ]
//
//                self.tovStore.new(variables: variables)
//
//                expect(self.tovStore.get(by: "variable1")?.humanFriendlyValue).to(equal(variables["variable1"]?.humanFriendlyValue))
//                expect(self.tovStore.get(by: "variable2")?.humanFriendlyValue).to(equal(variables["variable2"]?.humanFriendlyValue))
//                expect(self.tovStore.get(by: "variable3")?.humanFriendlyValue).to(equal(variables["variable3"]?.humanFriendlyValue))
//                expect(self.tovStore.get(by: "variable4")?.humanFriendlyValue).to(beNil())
//            }
//
//            it("saves and retrieves timers") {
//                let timers = [
//                    "timer1": TOVStore.Timer(name: "timer1", format: .s, direction: .up, startValue: 0),
//                    "timer2": TOVStore.Timer(name: "timer2", format: .ms, direction: .down, startValue: 270000),
//                ]
//
//                self.tovStore.new(timers: timers)
//
//                expect(self.tovStore.get(by: "timer1")?.humanFriendlyValue).to(equal(timers["timer1"]?.humanFriendlyValue))
//                expect(self.tovStore.get(by: "timer2")?.humanFriendlyValue).to(equal(timers["timer2"]?.humanFriendlyValue))
//                expect(self.tovStore.get(by: "timer3")?.humanFriendlyValue).to(beNil())
//            }
//        }
//
//        describe("observing") {
//            beforeEach {
//                self.tovStore.new(variables: [:])
//                self.tovStore.new(timers: [:])
//            }
//
//            it("calls single observer for timer-changes") {
//                var calledAmount = 0
//                waitUntil { done in
//                    self.tovStore.addObserver(tovName: "timer1", callbackId: "callback1") { val in
//                        switch calledAmount {
//                        case 0:
//                            expect(val).to(equal("timer1"))
//                            expect(self.tovStore.get(by: val)?.humanFriendlyValue).to(equal("100"))
//                        case 1:
//                            expect(val).to(equal("timer1"))
//                            expect(self.tovStore.get(by: val)?.humanFriendlyValue).to(equal("50"))
//                        default:
//                            break
//                        }
//
//                        calledAmount += 1
//                        if calledAmount == 2 {
//                            done()
//                        }
//                    }
//                    // Set a new timer
//                    self.tovStore.new(timers: [
//                        "timer1": TOVStore.Timer(name: "timer1", format: .s, direction: .up, startValue: 100000),
//                    ])
//                    // Set the same timer with all new same properties (should not trigger a new call to the observer)
//                    self.tovStore.new(timers: [
//                        "timer1": TOVStore.Timer(name: "timer1", format: .s, direction: .up, startValue: 100000),
//                    ])
//                    // Change the properties, thus triggering a new call to the observer
//                    self.tovStore.new(timers: [
//                        "timer1": TOVStore.Timer(name: "timer1", format: .s, direction: .up, startValue: 50000),
//                    ])
//                }
//
//            }
//        }
//    }
//}
//
