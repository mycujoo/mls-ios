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
    private var canReconnect: Bool = true
    private lazy var socket = WebSocket(request: URLRequest(url: Constants.url(with: eventId)))
    
    init(eventId: String,
         sessionId: String,
         identityToken: String?,
         printToConsole: Bool) {
        self.eventId = eventId
        self.sessionId = sessionId
        self.identityToken = identityToken
        self.socket.onEvent = { [weak self] (event: WebSocketEvent) in
            guard let self = self else { return }
            switch event {
            case .connected(_):
                self.isConnected = true
                self.joinRooms()
                self.retryAttempt = .zero
            case .text(let text):
                if printToConsole {
                    print("### Websocket message received. Raw:", text)
                }
                let components = text.components(separatedBy: Constants.messageSeparator)
                guard components.count >= 2 else { return }
                let updateType = components[0]
                switch updateType {
                case "concurrencyLimitExceeded":
                    self.canReconnect = false
                    guard components.count >= 2 else { return }
                    let limitNumber = components[1]
                    if let roomObservers = self.observers[Room(id: eventId, type: .event)] {
                        let update: UpdateMessage = .concurrencyLimitExceeded(eventId: eventId, limit: Int(limitNumber) ?? 3)
                        for obs in roomObservers {
                            obs(update)
                        }
                    }
                    self.unsubscribe(room: Room(id: eventId, type: .event))
                    
                    /// The only error that can be retried (with a backoff strategy)  is `internal`.
                case "err":
                    guard components.count > 2 else { return }
                    switch components[1] {
                        
                    case "badRequest":
                        /// `badRequest` error means that something in the `SDK` is not right and should file a bug for it.
                        self.canReconnect = false
                        self.socket.disconnect()
                        if printToConsole {
                            debugPrint("### Websocket `badRequest` error: \(text)")
                        }
                        
                    case "forbidden":
                        self.canReconnect = false
                        self.socket.disconnect()
                        if printToConsole {
                            debugPrint("### Websocket `forbidden` error: \(text)")
                        }
                        
                    case "precondition":
                        self.socket.disconnect()
                        if printToConsole {
                            debugPrint("### Websocket `precondition` error: \(text)")
                        }
                        
                    case "internal":
                        self.canReconnect = true
                        self.retry(delay: .exponential(initial: 5, multiplier: 2), retry: 5, closure: { self.socket.disconnect() })
                        
                    default:
                        return
                    }
                default: return
                }
                
            case .disconnected:
                guard self.canReconnect else { return }
                self.isConnected = false
                self.socket.connect()
            case .reconnectSuggested:
                self.socket.connect()
            default: break
            }
        }
    }
    
    private var retryAttempt: Int = .zero
    
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

    func retry(delay: DelayOptions, retry: Int, closure: @escaping () -> Void) {
        if retryAttempt < retry {
            DispatchQueue.main.asyncAfter(
                deadline: DispatchTime.now() + .seconds(delay.make(retryAttempt)),
                execute: {
                    DispatchQueue.main.async(execute: closure)
                    self.retryAttempt += 1
                    self.retry(delay: delay, retry: retry, closure: closure)
                })
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

enum DelayOptions {
    case immediate
    case constant(time: Int)
    case exponential(initial: Int, multiplier: Double, maxDelay: Int = 5000)
    case custom(closure: (Int) -> Int)
}

extension DelayOptions {
    func make(_ attempt: Int) -> Int {
        switch self {
        case .immediate: return 0
        case .constant(let time): return time
        case .exponential(let initial, let multiplier, let maxDelay):
            // if it's first attempt, simply use initial delay, otherwise calculate delay
            let delay = attempt == 1 ? initial : initial * Int(pow(multiplier, Double(attempt - 1)))
            return min(maxDelay, delay)
        case .custom(let closure): return closure(attempt)
        }
    }
}
