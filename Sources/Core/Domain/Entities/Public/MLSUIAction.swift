//
// Copyright © 2020 mycujoo. All rights reserved.
//
import Foundation


/// This class is used simply to namespace the actions,
/// so that these actions (which are aimed at manipulating the UI) can be differentiated from the domain actions.
public class MLSUI {}

public protocol MLSUIAction {
    /// The actionId can be used to internally track progress.
    var actionId: String { get }
}

public extension MLSUI {
    struct ShowTimelineMarkerAction: MLSUIAction {
        public let actionId: String
        public let timelineMarker: TimelineMarker
        /// The position where this marker should be placed. Expressed as a float between 0.0 (start of stream) and 1.0 (end of stream).
        public let position: Double
        /// The position to which the user should seek when navigating to this marker. Expressed as a float between 0.0 (start of stream) and 1.0 (end of stream).
        public let seekPosition: Double
        
        public init(actionId: String, timelineMarker: TimelineMarker, position: Double, seekPosition: Double) {
            self.actionId = actionId
            self.timelineMarker = timelineMarker
            self.position = position
            self.seekPosition = seekPosition
        }
    }
}
