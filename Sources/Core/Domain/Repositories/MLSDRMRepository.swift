//
// Copyright © 2020 mycujoo. All rights reserved.
//

import Foundation


public protocol MLSDRMRepository {
    func fetchCertificate(byURL url: URL, callback: @escaping (Data?, Error?) -> ())
    /// - parameter url: The license url
    /// - parameter spcData: The Server Playback Context data. This can be obtained through `loadingRequest.streamingContentKeyRequestData`.
    func fetchLicense(byURL url: URL, spcData: Data, callback: @escaping (Data?, Error?) -> ())
}
