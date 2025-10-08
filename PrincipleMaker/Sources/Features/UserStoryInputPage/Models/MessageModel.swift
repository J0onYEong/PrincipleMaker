//
//  MessageModel.swift
//  PrincipleMaker
//
//  Created by choijunios on 10/8/25.
//

enum MessageDirection {
    case left, right
}

enum MessageMode {
    case message(String)
    case typing
}

struct MessageModel {
    let direction: MessageDirection
    let mode: MessageMode
}
