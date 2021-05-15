//
// Copyright © 2021 mycujoo. All rights reserved.
//

import Foundation

extension StringProtocol {
    subscript(_ range: CountableRange<Int>) -> String {
        let start = index(startIndex, offsetBy: Swift.max(0, range.lowerBound))
        let end = index(start, offsetBy: Swift.min(self.count - range.lowerBound,
                                             range.upperBound - range.lowerBound))
        return String(self[start..<end])
    }

    subscript(_ range: CountablePartialRangeFrom<Int>) -> String {
        let start = index(startIndex, offsetBy: Swift.max(0, range.lowerBound))
         return String(self[start...])
    }
}
