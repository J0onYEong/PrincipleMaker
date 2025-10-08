//
//  UserStoryDialogProvider.swift
//  PrincipleMaker
//
//  Created by choijunios on 10/8/25.
//

protocol UserStoryDialogProvider: Sendable {
    // 답장(reply)을 기반으로 새로운 대화를 생성합니다, 답장이 없는 경우 시작말을 반환합니다.
    func requestDialog(reply: String?) async throws -> String
}

final class DefaultUserStoryDialogProvider: UserStoryDialogProvider {
    func requestDialog(reply: String?) async throws -> String {
        try await Task.sleep(for: .seconds(2))
        return "Answer to \(reply, default: "-")"
    }
}
