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

        it("parses successfully") {
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

            let results = self.hlsInspectionService.map(hlsPlaylist: playlist, absoluteTimes: [])



        }
    }
}

