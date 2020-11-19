//
// Copyright © 2020 mycujoo. All rights reserved.
//

import Foundation


protocol HLSInspectionServicing {
    /// Maps an array of absolute times (UNIX timestamps in milliseconds) to an array of videoOffsets (in milliseconds).
    /// It will also indicate whether these mapped videoOffsets fall into a gap (i.e. in a moment when there is no video).
    /// - parameter hlsPlaylist: The HLS playlist (not the master playlist, but the one that contains segments) as a string.
    /// - parameter absoluteTimes: A list of UNIX timestamps in milliseconds
    func map(hlsPlaylist: String, absoluteTimes: [Int64]) -> [(videoOffset: Int64, inGap: Bool)]
}
