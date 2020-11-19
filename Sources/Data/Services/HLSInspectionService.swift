//
// Copyright © 2020 mycujoo. All rights reserved.
//

import Foundation

class HLSInspectionService: HLSInspectionServicing {
    func map(hlsPlaylist: String?, absoluteTimes: [Int64]) -> [Int64: (videoOffset: Int64, inGap: Bool)?] {
        guard let hlsPlaylist = hlsPlaylist else { return [:] }

        var lineHasExtInf = false

        for line in hlsPlaylist.split(separator: "\n") {
            if lineHasExtInf {
                // This indicates that the previous line contained an #EXTINF field.
                lineHasExtInf = false
                guard let url = URL(string: String(line)), let segmentName = url.pathComponents.last else { continue }
                let spl = segmentName.split(separator: "_")
                guard spl.count > 2 else { continue }
                let timestamp = spl[2]

                print("Timestamp: \(timestamp)")
            } else if line.count > 8 && line[4..<8] == "INF:" {
                let spl = line.split(separator: ":")
                guard spl.count > 1, spl[1].count > 1, let segmentSize = Double(spl[1][0..<(spl[1].count - 1)]) else {
                    continue
                }
                lineHasExtInf = true
                print("Segment size: \(segmentSize)")
            }




            // Step 2. Extract the segment duration of EXTINF
            // Step 3. Extract the timestamp from the segment name.
            // Step 4. Place each input timestamp into this timeline.
        }
        return [:]
    }
}
