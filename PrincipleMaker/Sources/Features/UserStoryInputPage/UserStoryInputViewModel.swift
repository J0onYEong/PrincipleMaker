//
//  UserStoryInputViewModel.swift
//  PrincipleMaker
//
//  Created by choijunios on 10/5/25.
//

import Combine
import Foundation

@MainActor
final class UserStoryInputViewModel: Sendable {
    // Dependency
    @Injected private var userStoryDialogProvider: UserStoryDialogProvider
    
    // Outputs
    var messageCellModels: AnyPublisher<[MessageCellModel], Never> {
        $_messageCellModels.eraseToAnyPublisher()
    }
    
    // Internal states
    @Published private var _messageCellModels: [MessageCellModel] = []
    @Published private var _userStoryText: String = ""
    private var messageBufferForNextConversation: [String] = []
    
    // Internal publishers
    private let messageSubmitPublisher = PassthroughSubject<Void, Never>()
    private var store: Set<AnyCancellable> = []
    
    init() {}
}

extension UserStoryInputViewModel {
    enum Input {
        case viewDidLoad
        case userStoryTextChanged(text: String)
        case userStoryTextSubmitButtonTapped
    }
    
    func send(input: Input) {
        switch input {
        case .viewDidLoad:
            bindUserInteractionPublishers()
            excuteNextDialogProcress()
            
        case let .userStoryTextChanged(text):
            self._userStoryText = text
            
        case .userStoryTextSubmitButtonTapped:
            guard _userStoryText.isEmpty == false else { return }
            
            // 메세지 셀 추가
            let userStoryText = _userStoryText
            let messageModel = MessageCellModel(direction: .right, mode: .message(userStoryText))
            self._messageCellModels.append(messageModel)
            
            // 다음 대화 생성을 위한 메세지 저장
            self.messageBufferForNextConversation.append(userStoryText)
            messageSubmitPublisher.send(())
        }
    }
}

extension UserStoryInputViewModel {
    private func bindUserInteractionPublishers() {
        messageSubmitPublisher
            .debounce(for: .seconds(3), scheduler: RunLoop.main)
            .receive(on: DispatchQueue.main)
            .unretained(self)
            .sink { vm in
                let accumulatedMessage = vm.messageBufferForNextConversation.joined(separator: "\n")
                vm.excuteNextDialogProcress(reply: accumulatedMessage)
                vm.messageBufferForNextConversation.removeAll()
            }
            .store(in: &store)
    }
    
    private func excuteNextDialogProcress(reply: String? = nil) {
        let loadingModel = MessageCellModel(
            direction: .left,
            mode: .typing
        )
        self._messageCellModels.append(loadingModel)
        
        Task(priority: .userInitiated) { [weak self] in
            guard let self else { return }
            let nextMessage: String
            do {
                let message = try await userStoryDialogProvider.requestDialog(reply: reply)
                nextMessage = message
            } catch {
                nextMessage = "오류가 발생했습니다.\n\(error.localizedDescription)"
            }
            await MainActor.run { [weak self] in
                guard
                    let self,
                    let loadingMessageIndex = _messageCellModels.firstIndex(where: { $0.id == loadingModel.id })
                else { return }
                var currentModels = _messageCellModels
                currentModels[loadingMessageIndex].mode = .message(nextMessage)
                self._messageCellModels = currentModels
            }
        }
    }
}
