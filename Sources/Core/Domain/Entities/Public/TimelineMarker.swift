//
// Copyright © 2020 mycujoo. All rights reserved.
//

import UIKit


public struct TimelineMarker {
    public let color: UIColor
    public let label: String
    public let seekOffset: Int
    
    public init(color: UIColor, label: String, seekOffset: Int) {
        self.color = color
        self.label = label
        self.seekOffset = seekOffset
    }
}
