//
// Copyright © 2020 mycujoo. All rights reserved.
//

import Foundation


public protocol MLSArbitraryDataRepository {
    func fetchData(byURL url: URL, callback: @escaping (Data?, Error?) -> ())
    func fetchDataAsString(byURL url: URL, callback: @escaping (String?, Error?) -> ())
}
