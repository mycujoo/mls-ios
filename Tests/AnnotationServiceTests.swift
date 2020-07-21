//
// Copyright © 2020 mycujoo. All rights reserved.
//

import XCTest
@testable import MLSSDK
import Cuckoo

class AnnotationServiceTests: XCTestCase {

    var annotationService: AnnotationService!
    var annotationActions: [AnnotationAction]!

    var currentTestName: String {
        return self.name.replacingOccurrences(of: "-[AnnotationServiceTests ", with: "").replacingOccurrences(of: "]", with: "")
    }

    override func setUpWithError() throws {
        annotationService = AnnotationService()
        annotationActions = makeAnnotationActionsFromJSON()
    }

    override func tearDownWithError() throws {
    }

    func testAnnotationService_basic() throws {
        
    }

}

extension AnnotationServiceTests {
    /// Makes AnnotationAction objects from a JSON file. If no jsonFileName is provided, the test name is used as the JSON file name.
    private func makeAnnotationActionsFromJSON(jsonFileName: String? = nil) -> [AnnotationAction] {
        if let path = Bundle(for: type(of: self)).path(forResource: (jsonFileName ?? currentTestName), ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)

                let decoder = JSONDecoder()
                let decoded = (try? decoder.decode(AnnotationActionWrapper.self, from: data))

                return decoded?.actions ?? []
            } catch {}
        }

        return []
    }
}
