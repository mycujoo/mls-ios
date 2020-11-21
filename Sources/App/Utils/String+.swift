//
// Copyright © 2020 mycujoo. All rights reserved.
//

import Foundation


extension String {
    func replacingFirstOccurrence(of target: String, with replacement: String) -> String {
        guard let range = self.range(of: target) else { return self }
        return self.replacingCharacters(in: range, with: replacement)
    }
}

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
