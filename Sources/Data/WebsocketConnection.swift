//
// Copyright © 2020 mycujoo. All rights reserved.
//

import Starscream

/// Represents a single connection with the MLS web socket service.
class WebSocketConnection {
    struct Room: Hashable {
        let id: String
        let type: RoomType
    }
    enum RoomType {
        case event, stream, timeline
    }
    enum UpdateMessage {
        case eventTotal(total: Int)
        /// The updateId is a cache-busting key to be used to bypass potentially outdated cached responses on the CDN.
        case eventUpdate(updateId: String)
        /// The updateId is a cache-busting key to be used to bypass potentially outdated cached responses on the CDN.
        case timelineUpdate(updateId: String)
    }

    private let sessionId: String
    private let socket = WebSocket(request: URLRequest(url: Constants.url))

    init(sessionId: String) {
        self.sessionId = sessionId

        self.socket.onEvent = { [weak self] event in
            guard let self = self else { return }
            switch event {
            case .connected(_):
                self.isConnected = true
                self.joinRooms()
            case .text(let text):
                print("Websocket update:", text)
                let components = text.components(separatedBy: Constants.messageSeparator)
                guard components.count >= 2 else { return }

                let updateType = components[0]
                switch updateType {
                case "eventTotal":
                    let targetEventId = components[1]
                    if let total = Int(components[2]), let roomObservers = self.observers[Room(id: targetEventId, type: .event)] {
                        let update: UpdateMessage = .eventTotal(total: total)
                        for obs in roomObservers {
                            obs(update)
                        }
                    }
                case "eventUpdate":
                    let targetEventId = components[1]
                    if let roomObservers = self.observers[Room(id: targetEventId, type: .event)] {
                        let update: UpdateMessage = .eventUpdate(updateId: components[2])
                        for obs in roomObservers {
                            obs(update)
                        }
                    }
                case "timelineUpdate":
                    let targetTimelineId = components[1]
                    if let roomObservers = self.observers[Room(id: targetTimelineId, type: .timeline)] {
                        let update: UpdateMessage = .timelineUpdate(updateId: components[2])
                        for obs in roomObservers {
                            obs(update)
                        }
                    }
                default:
                    return
                }
            case .disconnected:
                self.isConnected = false
                self.socket.connect()
            case .reconnectSuggested:
                self.socket.connect()
            default:
                break
            }
        }
    }

    private var isConnected = false

    /// A dictionary that maps room identifiers (event/stream/timeline ids) to arrays of callbacks when an update on that room happens.
    private var observers: [Room: [(UpdateMessage) -> Void]] = [:]

    /// A dictionary that maps room identifiers to the last known action id by the observers.
    private var lastUpdateId: [Room: String] = [:]

    func subscribe(room: Room, updateCallback: @escaping (UpdateMessage) -> Void) {
        observers[room] = (observers[room] ?? []) + [updateCallback]

        if isConnected {
            joinRooms()
        } else {
            self.socket.connect()
        }
    }

    /// - important: For the moment, unsubscribing will remove ALL observers on this room (not just the specific caller)!
    func unsubscribe(room: Room) {
        observers[room] = nil
        if observers.count == 0 {
            self.socket.disconnect()
        } else {
            switch room.type {
            case .event:
                self.socket.write(string: Constants.leaveEventMessage(with: room.id))
            case .timeline:
                self.socket.write(string: Constants.leaveTimelineMessage(with: room.id))
            case .stream:
                break
            }
        }
    }

    func lastKnownUpdateId(for room: Room, is updateId: String?) {
        lastUpdateId[room] = updateId
    }

    private func joinRooms() {
        if isConnected {
            self.socket.write(string: Constants.welcome(with: sessionId))

            for room in observers.keys {
                switch room.type {
                case .event:
                    self.socket.write(string: Constants.joinEventMessage(with: room.id))
                case .timeline:
                    self.socket.write(string: Constants.joinTimelineMessage(with: room.id, updateId: lastUpdateId[room]))
                case .stream:
                    break
                }
            }
        }
    }

    deinit {
        self.socket.onEvent = nil
        self.socket.disconnect()
    }
}

private extension WebSocketConnection {
    enum Constants {
        static func welcome(with sessionId: String) -> String { "sessionId;" + sessionId }

        static func joinEventMessage(with eventId: String) -> String { "joinEvent;" + eventId }
        static func leaveEventMessage(with eventId: String) -> String { "leaveEvent;" + eventId }

        static func joinTimelineMessage(with timelineId: String, updateId: String?) -> String {
            if let updateId = updateId {
                return "joinTimeline;" + timelineId + ";" + updateId
            }
            return "joinTimeline;" + timelineId
        }
        static func leaveTimelineMessage(with timelineId: String) -> String { "leaveTimeline;" + timelineId }

        static let url = URL(string: "wss://mls-rt.mycujoo.tv")!
        static let messageSeparator = ";"
    }
}
