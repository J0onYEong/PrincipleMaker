//
//  EventItem.swift
//  PrincipleMaker
//
//  Created by choijunios on 10/20/25.
//

import Foundation

struct EventItem: Hashable, Sendable {
    let id: UUID
    let description: String
    
    init(id: UUID = UUID(), description: String) {
        self.id = id
        self.description = description
    }
}

extension EventItem {
    init(from event: PMEvent) {
        self.init(description: event.description)
    }
}
