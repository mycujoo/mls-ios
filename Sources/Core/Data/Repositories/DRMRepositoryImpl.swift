//
// Copyright © 2020 mycujoo. All rights reserved.
//

import Foundation
import Alamofire

class DRMRepositoryImpl: MLSDRMRepository {
    init() {}

    func fetchCertificate(byURL url: URL, callback: @escaping (Data?, Error?) -> ()) {
        AF.request(url, method: .get).responseData { response in
            callback(response.value, response.error)
        }
    }

    func fetchLicense(byURL url: URL, spcData: Data, callback: @escaping (Data?, Error?) -> ()) {
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = spcData
        request.headers = [
            "Content-Type": "application/octet-stream"
        ]
        let session = URLSession(configuration: URLSessionConfiguration.default)
        let task = session.dataTask(with: request) { data, _, error in
            callback(data, error)
        }
        task.resume()
    }

}
