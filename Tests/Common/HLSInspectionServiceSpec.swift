//
// Copyright © 2020 mycujoo. All rights reserved.
//

import Foundation
import Quick
import Nimble
@testable import MLSSDK


class HLSInspectionServiceSpec: QuickSpec {

    var hlsInspectionService: HLSInspectionService!

    override func setUp() {
         continueAfterFailure = false
    }

    override func spec() {
        beforeEach {
            self.hlsInspectionService = HLSInspectionService()
        }

        it("parses basic playlist successfully") {
            let playlist = """
                #EXTM3U
                #EXT-X-MEDIA-SEQUENCE:0
                #EXT-X-TARGETDURATION:10
                #EXT-X-PROGRAM-DATE-TIME:2020-01-01T00:00:00.000Z
                #EXTINF:10.000,
                https://dc9jagk60w3y3mt6171f-c58c87.p5cdn.com/mats/ckgjnmgsg021l0126yxsiqnjm/720p/720_segment_1605802498_00000.ts
                #EXTINF:8.000,
                https://dc9jagk60w3y3mt6171f-c58c87.p5cdn.com/mats/ckgjnmgsg021l0126yxsiqnjm/720p/720_segment_1605802508_00001.ts
                #EXT-X-DISCONTINUITY
                #EXT-X-PROGRAM-DATE-TIME:2020-01-01T00:00:25.000Z
                #EXTINF:10.000,
                https://dc9jagk60w3y3mt6171f-c58c87.p5cdn.com/mats/ckgjnmgsg021l0126yxsiqnjm/720p/720_segment_1605802523_00002.ts
                #EXTINF:10.000,
                https://dc9jagk60w3y3mt6171f-c58c87.p5cdn.com/mats/ckgjnmgsg021l0126yxsiqnjm/720p/720_segment_1605802533_00003.ts
                #EXT-X-ENDLIST
                """

            let inputTimes: [Int64] = [
                1,
                1605802502000,
                1605802503000,
                1605802515000,
                1605802516000,
                1605802517000,
                1605802523000,
                1605802523001,
                1605802533000,
                1605802543000,
                1605802544000]

            let expectedResults: [Int64 : (videoOffset: Int64, inGap: Bool)?] = [
                1: (videoOffset: -1, inGap: true),
                1605802502000: (videoOffset: 4000, inGap: false),
                1605802503000: (videoOffset: 5000, inGap: false),
                1605802515000: (videoOffset: 17000, inGap: false),
                1605802516000: (videoOffset: 18000, inGap: false),
                1605802517000: (videoOffset: 18000, inGap: true),
                1605802523000: (videoOffset: 18000, inGap: false),
                1605802523001: (videoOffset: 18001, inGap: false),
                1605802533000: (videoOffset: 28000, inGap: false),
                1605802543000: (videoOffset: 38000, inGap: false),
                1605802544000: nil
            ]
            let results = self.hlsInspectionService.map(hlsPlaylist: playlist, absoluteTimes: inputTimes)

            for inputTime in inputTimes {
                let result = results[inputTime]

                if let expectedResult = expectedResults[inputTime], let expectedResult_ = expectedResult {
                    expect(result??.videoOffset).to(equal(expectedResult_.videoOffset))
                    expect(result??.inGap).to(equal(expectedResult_.inGap))
                } else {
                    expect(result??.videoOffset).to(beNil())
                    expect(result??.inGap).to(beNil())
                }
            }
        }
    }
}

