//
//  UserStoryDialogProvider.swift
//  PrincipleMaker
//
//  Created by choijunios on 10/8/25.
//

import Foundation
import FoundationModels

protocol UserStoryDialogProvider: Sendable {
    // 메세지를 기반으로 새로운 대화를 생성합니다, 답장이 없는 경우 시작말을 반환합니다.
    func requestReply(for message: String?) async throws -> String
}

final class DefaultUserStoryDialogProvider: UserStoryDialogProvider {
    private let basePrompter: BasePrompter = BasePrompter()
    
    private let messageHistory: MessageHistory = .init()
    
    init() {
        setupPrompter()
    }
    
    private func setupPrompter() {
        guard let filePath = Bundle.main.path(forResource: "UserStoryDialogInst", ofType: "txt")
        else { preconditionFailure("인스트럭션 파일을 찾을 수 없습니다.") }
        let fileURL = URL(fileURLWithPath: filePath)
        let sessionInstructions = try? String(contentsOf: fileURL, encoding: .utf8)
        basePrompter.initialize(instructions: sessionInstructions)
    }
    
    func requestReply(for message: String?) async throws -> String {
        let prompt: String
        if let message {
            prompt = "Create replay for user reply: \(message)"
        } else {
            prompt = "Create first setence for new user story."
        }
        do {
            let response: MessageReply = try await basePrompter.request(withPrompt: prompt)
            if let message { await messageHistory.append(message) }
            return response.contents
        } catch {
            if let err = error as? PMSessionError {
                switch err {
                case .sessionIsNotExist:
                    setupPrompter()
                    return try await requestReply(for: message)
                    
                case .sessionIsResponding:
                    try? await Task.sleep(for: .seconds(1))
                    return try await requestReply(for: message)
                    
                default:
                    throw err
                }
            }
            
            if let err = error as? LanguageModelSession.GenerationError {
                switch err {
                case .exceededContextWindowSize:
                    
                    setupPrompter()
                    let accumulatedMessages = await messageHistory.messages.joined(separator: "\n")
                    await messageHistory.clear()
                    return try await requestReply(for: accumulatedMessages)
                    
                default:
                    throw PMSessionError.underlyingError(err)
                }
            }
            
            throw PMSessionError.underlyingError(error)
        }
    }
}
