//
// Copyright © 2020 mycujoo. All rights reserved.
//

import Foundation


class GetSVGUseCase {
    private let arbitraryDataRepository: ArbitraryDataRepository

    init(arbitraryDataRepository: ArbitraryDataRepository) {
        self.arbitraryDataRepository = arbitraryDataRepository
    }

    func execute(url: URL, completionHandler: @escaping (String?, Error?) -> ()) {
        arbitraryDataRepository.fetchDataAsString(byURL: url, callback: { (svg, error) in
            completionHandler(svg, error)
        })
    }
}
