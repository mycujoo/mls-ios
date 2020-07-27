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
            beforeEach {
                self.tovStore.new(tovs: [:])
            }

            it("calls single observer for timer-changes") {
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
                    // Set a new timer
                    self.tovStore.new(tovs: [
                        "tov1": TOVStore.TOV(name: "tov1", humanFriendlyValue: "foo"),
                    ])
                    // Set the same timer with all same properties (should not trigger a new call to the observer)
                    self.tovStore.new(tovs: [
                        "tov1": TOVStore.TOV(name: "tov1", humanFriendlyValue: "foo"),
                    ])
                    // Change the properties, thus triggering a new call to the observer
                    self.tovStore.new(tovs: [
                        "tov1": TOVStore.TOV(name: "tov1", humanFriendlyValue: "bar"),
                    ])
                }

            }
        }
    }
}

