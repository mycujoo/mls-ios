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

        fit("parses basic playlist successfully") {
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

            let inputTimes: [Int64] = [1605802502000]

            let expectedResults: [Int64 : (videoOffset: Int64, inGap: Bool)?] = [
                1605802502000: (videoOffset: 4000, inGap: false)
            ]
            let results = self.hlsInspectionService.map(hlsPlaylist: playlist, absoluteTimes: inputTimes)


            for time in inputTimes {
                guard let result = results[time], let expectedResult = expectedResults[time] else {
                    fail("Missing the absolute time in the (expected) result set")
                    return
                }

                expect(result?.videoOffset).to(equal(expectedResult?.videoOffset))
                expect(result?.inGap).to(equal(expectedResult?.inGap))
            }
        }
    }
}

