//
//  EventExtractor.swift
//  PrincipleMaker
//
//  Created by choijunios on 10/4/25.
//

import FoundationModels

final class EventExtractor {
    
    private var session: LanguageModelSession?
    
    init() {}
    
    func isModelAvailable() -> Bool {
        SystemLanguageModel.default.isAvailable
    }
    
    func initializeModel() throws {
        let sessionInstructions = """
            Extract events from the given paragraph.\
            An event refers to a specific occurrence that can be expressed as a sentence of 30 characters or fewer.\
            Each event must include a clear actor (subject) and an action (verb).\
            Extract only events that have a temporal flow; exclude mere states, descriptions, or emotions.\
            The order of events must follow their appearance in the paragraph.\
            Output the events as a list.\
            Do not include unnecessary explanations, interpretations, or contextual summaries.
            If no events are found, output an empty list.
        """
        let modelSession = LanguageModelSession(
            model: .default,
            tools: [],
            instructions: sessionInstructions
        )
        self.session = modelSession
    }
    
    func extractEvent(from: String) async throws -> [PMEvent] {
        guard let session else { throw PMSessionError.sessionIsNotAvailable }
        let prompt = createEventExtractionPrompt(from: from)
        let response = try await session.respond(to: prompt, generating: [PMEvent].self)
        return response.content
    }
}

extension EventExtractor {
    private func createEventExtractionPrompt(from paragraph: String) -> Prompt {
        let content: String = """
        The following paragraph is the target paragraph for event extraction.\
        \(paragraph)
        """
        return Prompt(content)
    }
}
