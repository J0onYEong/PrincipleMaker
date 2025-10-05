//
//  EventExtractor.swift
//  PrincipleMaker
//
//  Created by choijunios on 10/4/25.
//

import Foundation
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
        guard let filePath = Bundle.main.path(forResource: "EventExtractionInst", ofType: "txt")
        else { preconditionFailure("인스트럭션 파일을 찾을 수 없습니다.") }
        let fileURL = URL(fileURLWithPath: filePath)
        let sessionInstructions = try? String(contentsOf: fileURL, encoding: .utf8)
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
