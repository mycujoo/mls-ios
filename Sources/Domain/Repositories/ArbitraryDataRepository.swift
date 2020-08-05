//
// Copyright © 2020 mycujoo. All rights reserved.
//

import Foundation


protocol ArbitraryDataRepository {
    func fetchDataAsString(byURL url: URL, callback: @escaping (String?, Error?) -> ())
}
