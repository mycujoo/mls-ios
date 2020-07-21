//
// Copyright © 2020 mycujoo. All rights reserved.
//

import XCTest
@testable import MLSSDK
import Cuckoo

class AnnotationServiceTests: XCTestCase {

    var annotationService: AnnotationService!

    var currentTestName: String {
        // get the name and remove the class name and what comes before the class name
        var currentTestName = self.name.replacingOccurrences(of: "-[AnnotationServiceTests ", with: "")

        // And then you'll need to remove the closing square bracket at the end of the test name

        currentTestName = currentTestName.replacingOccurrences(of: "]", with: "")
    }

    override func setUpWithError() throws {
        annotationService = AnnotationService()
    }

    override func tearDownWithError() throws {
    }

    func testAnnotationService_basic() throws {
        print("Running basic stuff:", self.name)


    }

}

extension AnnotationServiceTests {
//    private func makeAnnotationActionsFrom(jsonName: String) -> [AnnotationAction] {
//        if let path = Bundle.main.path(forResource: "test", ofType: "json") {
//            do {
//                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
//
//            } catch {
//                print("Caught", error)
//                return []
//            }
//        }
//
//
//
//        let decoder = JSONDecoder()
//        let _ = (try? decoder.decode(AnnotationActionWrapper.self, from: Data()))
//
//        return []
//    }
}
