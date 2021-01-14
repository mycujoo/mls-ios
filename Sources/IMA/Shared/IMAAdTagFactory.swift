//
// Copyright © 2021 mycujoo. All rights reserved.
//

import Foundation


class IMAAdTagFactory: Encodable {
    private static var jsonEncoder = JSONEncoder()

    init() {}

    // For documentation, see: https://support.google.com/admanager/table/9749596?hl=en
    var sz = "640x480"
    var iu = ""
    var gdfp_req = "1"
    var env = "vp"
    var output = "xml_vast3"
    var unviewed_position_start = "1"
    var url = Bundle.main.bundleIdentifier ?? ""
    var correlator = ""
    var scor = ""
    private var cust_params = ""
    

    /// Builds a URL for a video ad tag based on the properties set on this `VideoAdTagFactory` instance as well as the provided parameters.
    /// - parameter baseURL: The URL without any query items that serves as the basis of this video tag.
    /// - parameter adUnit: The ad unit to include in this tag.
    /// - parameter customParams: An object representing the fields to be entered in the cust_params part of the video ad tag.
    /// - parameter smartProperties: When true, this will update all relevant properties to a suggested value upon building a tag.
    /// - returns: The video ad tag.
    func buildTag(baseURL: URL, adUnit: String, customParams: [String: String], smartProperties: Bool = true) -> String {
        /// - returns: The dictionary as a String of URL parameters, joined by an ampersand (without a leading question-mark).
        func encodeToURLParams(_ dict: [String: String], ignoreEmpty: Bool = true, addPercentEncoding: Bool = false) -> String {
            let encoded = dict
                .filter { !ignoreEmpty || !$0.value.isEmpty }
                .map { "\($0.key)=\($0.value)" }
                .joined(separator: "&")
            return addPercentEncoding ? encoded.addingPercentEncodingForQueryParameter() ?? "" : encoded
        }

        #if DEBUG
        if adUnit == "/124319096/external/single_ad_samples" {
            // Return the default debug ad tag provided by Google.
            return "https://pubads.g.doubleclick.net/gampad/ads?sz=640x480&iu=/124319096/external/single_ad_samples&ciu_szs=300x250&impl=s&gdfp_req=1&env=vp&output=vast&unviewed_position_start=1&cust_params=deployment%3Ddevsite%26sample_ct%3Dlinear&correlator="
        }
        #endif
        if smartProperties {
            let timestamp = "\(Int(Date().timeIntervalSince1970))"
            correlator = timestamp
            scor = timestamp
        }
        iu = adUnit
        cust_params = encodeToURLParams(customParams, addPercentEncoding: true)
        return "\(baseURL.absoluteString)?\(self.encodeToURLParams(withEncoder: IMAAdTagFactory.jsonEncoder))"
    }
}

