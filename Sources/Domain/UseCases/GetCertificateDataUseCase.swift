//
// Copyright © 2020 mycujoo. All rights reserved.
//

import Foundation


class GetCertificateDataUseCase {
    private let arbitraryDataRepository: ArbitraryDataRepository

    init(arbitraryDataRepository: ArbitraryDataRepository) {
        self.arbitraryDataRepository = arbitraryDataRepository
    }

    func execute(url: URL, completionHandler: @escaping (Data?, Error?) -> ()) {
        arbitraryDataRepository.fetchData(byURL: url, callback: { (data, error) in
            completionHandler(data, error)
        })
    }
}
