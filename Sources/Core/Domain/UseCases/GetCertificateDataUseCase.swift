//
// Copyright © 2020 mycujoo. All rights reserved.
//

import Foundation


class GetCertificateDataUseCase {
    private let drmRepository: MLSDRMRepository

    init(drmRepository: MLSDRMRepository) {
        self.drmRepository = drmRepository
    }

    func execute(url: URL, completionHandler: @escaping (Data?, Error?) -> ()) {
        drmRepository.fetchCertificate(byURL: url, callback: { (data, error) in
            completionHandler(data, error)
        })
    }
}
