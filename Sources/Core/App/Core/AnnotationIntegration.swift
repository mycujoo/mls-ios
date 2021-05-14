//
// Copyright © 2021 mycujoo. All rights reserved.
//

import Foundation


public protocol AnnotationIntegration {
    /// This is an advanced feature. This property can be used to introduce additional annotation actions.
    /// This is in addition to the remote annotation actions that are received through the MCLS annotation system.
    /// It is advised not to touch this property without advanced knowledge of MCLS annotations.
    var localAnnotationActions: [AnnotationAction] { get set }
}

