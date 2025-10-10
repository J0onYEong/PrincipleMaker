//
//  BasePrompter.swift
//  PrincipleMaker
//
//  Created by choijunios on 10/8/25.
//

import FoundationModels

class BasePrompter: @unchecked Sendable {
    private var session: LanguageModelSession?
    
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
    
    func initialize(instructions: String?) {
        let modelSession = LanguageModelSession(
            model: .default,
            tools: [],
            instructions: instructions
        )
        self.session = modelSession
    }
    
    func request<Response: Generable>(withPrompt prompt: String) async throws -> Response {
        guard let session else {
            preconditionFailure("Session is not initialized.")
        }
        return try await session.respond(to: prompt, generating: Response.self).content
    }
}
