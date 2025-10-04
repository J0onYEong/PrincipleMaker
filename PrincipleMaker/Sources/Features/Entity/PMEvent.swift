//
//  PMEvent.swift
//  PrincipleMaker
//
//  Created by choijunios on 10/4/25.
//

import FoundationModels

@Generable(description: "Extracted event from content")
struct PMEvent {
    @Guide(description: "Descriptuon of the event")
    let description: String
}
