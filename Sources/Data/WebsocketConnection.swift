//
// Copyright © 2020 mycujoo. All rights reserved.
//

import Starscream

/// Represents a single connection with the MLS web socket service.
/// Currently, each connection is designed to represent one event (but this may be changed in the future).
class WebSocketConnection {
    private let socket = WebSocket(request: URLRequest(url: Constants.url))

    let eventId: String

    init(eventId: String, updateCallback: @escaping ([String]) -> Void) {
        self.eventId = eventId

        self.socket.onEvent = { [weak self] event in
            switch event {
            case .connected(_):
                self?.socket.write(string: Constants.joinRoomMessage(with: eventId))
            case .text(let text):
                updateCallback(text.components(separatedBy: Constants.messageSeparator))
            case .disconnected, .reconnectSuggested:
                self?.socket.connect()
            default:
                break
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
        static func joinRoomMessage(with eventId: String) -> String { "joinRoom;" + eventId }
        static let url = URL(string: "wss://mls-rt.mycujoo.tv")!
        static let messageSeparator = ";"
    }
}
