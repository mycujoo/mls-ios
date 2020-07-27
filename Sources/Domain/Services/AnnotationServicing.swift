//
// Copyright © 2020 mycujoo. All rights reserved.
//

import Foundation


protocol AnnotationServicing {
    func evaluate(_ input: AnnotationService.EvaluationInput, callback: @escaping (AnnotationService.EvaluationOutput) -> ())
}
