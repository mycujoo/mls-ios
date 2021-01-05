//
// Copyright © 2021 mycujoo. All rights reserved.
//

import Foundation


extension Encodable {
    /// - returns: The Encodable as a dictionary.
    func encodeToDict(withEncoder jsonEncoder: JSONEncoder) -> [String: Any] {
        if let jsonData = try? jsonEncoder.encode(self) {
            return ((((try? JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any]) as [String: Any]??)) ?? [:]) ?? [:]
        }
        return [:]
    }

    /// - returns: The Encodable as a String of URL parameters, joined by an ampersand (without a leading question-mark).
    func encodeToURLParams(withEncoder jsonEncoder: JSONEncoder, ignoreEmpty: Bool = true, addPercentEncoding: Bool = false) -> String {
        let encoded = encodeToDict(withEncoder: jsonEncoder)
            .filter { !ignoreEmpty || !($0.value is String) || !($0.value as! String).isEmpty }
            .map { "\($0.key)=\($0.value)" }
            .joined(separator: "&")
        return addPercentEncoding ? encoded.addingPercentEncodingForQueryParameter() ?? "" : encoded
    }
}
