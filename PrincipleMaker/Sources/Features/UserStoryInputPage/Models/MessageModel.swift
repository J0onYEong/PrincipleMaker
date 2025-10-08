//
//  MessageModel.swift
//  PrincipleMaker
//
//  Created by choijunios on 10/8/25.
//

import Foundation

enum MessageDirection: Hashable {
    case left, right
}

enum MessageMode: Hashable {
    case message(String)
    case typing
}

struct MessageModel: Identifiable, Hashable {
    let id: String = UUID().uuidString
    let direction: MessageDirection
    var mode: MessageMode
}
