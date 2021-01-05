//
// Copyright © 2021 mycujoo. All rights reserved.
//

import Foundation



extension String {
    /// Encodes a URL, including(!) ampersand and forward slash characters. Based on Alamofire's implementation.
    func addingPercentEncodingForQueryParameter() -> String? {
        let generalDelimitersToEncode = ":#[]@" // does not include "?" or "/" due to RFC 3986 - Section 3.4
        let subDelimitersToEncode = "!$&'()*+,;="

        var allowedCharacterSet = CharacterSet.urlQueryAllowed
        allowedCharacterSet.remove(charactersIn: "\(generalDelimitersToEncode)\(subDelimitersToEncode)")

        return addingPercentEncoding(withAllowedCharacters: allowedCharacterSet)
    }

}
