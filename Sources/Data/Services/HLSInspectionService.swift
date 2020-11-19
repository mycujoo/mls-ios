//
// Copyright © 2020 mycujoo. All rights reserved.
//

import Foundation

class HLSInspectionService: HLSInspectionServicing {
    func map(hlsPlaylist: String?, absoluteTimes: [Int64]) -> [Int64: (videoOffset: Int64, inGap: Bool)?] {
        guard let hlsPlaylist = hlsPlaylist else { return [:] }

        var lineHasExtInf = false

        var timePassed: Int64 = 0
        var targetSegmentSize: Int64 = 0
        var currentSegmentSize: Int64 = 0
        var currentTime: Int64 = 0

        var remainingTimes = absoluteTimes.sorted()

        var results: [Int64: (videoOffset: Int64, inGap: Bool)?] = [:]

        for line in hlsPlaylist.split(separator: "\n") {
            if lineHasExtInf {
                // This indicates that the previous line contained an #EXTINF field.
                lineHasExtInf = false
                guard let url = URL(string: String(line)), let segmentName = url.pathComponents.last else { continue }
                let spl = segmentName.split(separator: "_")
                guard spl.count > 2, let ts = Int64(spl[2]) else { continue }
                let timestamp = spl[2].count == 10 ? ts * 1000 : ts // temporary, since the streaming team uses both seconds and milliseconds

                currentTime = timestamp

                var newRemainingTimes = remainingTimes
                for time in remainingTimes {
                    if time < currentTime {
                        results[time] = (videoOffset: -1, inGap: true)
                        newRemainingTimes.removeFirst()
                    } else if time - currentSegmentSize <= currentTime {
                        results[time] = (videoOffset: timePassed + (time - currentTime), inGap: false)
                        newRemainingTimes.removeFirst()
                    } else if time - targetSegmentSize <= currentTime {
                        results[time] = (videoOffset: timePassed + currentSegmentSize, inGap: true)
                        newRemainingTimes.removeFirst()
                    } else {
                        break
                    }
                }
                remainingTimes = newRemainingTimes

                timePassed += currentSegmentSize
            } else if line.count > 8 && line[4..<8] == "INF:" {
                let spl = line.split(separator: ":")
                guard spl.count > 1, spl[1].count > 1, let segmentSizeDouble = Double(spl[1][0..<(spl[1].count - 1)]) else {
                    continue
                }
                currentSegmentSize = Int64(segmentSizeDouble * 1000)
                lineHasExtInf = true
            } else if targetSegmentSize == 0 && line.count > 21 && line[5..<21] == "X-TARGETDURATION" {
                let spl = line.split(separator: ":")
                guard spl.count > 1, spl[1].count > 1, let targetSegmentSizeDouble = Double(spl[1][0..<spl[1].count]) else {
                    continue
                }
                targetSegmentSize = Int64(targetSegmentSizeDouble * 1000)
            }
        }
        return results
    }
}
