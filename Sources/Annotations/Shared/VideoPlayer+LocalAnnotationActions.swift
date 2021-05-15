//
// Copyright © 2021 mycujoo. All rights reserved.
//

import Foundation
import MLSSDK


extension VideoPlayer {
    /// A convenience accessor for localAnnotationActions on the annotationIntegration.
    var localAnnotationActions: [AnnotationAction] {
        get {
            return self.annotationIntegration?.localAnnotationActions ?? []
        }
        set {
            self.annotationIntegration?.localAnnotationActions = newValue
            self.annotationIntegration?.evaluate()
        }
    }
}
