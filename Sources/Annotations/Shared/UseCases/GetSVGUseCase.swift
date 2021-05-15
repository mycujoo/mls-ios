//
// Copyright © 2021 mycujoo. All rights reserved.
//

import Foundation
import MLSSDK


class GetSVGUseCase {
    private let arbitraryDataRepository: MLSArbitraryDataRepository

    init(arbitraryDataRepository: MLSArbitraryDataRepository) {
        self.arbitraryDataRepository = arbitraryDataRepository
    }

    func execute(url: URL, completionHandler: @escaping (String?, Error?) -> ()) {
        arbitraryDataRepository.fetchDataAsString(byURL: url, callback: { (svg, error) in
            completionHandler(svg, error)
        })
    }
}
