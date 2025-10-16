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
    private enum DialogConfig {
        static let dialogCompleteWord: String = "완료"
        static let minimumMessageCountForCompleteDialog: Int = 3
    }
    
    // Dependency
    @Injected private var userStoryDialogProvider: UserStoryDialogProvider
    
    // Outputs
    var messageCellModels: AnyPublisher<[MessageCellModel], Never> {
        $_messageCellModels.eraseToAnyPublisher()
    }
    var keyBoardPlaceHolderText: AnyPublisher<String, Never> {
        $_keyboardPlaceHolderText.eraseToAnyPublisher()
    }
    var alertToPresent: AnyPublisher<AlertModel, Never> {
        alertSubject.eraseToAnyPublisher()
    }
    
    // Internal states
    private var userMessages: [String] = []
    private var messageBufferForReply: [String] = []
    private var readyToCompleteDialog: Bool = false
    
    // Internal publishers
    @Published private var _messageCellModels: [MessageCellModel] = []
    @Published private var _userStoryText: String = ""
    @Published private var _keyboardPlaceHolderText: String = ""
    private let messageSubmitPublisher = PassthroughSubject<Void, Never>()
    private let alertSubject = PassthroughSubject<AlertModel, Never>()
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
            fetchNextReply(for: nil)
            _keyboardPlaceHolderText = "오늘은 어떤 일이 있었나요?"
            
        case let .userStoryTextChanged(text):
            self._userStoryText = text
            
        case .userStoryTextSubmitButtonTapped:
            guard _userStoryText.isEmpty == false else { return }
            
            let userStoryText = _userStoryText
            
            // 대화종료 여부 확인하기
            if readyToCompleteDialog, userStoryText == DialogConfig.dialogCompleteWord {
                presentCompletionAlert()
                _userStoryText = ""
                return
            }
            
            // 모든 유저 메세지 저장
            userMessages.append(userStoryText)
            
            // 메세지 셀 추가
            let messageModel = MessageCellModel(direction: .right, mode: .message(userStoryText))
            _messageCellModels.append(messageModel)
            
            // 다음 대화 생성을 위한 메세지 저장
            messageBufferForReply.append(userStoryText)
            messageSubmitPublisher.send(())
            
            // 키보드 플레이홀더 변경
            let userMessagesCount = _messageCellModels.count(where: { $0.direction == .right })
                if userMessagesCount >= DialogConfig.minimumMessageCountForCompleteDialog {
                // 유저가 입력한 대답이 3가지 이상인 경우
                _keyboardPlaceHolderText = "\"완료\"를 입력해 대화를 종료하세요!"
                readyToCompleteDialog = true
            }
            _userStoryText = ""
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
                let messages = vm.messageBufferForReply.joined(separator: "\n")
                vm.messageBufferForReply.removeAll()
                vm.fetchNextReply(for: messages)
            }
            .store(in: &store)
    }
    
    private func fetchNextReply(for message: String? = nil) {
        let loadingModel = MessageCellModel(
            direction: .left,
            mode: .typing
        )
        self._messageCellModels.append(loadingModel)
        
        Task(priority: .userInitiated) { [weak self] in
            guard let self else { return }
            let nextMessage: String
            do {
                let message = try await userStoryDialogProvider.requestReply(for: message)
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

extension UserStoryInputViewModel {
    private func presentCompletionAlert() {
        let alertModel = AlertModel(
            title: "대화를 종료할까요?",
            message: "작성한 내용을 바탕으로 오늘의 기록을 마무리합니다.",
            actions: [
                .init(title: "취소", style: .cancel),
                .init(title: "완료", style: .default) { [weak self] in
                    guard let self else { return }
                    print("완료")
                },
            ]
        )
        alertSubject.send(alertModel)
    }
}
