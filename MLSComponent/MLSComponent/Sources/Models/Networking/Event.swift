//
// Copyright © 2020 mycujoo. All rights reserved.
//

import Foundation

public struct EventWrapper: Decodable {
    public let events: [Event]
}

public struct Event: Decodable {
    public let id: String
    public let title: String?
    public let description: String?
    public let thumbnailUrl: URL?
    public let organiser: String?
    public let timezone: String?
    public let startTime: Date?
    public let status: EventStatus
    public let streams: [Stream]
    public let timelineIds: [String]
}

public extension Event {
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case description
        case thumbnailUrl = "thumbnail_url"
        case organiser
        case timezone
        case startTime = "start_time"
        case status
        case streams
        case timelineIds = "timeline_ids"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let id: String = try container.decode(String.self, forKey: .id)
        let title: String? = try? container.decode(String.self, forKey: .title)
        let description: String? = try? container.decode(String.self, forKey: .description)
        let thumbnailUrl: URL? = try? container.decode(URL.self, forKey: .thumbnailUrl)
        let organiser: String? = try? container.decode(String.self, forKey: .organiser)
        let timezone: String? = try? container.decode(String.self, forKey: .timezone)
        let startTime: Date?
        if let startTime_ = try? container.decode(String.self, forKey: .startTime) {
            startTime = API.eventDateTimeFormatter.date(from: startTime_)
        } else {
            startTime = nil
        }
        let status: EventStatus = EventStatus(rawValue: try? container.decode(String.self, forKey: .status))
        let streams: [Stream] = (try? container.decode([Stream].self, forKey: .streams)) ?? []
        let timelineIds: [String] = (try? container.decode([String].self, forKey: .timelineIds)) ?? []

        self.init(id: id, title: title, description: description, thumbnailUrl: thumbnailUrl, organiser: organiser, timezone: timezone, startTime: startTime, status: status, streams: streams, timelineIds: timelineIds)
    }
}

public enum EventStatus {
    case scheduled, rescheduled, cancelled, postponed, delayed, started, paused, suspended, finished, unspecified
}

public extension EventStatus {
    init(rawValue: String?) {
        switch rawValue {
        case "EVENT_STATUS_SCHEDULED":
            self = .scheduled
        case "EVENT_STATUS_RESCHEDULED":
            self = .rescheduled
        case "EVENT_STATUS_CANCELLED":
            self = .cancelled
        case "EVENT_STATUS_POSTPONED":
            self = .postponed
        case "EVENT_STATUS_DELAYED":
            self = .delayed
        case "EVENT_STATUS_STARTED":
            self = .started
        case "EVENT_STATUS_PAUSED":
            self = .paused
        case "EVENT_STATUS_SUSPENDED":
            self = .suspended
        case "EVENT_STATUS_FINISHED":
            self = .finished
        default:
            self = .unspecified
        }
    }
}
