//
// Copyright © 2020 mycujoo. All rights reserved.
//

import Foundation

class HLSInspectionService: HLSInspectionServicing {
    func map(hlsPlaylist: String?, absoluteTimes: [Int64]) -> [Int64: (videoOffset: Int64, inGap: Bool)?] {
        guard let hlsPlaylist = hlsPlaylist else { return [:] }

        for line in hlsPlaylist.split(separator: "\n") {
            guard line.count > 8 && line[4..<8] == "INF:" else {
                continue
            }
            // Step 2. Extract the segment duration of EXTINF
            // Step 3. Extract the timestamp from the segment name.
            // Step 4. Place each input timestamp into this timeline.
        }
        return [:]
    }
}
