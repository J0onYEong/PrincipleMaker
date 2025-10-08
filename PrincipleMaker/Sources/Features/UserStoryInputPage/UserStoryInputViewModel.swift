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
    var messageModels: AnyPublisher<[MessageModel], Never> {
        $_messageModels.eraseToAnyPublisher()
    }
    
    // Internal states
    @Published private var _messageModels: [MessageModel] = []
    @Published private var _userStoryText: String = ""
    private var messageBuffer: [String] = []
    
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
            let userStoryText = _userStoryText
            let messageModel = MessageModel(
                direction: .right,
                mode: .message(userStoryText)
            )
            var currentMessages = _messageModels
            currentMessages.append(messageModel)
            self._messageModels = currentMessages
            self.messageBuffer.append(userStoryText)
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
                let accumulatedMessage = vm.messageBuffer.joined(separator: "\n")
                vm.excuteNextDialogProcress(reply: accumulatedMessage)
                vm.messageBuffer.removeAll()
            }
            .store(in: &store)
    }
    
    private func excuteNextDialogProcress(reply: String? = nil) {
        let loadingModel = MessageModel(
            direction: .left,
            mode: .typing
        )
        self._messageModels.append(loadingModel)
        
        Task(priority: .userInitiated) { [weak self] in
            guard let self else { return }
            let nextMessage = try await userStoryDialogProvider.requestDialog(reply: reply)
            await MainActor.run { [weak self] in
                guard
                    let self,
                    let loadingMessageIndex = _messageModels.firstIndex(where: { $0.id == loadingModel.id })
                else { return }
                var currentModels = _messageModels
                currentModels[loadingMessageIndex].mode = .message(nextMessage)
                self._messageModels = currentModels
            }
        }
    }
}
