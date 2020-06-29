//
//  Event.swift
//  Pods
//
//  Created by Yuri Strot on 12/20/16.
//
//

import Foundation

class MacawEvent {

    weak var node: Node?

    var consumed = false

    init(node: Node) {
        self.node = node
    }

    func consume() {
        consumed = true
    }
}
