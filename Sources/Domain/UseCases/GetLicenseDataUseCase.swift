//
// Copyright © 2020 mycujoo. All rights reserved.
//

import Foundation


class GetLicenseDataUseCase {
    private let drmRepository: DRMRepository

    init(drmRepository: DRMRepository) {
        self.drmRepository = drmRepository
    }

    /// - parameter url: The license url
    /// - parameter spcData: The Server Playback Context data. This can be obtained through `loadingRequest.streamingContentKeyRequestData`.
    func execute(url: URL, spcData: Data, completionHandler: @escaping (Data?, Error?) -> ()) {
        drmRepository.fetchLicense(byURL: url, spcData: spcData, callback: { (data, error) in
            completionHandler(data, error)
        })
    }
}
