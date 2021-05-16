//
// Copyright © 2021 mycujoo. All rights reserved.
//

import Foundation


protocol HLSInspectionServicing {
    /// Maps an array of absolute times (UNIX timestamps in milliseconds) to an array of videoOffsets (in milliseconds).
    /// It will also indicate whether these mapped videoOffsets fall into a gap (i.e. in a moment when there is no video).
    /// - parameter hlsPlaylist: The HLS playlist (not the master playlist, but the one that contains segments) as a string.
    /// - parameter absoluteTimes: A list of UNIX timestamps in milliseconds
    /// - returns: A dictionary with absolute times as keys, and values of video offsets and whether the offset is at a gap or not.
    ///   If the mapping could not be done (e.g. because of a faulty playlist), nil is returned within the array.
    func map(hlsPlaylist: String?, absoluteTimes: [Int64]) -> [Int64: (videoOffset: Int64, inGap: Bool)?]
}
