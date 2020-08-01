//
// Copyright © 2020 mycujoo. All rights reserved.
//

import Starscream

/// Represents a single connection with the MLS web socket service.
class WebSocketConnection {
    enum UpdateMessage {
        case eventStatus(total: Int)
        /// The updateId is a cache-busting key to be used to bypass potentially outdated cached responses on the CDN.
        case eventUpdate(updateId: String)
    }

    private let socket = WebSocket(request: URLRequest(url: Constants.url))

    private var eventIds: [String] = []

    func subscribe(eventId: String, sessionId: String, updateCallback: @escaping (UpdateMessage) -> Void) {
        guard !eventIds.contains(eventId) else { return }
        self.eventIds.append(eventId)

        // Call connect even if subscribe() was already called for a different event.
        self.socket.connect()

        self.socket.onEvent = { [weak self] event in
            switch event {
            case .connected(_):
                self?.socket.write(string: Constants.joinEventMessage(with: eventId))
            case .text(let text):
                print("Websocket update:", text)
                let components = text.components(separatedBy: Constants.messageSeparator)
                guard components.count >= 2 else { return }

                let update: UpdateMessage

                let updateType = components[0]
                switch updateType {
                case "eventStatus":
                    let targetEventId = components[1]
                    guard eventId == targetEventId, let total = Int(components[2]) else { return }

                    update = .eventStatus(total: total)
                case "eventUpdate":
                    let targetEventId = components[1]
                    guard eventId == targetEventId else { return }

                    update = .eventUpdate(updateId: components[2])
                default:
                    return
                }
                updateCallback(update)
            case .disconnected, .reconnectSuggested:
                self?.socket.connect()
            default:
                break
            }
        }
    }

    func unsubscribe(eventId: String) {
        guard eventIds.contains(eventId) else { return }

        if eventIds.count == 1 {
            self.socket.onEvent = nil
            self.socket.disconnect()
        } else {
            self.socket.write(string: Constants.leaveEventMessage(with: eventId))
        }

        self.eventIds = self.eventIds.filter { $0 != eventId }
    }

    deinit {
        self.socket.onEvent = nil
        self.socket.disconnect()
    }
}

private extension WebSocketConnection {
    enum Constants {
        static func joinEventMessage(with eventId: String) -> String { "joinEvent;" + eventId }
        static func leaveEventMessage(with eventId: String) -> String { "leaveEvent;" + eventId }
        static let url = URL(string: "wss://mls-rt.mycujoo.tv")!
        static let messageSeparator = ";"
    }
}
