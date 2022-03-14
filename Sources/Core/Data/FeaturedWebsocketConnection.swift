//
//  File.swift
//
//
//  Created by Mohammad on 03/03/2022.
//

import Foundation


/// Represents a single connection with MLS websocket service for features such as Concurrency
class FeaturedWebsocketConnection {
    struct Room: Hashable {
        let id: String
        let type: RoomType
    }
    
    enum RoomType {
        case event
    }
    
    enum UpdateMessage {
        case concurrencyLimitExceeded(eventId: String, limit: Int)
    }
    
    private let eventId: String
    private let sessionId: String
    private var identityToken: String?
    
    private lazy var socket = WebSocket(request: URLRequest(url: Constants.url(with: eventId)))
    
    init(eventId: String,
         sessionId: String,
         identityToken: String?) {
        self.eventId = eventId
        self.sessionId = sessionId
        self.identityToken = identityToken
        self.socket.onEvent = { [weak self] (event: WebSocketEvent) in
            guard let self = self else { return }
            switch event {
            case .connected(_):
                self.isConnected = true
                self.joinRooms()
            case .text(let text):
                let components = text.components(separatedBy: Constants.messageSeparator)
                guard components.count >= 2 else { return }
                let updateType = components[0]
                switch updateType {
                case "concurrencyLimitExceeded":
                    guard components.count >= 3 else { return }
                    let targetEventId = components[1]
                    let limitNumber = components[2]
                    if let roomObservers = self.observers[Room(id: targetEventId, type: .event)] {
                        let update: UpdateMessage = .concurrencyLimitExceeded(eventId: targetEventId, limit: Int(limitNumber) ?? 0)
                        for obs in roomObservers {
                            obs(update)
                        }
                    }
                default: return
                }
                
            case .disconnected:
                self.isConnected = false
                self.socket.connect()
            case .reconnectSuggested:
                self.socket.connect()
            default: break
            }
        }
    }
    
    private var isConnected = false
    
    /// A dictionary that maps room identifiers (event/stream/timeline ids) to arrays of callbacks when an update on that room happens.
    private var observers: [Room: [(UpdateMessage) -> Void]] = [:]
    
    /// A dictionary that maps room identifiers to the last known action id by ovservers.
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
    /// This way preventing to get concurrency exceed if the user identityToken changes due to login to another account
    func unsubscribe(room: Room) {
        observers[room] = nil
        if observers.count == 0 {
            self.socket.disconnect()
        } else {
            switch room.type {
            case .event:
                // Not needed for now.
                //                self.socket.write(string: Constants.leaveEventMessage(with: room.id))
                break
            }
        }
    }
    
    private func joinRooms() {
        if isConnected {
            self.socket.write(string: Constants.welcome(with: sessionId))
            if let identityToken = identityToken, !identityToken.isEmpty {
                self.socket.write(string: Constants.identityTokenMessage(with: identityToken))
            }
            for room in observers.keys {
                switch room.type {
                case .event:
                    // Not needed for now.
                    //                    self.socket.write(string: Constants.joinEventMessage(with: room.id))
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
private extension FeaturedWebsocketConnection {
    enum Constants {
        static func welcome(with sessionId: String) -> String { "sessionId;" + sessionId }
        static func identityTokenMessage(with identityToken: String) -> String { "identityToken;" + identityToken }
        static func joinEventMessage(with eventId: String) -> String { "joinEvent;" + eventId }
        static func leaveEventMessage(with eventId: String) -> String { "leaveEvent;" + eventId }

        static func url(with eventId: String) -> URL {
            return URL(string: "wss://bff-rt.mycujoo.tv/events/" + eventId)!
        }
        static let messageSeparator = ";"
    }
}