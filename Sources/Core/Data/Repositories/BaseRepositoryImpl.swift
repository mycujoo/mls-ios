//
// Copyright © 2020 mycujoo. All rights reserved.
//

import Foundation
import Moya

class BaseRepositoryImpl {
    public enum BaseRepositoryErr: Error {
        case non2xxStatusCode(statusCode: Int)
    }
    
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
    
    /// Use this method when there is no Decodable to map to, and the status code is the only indicator of success or failure.
    func _mutateToVoid(_ endpoint: API, callback: @escaping (Void?, Error?) -> ()) {
        api.request(endpoint) { result in
            switch result {
            case .success(let response):
                if 200...299 ~= response.statusCode { //~= 200...299 {
                    callback((), nil)
                } else {
                    callback(nil, BaseRepositoryErr.non2xxStatusCode(statusCode: response.statusCode))
                }
            case .failure(let error):
                callback(nil, error)
            }
        }       

    }
}
