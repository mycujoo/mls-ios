//
// Copyright © 2020 mycujoo. All rights reserved.
//

import Foundation

// MARK: TOVStore

/// TOV (Timer Or Variable). This store contains a state of variables and timers (TOVs) defined within.
/// A single instance of a TOVStore should be tied to a single timeline.
class TOVStore {
    private var tovs: [String: TOV] = [:]

    private var observers: [String: [(callbackId: String, callback: (String) -> Void)]] = [:]

    func get(by name: String) -> TOV? {
        return tovs[name]
    }

    /// Observe Timer or Variable changes.  The observer (target) will be notified of every change to this variable in this store.
    /// `get(by:)` can then be used to obtain the new value.
    /// - parameter tovName: The name of the variable or timer to be observed.
    /// - parameter callbackId: A string that uniquely identifies this callback in the context of this tovName. Can be used to remove observers.
    /// - parameter callback: A closure that is called whenever a change occurs.
    func addObserver(tovName: String, callbackId: String, callback: @escaping (String) -> Void) {
        if let arr_ = observers[tovName] {
            var arr = arr_
            if arr.contains(where: { tuple -> Bool in
                tuple.callbackId == callbackId
            }) {
                arr = arr.filter { $0.callbackId != callbackId }
            }
            observers[tovName] = arr + [(callbackId: callbackId, callback: callback)]
        } else {
            observers[tovName] = [(callbackId: callbackId, callback: callback)]
        }
    }

    /// - parameter tovName: The name of the variable or timer to be observed.
    /// - parameter callbackId: The identifier of the callback that should be removed.
    func removeObserver(tovName: String, callbackId: String) {
        guard let arr = observers[tovName] else { return }

        observers[tovName] = arr.filter { $0.callbackId != callbackId }
    }

    /// Unlike `removeObserver(tovName:callbackId:)`, this method removes all observers with this callbackId from all tovNames.
    func removeObservers(callbackId: String) {
        for (tovName, _) in observers {
            removeObserver(tovName: tovName, callbackId: callbackId)
        }
    }

    /// Should be called whenever a new dictionary of TOVs (and their names as keys) is available.
    /// The store will internally call any observer whenever a difference with a previous state is detected.
    func new(tovs newTovs: [String: TOV]) {
        var oldTovs = self.tovs

        var differentTovNames: [String] = []

        for (name, newTov) in newTovs {
            if let oldTov = oldTovs[name] {
                if oldTov != newTov {
                    differentTovNames.append(name)
                }
                oldTovs[name] = nil
            } else {
                differentTovNames.append(name)
            }
        }

        differentTovNames += oldTovs.map { $0.key }

        self.tovs = newTovs

        callObservers(names: differentTovNames)
    }

    /// Notifies observers of changes to the variables or timers that they are referenced in the `names` parameter.
    private func callObservers(names: [String]) {
        for name in names {
            guard let observers = self.observers[name] else { continue }
            for observer in observers {
                observer.callback(name)
            }
        }
    }
}

extension TOVStore {
    class TOV: Equatable {
        static func == (lhs: TOVStore.TOV, rhs: TOVStore.TOV) -> Bool {
            return lhs.name == rhs.name && lhs.humanFriendlyValue == rhs.humanFriendlyValue
        }

        let name: String
        let humanFriendlyValue: String

        init(name: String, humanFriendlyValue: String) {
            self.name = name
            self.humanFriendlyValue = humanFriendlyValue
        }
    }
}
