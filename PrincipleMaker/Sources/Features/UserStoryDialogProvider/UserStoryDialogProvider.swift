//
//  UserStoryDialogProvider.swift
//  PrincipleMaker
//
//  Created by choijunios on 10/8/25.
//

import Foundation

protocol UserStoryDialogProvider: Sendable {
    // 답장(reply)을 기반으로 새로운 대화를 생성합니다, 답장이 없는 경우 시작말을 반환합니다.
    func requestDialog(reply: String?) async throws -> String
}

final class DefaultUserStoryDialogProvider: UserStoryDialogProvider {
    private let basePrompter: BasePrompter = BasePrompter()
    
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
    
    func requestDialog(reply: String?) async throws -> String {
        let prompt: String
        if let reply {
            prompt = "Create replay for user reply: \(reply)"
        } else {
            prompt = "Create first setence for new user story."
        }
        let response: MessageReply = try await basePrompter.request(withPrompt: prompt)
        return response.contents
    }
}
