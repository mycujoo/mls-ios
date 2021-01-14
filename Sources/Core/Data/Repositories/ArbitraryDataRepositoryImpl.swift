//
// Copyright © 2020 mycujoo. All rights reserved.
//

import Foundation
import Alamofire

class ArbitraryDataRepositoryImpl: ArbitraryDataRepository {
    init() {}

    func fetchData(byURL url: URL, callback: @escaping (Data?, Error?) -> ()) {
        AF.request(url, method: .get).responseData { response in
            callback(response.value, response.error)
        }
    }

    func fetchDataAsString(byURL url: URL, callback: @escaping (String?, Error?) -> ()) {
        AF.request(url, method: .get).responseString{ response in
            callback(response.value, response.error)
        }
    }
}
