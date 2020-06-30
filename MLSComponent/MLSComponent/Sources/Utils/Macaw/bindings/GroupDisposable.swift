//
//  GroupDisposable.swift
//  Pods
//
//  Created by Yuri Strot on 9/5/16.
//
//

class GroupDisposable {

    fileprivate var items: [Disposable] = []

     func dispose() {
        for disposable in items {
            disposable.dispose()
        }
        items = []
    }

    func add(_ item: Disposable) {
        items.append(item)
    }

}

extension Disposable {
    func addTo(_ group: GroupDisposable) {
        group.add(self)
    }
}
