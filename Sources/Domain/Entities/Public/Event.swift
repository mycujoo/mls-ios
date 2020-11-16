//
// Copyright © 2020 mycujoo. All rights reserved.
//

import Foundation


public struct Event: Equatable {
    public let id: String
    public let title: String?
    /// The description of the event (not to be confused with Swift's native `description` property
    public let descriptionText: String?
    public let thumbnailUrl: URL?
    public let organiser: String?
    public let timezone: String?
    public let startTime: Date?
    public let status: EventStatus
    public let streams: [Stream]
    public let timelineIds: [String]

    init(
            id: String,
            title: String?,
            /// The description of the event (not to be confused with Swift's native `description` property,
            descriptionText: String?,
            thumbnailUrl: URL?,
            organiser: String?,
            timezone: String?,
            startTime: Date?,
            status: EventStatus,
            streams: [Stream],
            timelineIds: [String]
    ) {
        self.id = id
        self.title = title
        self.descriptionText = descriptionText
        self.thumbnailUrl = thumbnailUrl
        self.organiser = organiser
        self.timezone = timezone
        self.startTime = startTime
        self.status = status
        self.streams = streams
        self.timelineIds = timelineIds
    }
}

public enum EventStatus: Int, Equatable {
    case scheduled, rescheduled, cancelled, postponed, delayed, started, paused, suspended, finished, unspecified
}

// MARK: Parameters

public enum ParamEventStatus: Int, Equatable {
    case scheduled
    case rescheduled
    case cancelled
    case postponed
    case delayed
    case started
    case paused
    case suspended
    case finished
    case unspecified
}

public enum ParamEventOrder: Int, Equatable {
    case startTimeAsc
    case startTimeDesc
    case titleAsc
    case titleDesc
    case unspecified
}
