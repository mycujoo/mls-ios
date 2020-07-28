//
// Copyright © 2020 mycujoo. All rights reserved.
//

import Foundation
import Alamofire

class ArbitraryDataRepositoryImpl: ArbitraryDataRepository {
    init() {}

    func fetchDataAsString(byURL url: URL, callback: @escaping (String?, Error?) -> ()) {
        AF.request(url, method: .get).responseString{ response in
            callback(response.value, response.error)
        }
    }
}
