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
    
    // Internal outputs
    @Published private var _messageModels: [MessageModel] = []
    
}

extension UserStoryInputViewModel {
    enum Input {
        case viewDidLoad
    }
    
    func send(input: Input) {
        switch input {
        case .viewDidLoad:
            return
        }
    }
}
