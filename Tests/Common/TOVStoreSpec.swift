//
// Copyright © 2020 mycujoo. All rights reserved.
//

import Foundation
import Quick
import Nimble
@testable import MLSSDK


class TOVStoreSpec: QuickSpec {

    var tovStore: TOVStore!

    override func setUp() {
         continueAfterFailure = false
    }

    override func spec() {
        beforeEach {
            self.tovStore = TOVStore()
        }

        it("saves and retrieves successfully") {
            let tovs = [
                "tov1": TOVStore.TOV(name: "tov1", humanFriendlyValue: "foo"),
                "tov2": TOVStore.TOV(name: "tov2", humanFriendlyValue: "bar"),
            ]

            self.tovStore.new(tovs: tovs)

            expect(self.tovStore.get(by: "tov1")?.humanFriendlyValue).to(equal(tovs["tov1"]?.humanFriendlyValue))
            expect(self.tovStore.get(by: "tov2")?.humanFriendlyValue).to(equal(tovs["tov2"]?.humanFriendlyValue))
            expect(self.tovStore.get(by: "tov3")?.humanFriendlyValue).to(beNil())
        }


        describe("observing") {
            it("calls single observer for tov-changes") {
                var calledAmount = 0
                waitUntil { done in
                    self.tovStore.addObserver(tovName: "tov1", callbackId: "callback1") { val in
                        switch calledAmount {
                        case 0:
                            expect(val).to(equal("tov1"))
                            expect(self.tovStore.get(by: val)?.humanFriendlyValue).to(equal("foo"))
                        case 1:
                            expect(val).to(equal("tov1"))
                            expect(self.tovStore.get(by: val)?.humanFriendlyValue).to(equal("bar"))
                        default:
                            break
                        }

                        calledAmount += 1
                        if calledAmount == 2 {
                            done()
                        }
                    }
                    // Set a new tov
                    self.tovStore.new(tovs: [
                        "tov1": TOVStore.TOV(name: "tov1", humanFriendlyValue: "foo"),
                    ])
                    // Set the same tov with all same properties (should not trigger a new call to the observer)
                    self.tovStore.new(tovs: [
                        "tov1": TOVStore.TOV(name: "tov1", humanFriendlyValue: "foo"),
                    ])
                    // Change the properties, thus triggering a new call to the observer
                    self.tovStore.new(tovs: [
                        "tov1": TOVStore.TOV(name: "tov1", humanFriendlyValue: "bar"),
                    ])
                }
            }

            it("calls multiple observers for tov-changes") {
                var calledAmount = 0
                waitUntil { done in
                    // Add a new observer
                    self.tovStore.addObserver(tovName: "tov1", callbackId: "callback1") { val in
                        fail("Should not be called, as it will be overwritten by new observer with same callbackId")
                    }
                    // Overwrite the same observer
                    self.tovStore.addObserver(tovName: "tov1", callbackId: "callback1") { val in
                        expect(self.tovStore.get(by: val)?.humanFriendlyValue).to(equal("foo"))
                        calledAmount += 1
                        if calledAmount == 2 {
                            done()
                        }
                    }
                    self.tovStore.addObserver(tovName: "tov1", callbackId: "callback2") { val in
                        expect(self.tovStore.get(by: val)?.humanFriendlyValue).to(equal("foo"))
                        calledAmount += 1
                        if calledAmount == 2 {
                            done()
                        }
                    }
                    // Set a new tov
                    self.tovStore.new(tovs: [
                        "tov1": TOVStore.TOV(name: "tov1", humanFriendlyValue: "foo"),
                    ])
                }
            }

            describe("observer removal") {
                it("removes single observer") {
                    waitUntil(timeout: 1.0) { done in
                        var wasCalled = false
                        self.tovStore.addObserver(tovName: "tov1", callbackId: "callback1") { _ in
                            wasCalled = true
                        }
                        self.tovStore.removeObserver(tovName: "tov1", callbackId: "callback1")

                        let _ = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: false) { timer in
                            expect(wasCalled).to(beFalse())
                            done()
                        }

                        self.tovStore.new(tovs: [
                            "tov1": TOVStore.TOV(name: "tov1", humanFriendlyValue: "foo")
                        ])
                    }
                }

                it("removes multiple observers by callbackId") {
                    waitUntil { done in
                        var wasCalled = false
                        self.tovStore.addObserver(tovName: "tov1", callbackId: "callback1") { _ in
                            wasCalled = true
                        }
                        self.tovStore.addObserver(tovName: "tov2", callbackId: "callback1") { _ in
                            wasCalled = true
                        }
                        self.tovStore.removeObservers(callbackId: "callback1")

                        let _ = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: false) { timer in
                            expect(wasCalled).to(beFalse())
                            done()
                        }

                        self.tovStore.new(tovs: [
                            "tov1": TOVStore.TOV(name: "tov1", humanFriendlyValue: "foo"),
                            "tov2": TOVStore.TOV(name: "tov2", humanFriendlyValue: "bar")
                        ])
                    }
                }

                it("keeps observers that are not removed by removeObserver") {
                    waitUntil { done in
                        var removedWasCalled = false
                        var keptWasCalled = false
                        self.tovStore.addObserver(tovName: "tov1", callbackId: "callback1") { _ in
                            removedWasCalled = true
                        }
                        self.tovStore.addObserver(tovName: "tov1", callbackId: "callback2") { _ in
                            keptWasCalled = true
                        }
                        self.tovStore.removeObserver(tovName: "tov1", callbackId: "callback1")

                        let _ = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: false) { timer in
                            expect(removedWasCalled).to(beFalse())
                            expect(keptWasCalled).to(beTrue())
                            done()
                        }

                        self.tovStore.new(tovs: [
                            "tov1": TOVStore.TOV(name: "tov1", humanFriendlyValue: "foo")
                        ])
                    }
                }

                it("keeps observers that are not removed by removeObservers") {
                    waitUntil { done in
                        var removedWasCalled = false
                        var keptWasCalled = false
                        self.tovStore.addObserver(tovName: "tov1", callbackId: "callback1") { _ in
                            removedWasCalled = true
                        }
                        self.tovStore.addObserver(tovName: "tov2", callbackId: "callback1") { _ in
                            removedWasCalled = true
                        }
                        self.tovStore.addObserver(tovName: "tov1", callbackId: "callback2") { _ in
                            keptWasCalled = true
                        }
                        self.tovStore.removeObservers(callbackId: "callback1")

                        let _ = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: false) { timer in
                            expect(removedWasCalled).to(beFalse())
                            expect(keptWasCalled).to(beTrue())
                            done()
                        }

                        self.tovStore.new(tovs: [
                            "tov1": TOVStore.TOV(name: "tov1", humanFriendlyValue: "foo"),
                            "tov2": TOVStore.TOV(name: "tov2", humanFriendlyValue: "bar")
                        ])
                    }
                }
            }
        }
    }
}

