//
//  UserStoryInputViewModel.swift
//  PrincipleMaker
//
//  Created by choijunios on 10/5/25.
//

import Combine

@MainActor
final class UserStoryInputViewModel {
    // Outputs
    var messageModels: AnyPublisher<[MessageModel], Never> {
        $_messageModels.eraseToAnyPublisher()
    }
    
    // Internal states
    @Published private var _messageModels: [MessageModel] = []
    @Published private var _userStoryText: String = ""
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
            let initialMessageModel = MessageModel(
                direction: .left,
                mode: .message("오늘 너의 하루를 알려줘!")
            )
            self._messageModels = [initialMessageModel]
            
        case let .userStoryTextChanged(text):
            self._userStoryText = text
            
        case .userStoryTextSubmitButtonTapped:
            guard _userStoryText.isEmpty == false else { return }
            let messageModel = MessageModel(
                direction: .right,
                mode: .message(_userStoryText)
            )
            var currentMessages = _messageModels
            currentMessages.append(messageModel)
            self._messageModels = currentMessages
        }
    }
}
