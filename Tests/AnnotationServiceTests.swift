//
// Copyright © 2020 mycujoo. All rights reserved.
//

import XCTest
@testable import MLSSDK
import Cuckoo

class Tests: XCTestCase {

    var apiService: MockAPIServicing!
    var annotationService: MockAnnotationServicing!

    override func setUpWithError() throws {
        apiService = MockAPIServicing()
        annotationService = MockAnnotationServicing()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {

    }

}
