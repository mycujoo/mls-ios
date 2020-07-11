//
// Copyright © 2020 mycujoo. All rights reserved.
//

import Foundation

public enum ParamEventStatus: String {
    case scheduled    = "EVENT_STATUS_SCHEDULED"
    case rescheduled  = "EVENT_STATUS_RESCHEDULED"
    case cancelled    = "EVENT_STATUS_CANCELLED"
    case postponed    = "EVENT_STATUS_POSTPONED"
    case delayed      = "EVENT_STATUS_DELAYED"
    case started      = "EVENT_STATUS_STARTED"
    case paused       = "EVENT_STATUS_PAUSED"
    case suspended    = "EVENT_STATUS_SUSPENDED"
    case finished     = "EVENT_STATUS_FINISHED"
    case unspecified  = "EVENT_STATUS_UNSPECIFIED"
}
