//
//  EventExtractor.swift
//  PrincipleMaker
//
//  Created by choijunios on 10/4/25.
//

import FoundationModels

final class EventExtractor: @unchecked Sendable {
    
    private var session: LanguageModelSession?
    
    init() {}
    
    func isModelAvailable() -> Bool {
        let defaultModel = SystemLanguageModel.default
        switch defaultModel.availability {
        case .available:
            print("Show your intelligence UI.")
        case .unavailable(.deviceNotEligible):
            print("Show an alternative UI.")
        case .unavailable(.appleIntelligenceNotEnabled):
            print("Ask the person to turn on Apple Intelligence.")
        case .unavailable(.modelNotReady):
            print("The model isn't ready because it's downloading or because of other system reasons.")
        case .unavailable(let other):
            print("The model is unavailable for an unknown reason. \(other)")
        }
        return defaultModel.isAvailable
    }
    
    func initializeModel() {
        let sessionInstructions = """
            Extract events from the given paragraph.\
            An event refers to a specific occurrence that can be expressed as a sentence of 30 characters or fewer.\
            Each event must include a clear actor (subject) and an action (verb).\
            Extract only events that have a temporal flow; exclude mere states, descriptions, or emotions.\
            The order of events must follow their appearance in the paragraph.\
            Output the events as a list.\
            Do not include unnecessary explanations, interpretations, or contextual summaries.
            If no events are found, output an empty list.\
            including your final requirement that each event must end with “다.” — ensuring grammatically complete Korean sentences.
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
