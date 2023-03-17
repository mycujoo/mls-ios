//
// Copyright © 2020 mycujoo. All rights reserved.
//

import Foundation


extension DataLayer {

    // MARK: Decodables

    struct EventListWrapper: Decodable {
        let events: [Event]
        let nextPageToken: String?
        let previousPageToken: String?
    }
    
    struct EventByIdWrapper: Decodable {
        let event: Event
    }

    struct Event: Decodable {
        let id: String
        let title: String?
        /// The description of the event (not to be confused with Swift's native `description` property
        let descriptionText: String?
        let posterUrl: URL?
        let thumbnailUrl: URL?
        let organiser: String?
        let timezone: String?
        let startTime: Date?
        let status: EventStatus
        let isProtected: Bool
        let streams: [Stream]
        let timelineIds: [String]
    }
    enum EventStatus {
        case scheduled, rescheduled, cancelled, postponed, delayed, started, paused, suspended, finished, unspecified
    }

    // MARK: Encodables

    enum ParamEventStatus: String {
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

    enum ParamEventOrder: String {
        case startTimeAsc  = "ORDER_START_TIME_ASC"
        case startTimeDesc = "ORDER_START_TIME_DESC"
        case titleAsc      = "ORDER_TITLE_ASC"
        case titleDesc     = "ORDER_TITLE_DESC"
        case unspecified   = "ORDER_UNSPECIFIED"
    }

}

extension DataLayer.EventListWrapper {
    enum CodingKeys: String, CodingKey {
        case events
        case nextPageToken = "next_page_token"
        case previousPageToken = "previous_page_token"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let events: [DataLayer.Event] = try container.decode([DataLayer.Event].self, forKey: .events)
        let nextPageToken: String? = try? container.decode(String.self, forKey: .nextPageToken)
        let previousPageToken: String? = try? container.decode(String.self, forKey: .previousPageToken)

        self.init(events: events, nextPageToken: nextPageToken, previousPageToken: previousPageToken)
    }
}

extension DataLayer.EventByIdWrapper {
    enum CodingKeys: String, CodingKey {
        case event
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let event: DataLayer.Event = try container.decode(DataLayer.Event.self, forKey: .event)

        self.init(event: event)
    }
}

extension DataLayer.Event {
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case description
        case posterUrl
        case thumbnailUrl
        case organiser
        case timezone
        case startTime
        case status
        case isProtected
        case streams
        case timelineIds
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let id: String = try container.decode(String.self, forKey: .id)
        let title: String? = try? container.decode(String.self, forKey: .title)
        let descriptionText: String? = try? container.decode(String.self, forKey: .description)
        let posterUrl: URL? = try? container.decode(URL.self, forKey: .posterUrl)
        let thumbnailUrl: URL? = try? container.decode(URL.self, forKey: .thumbnailUrl)
        let organiser: String? = try? container.decode(String.self, forKey: .organiser)
        let timezone: String? = try? container.decode(String.self, forKey: .timezone)
        let startTime: Date?
        if let startTime_ = try? container.decode(String.self, forKey: .startTime) {
            startTime = API.eventDateTimeFormatter.date(from: startTime_)
        } else {
            startTime = nil
        }
        let status: DataLayer.EventStatus = DataLayer.EventStatus(rawValue: try? container.decode(String.self, forKey: .status))
        let isProtected: Bool = (try? container.decode(Bool.self, forKey: .isProtected)) ?? false
        let streams: [DataLayer.Stream] = (try? container.decode([DataLayer.Stream].self, forKey: .streams)) ?? []
        let timelineIds: [String] = (try? container.decode([String].self, forKey: .timelineIds)) ?? []

        self.init(id: id, title: title, descriptionText: descriptionText, posterUrl: posterUrl, thumbnailUrl: thumbnailUrl, organiser: organiser, timezone: timezone, startTime: startTime, status: status, isProtected: isProtected, streams: streams, timelineIds: timelineIds)
    }
}

extension DataLayer.EventStatus {
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

// - MARK: Mappers

extension DataLayer.Event {
    var toDomain: MLSSDK.Event {
        return MLSSDK.Event(id: self.id, title: self.title, descriptionText: self.descriptionText, posterUrl: self.posterUrl, thumbnailUrl: self.thumbnailUrl, organiser: self.organiser, timezone: self.timezone, startTime: self.startTime, status: self.status.toDomain, isProtected: self.isProtected, streams: self.streams.map { $0.toDomain }, timelineIds: self.timelineIds, isMLS: true)
    }
}

extension DataLayer.EventStatus {
    var toDomain: MLSSDK.EventStatus {
        switch self {
            case .scheduled:   return .scheduled
            case .rescheduled: return .rescheduled
            case .cancelled:   return .cancelled
            case .postponed:   return .postponed
            case .delayed:     return .delayed
            case .started:     return .started
            case .paused:      return .paused
            case .suspended:   return .suspended
            case .finished:    return .finished
            case .unspecified: return .unspecified
        }
    }
}

extension DataLayer.ParamEventStatus {
    static func fromDomain(_ obj: MLSSDK.ParamEventStatus) -> DataLayer.ParamEventStatus {
        switch obj {
            case .scheduled:   return .scheduled
            case .rescheduled: return .rescheduled
            case .cancelled:   return .cancelled
            case .postponed:   return .postponed
            case .delayed:     return .delayed
            case .started:     return .started
            case .paused:      return .paused
            case .suspended:   return .suspended
            case .finished:    return .finished
            case .unspecified: return .unspecified
        }
    }
}

extension DataLayer.ParamEventOrder {
    static func fromDomain(_ obj: MLSSDK.ParamEventOrder) -> DataLayer.ParamEventOrder {
        switch obj {
            case .startTimeAsc:  return .startTimeAsc
            case .startTimeDesc: return .startTimeDesc
            case .titleAsc:      return .titleAsc
            case .titleDesc:     return .titleDesc
            case .unspecified:   return .unspecified
        }
    }
}
