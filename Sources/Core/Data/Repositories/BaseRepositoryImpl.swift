//
// Copyright © 2020 mycujoo. All rights reserved.
//

import Foundation
import Moya

class BaseRepositoryImpl {
    let api: MoyaProvider<API>

    init(api: MoyaProvider<API>) {
        self.api = api
    }

    func _fetch<T: Decodable>(_ endpoint: API, type t: T.Type, callback: @escaping (T?, Error?) -> ()) {
        api.request(endpoint) { result in
            switch result {
            case .success(let response):
                let decoder = JSONDecoder()
                do {
                    let data = try decoder.decode(t.self, from: response.data)
                    callback(data, nil)
                } catch {
                    callback(nil, error)
                }
            case .failure(let error):
                callback(nil, error)
            }
        }
    }
    
    func _mutate<T: Decodable>(_ endpoint: API, type t: T.Type, callback: @escaping (T?, Error?) -> ()) {
        api.request(endpoint) { result in
            switch result {
            case .success(let response):
                let decoder = JSONDecoder()
                do {
                    let data = try decoder.decode(t.self, from: response.data)
                    callback(data, nil)
                } catch {
                    callback(nil, error)
                }
            case .failure(let error):
                callback(nil, error)
            }
        }
    }
}
