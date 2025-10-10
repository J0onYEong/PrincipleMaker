//
//  MessageReply.swift
//  PrincipleMaker
//
//  Created by choijunios on 10/8/25.
//

import FoundationModels

@Generable
struct MessageReply {
    @Guide(description: "This is reply for user's message")
    let contents: String
}
