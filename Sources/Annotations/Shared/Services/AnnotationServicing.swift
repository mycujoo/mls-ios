//
// Copyright © 2021 mycujoo. All rights reserved.
//

import Foundation
import MLSSDK

protocol AnnotationServicing {
    func evaluate(_ input: AnnotationService.EvaluationInput, callback: @escaping (AnnotationService.EvaluationOutput) -> ())
}

