//
//  UserStoryInputViewController.swift
//  PrincipleMaker
//
//  Created by choijunios on 10/5/25.
//

import Combine
import SnapKit
import UIKit
import SwiftUI

@MainActor
final class UserStoryInputViewController: BaseViewController {
    private typealias MessageDataSource = UITableViewDiffableDataSource<Int, MessageModel>
    private typealias MessageSnapshot = NSDiffableDataSourceSnapshot<Int, MessageModel>
    
    private var viewModel: UserStoryInputViewModel!
    private var store: Set<AnyCancellable> = []
    
    private let contentView: UIView = UIView()
    private let messageTableView: UITableView = UITableView()
    private let userStoryTextField: UserStoryTextField = UserStoryTextField()
    private lazy var messageDataSource: MessageDataSource = makeMessageDataSource()
    private lazy var dismissKeyboardTapRecognizer: UITapGestureRecognizer = {
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(onBackgroundTapped))
        recognizer.cancelsTouchesInView = false
        recognizer.delegate = self
        return recognizer
    }()
    
    @MainActor
    deinit {
        removeKeyboardObserver()
    }
    
    override func initialize() {
        setupKeyboardNotification()
    }
    
    func bind(viewModel: UserStoryInputViewModel) {
        self.viewModel = viewModel
        
        // Outputs
        viewModel
            .messageModels
            .unretained(self)
            .sink { vc, models in
                vc.applyMessageSnapshot(with: models, animatingDifferences: true)
                vc.adjustScrollOffsetWhenCellDataChanged()
            }
            .store(in: &store)
        
        // Inputs
        lifeCyclePublisher
            .unretained(viewModel)
            .sink { vm, lifeCycleEvent in
                switch lifeCycleEvent {
                case .viewDidLoad:
                    vm.send(input: .viewDidLoad)
                default:
                    break
                }
            }
            .store(in: &store)
        
        userStoryTextField
            .viewActionPublisher
            .unretained(viewModel)
            .sink { vm, viewAction in
                switch viewAction {
                case .submitButtonTapped:
                    vm.send(input: .userStoryTextSubmitButtonTapped)
                case let .textInputChanged(text):
                    vm.send(input: .userStoryTextChanged(text: text))
                }
            }
            .store(in: &store)
    }
    
    override func attribute() {
        self.navigationItem.title = "오늘의 기록"
        self.view.backgroundColor = .systemBackground
        
        view.addSubview(contentView)
        view.addGestureRecognizer(dismissKeyboardTapRecognizer)
        
        messageTableView.backgroundColor = .clear
        messageTableView.register(cellType: MessageCell.self)
        messageTableView.rowHeight = UITableView.automaticDimension
        messageTableView.estimatedRowHeight = 56
        messageTableView.separatorStyle = .none
        messageTableView.allowsSelection = false
        messageTableView.dataSource = messageDataSource
        contentView.addSubview(messageTableView)
        
        contentView.addSubview(userStoryTextField)
    }
    
    override func layout() {
        contentView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
        messageTableView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.horizontalEdges.equalToSuperview().inset(10)
            make.bottom.equalTo(userStoryTextField.snp.top).offset(-5)
        }
        
        userStoryTextField.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(10)
            make.bottom.equalToSuperview().inset(10)
        }
    }
    
    private func setupKeyboardNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(onKeyboardShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(onKeyboardDismiss(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func removeKeyboardObserver() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc
    func onKeyboardDismiss(_ notification: Notification) {
        guard
            let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval
        else { return }
        UIView.animate(withDuration: duration) { [weak self] in
            guard let self else { return }
            contentView.snp.updateConstraints { make in
                make.bottom.equalTo(view.safeAreaLayoutGuide)
            }
            view.layoutIfNeeded()
        }
    }
    
    @objc
    func onKeyboardShow(_ notification: Notification) {
        guard
            let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval,
            let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect
        else { return }
        let inset = keyboardFrame.height - view.safeAreaInsets.bottom
        UIView.animate(withDuration: duration) { [weak self] in
            guard let self else { return }
            contentView.snp.updateConstraints { make in
                make.bottom.equalTo(view.safeAreaLayoutGuide).inset(inset)
            }
            view.layoutIfNeeded()
        }
    }
    
    private func makeMessageDataSource() -> MessageDataSource {
        MessageDataSource(tableView: messageTableView) { tableView, indexPath, item in
            let cell: MessageCell = tableView.dequeueReusableCell(for: indexPath)
            cell.configure(using: item)
            return cell
        }
    }
    
    private func applyMessageSnapshot(with messages: [MessageModel], animatingDifferences: Bool = true) {
        var snapshot = MessageSnapshot()
        snapshot.appendSections([0])
        snapshot.appendItems(messages, toSection: 0)
        messageDataSource.apply(snapshot, animatingDifferences: animatingDifferences)
    }
    
    private func adjustScrollOffsetWhenCellDataChanged() {
        messageTableView.layoutIfNeeded()
        let contentHeight = messageTableView.contentSize.height
        let tableViewHeight = messageTableView.bounds.height
        if contentHeight > tableViewHeight {
            let scrollYOffset = contentHeight - tableViewHeight
            messageTableView.setContentOffset(
                CGPoint(x: 0, y: scrollYOffset),
                animated: true
            )
        }
    }
    
    @objc
    private func onBackgroundTapped() {
        userStoryTextField.resignFirstResponder()
    }
}

extension UserStoryInputViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        guard gestureRecognizer === dismissKeyboardTapRecognizer else { return true }
        let location = touch.location(in: view)
        let textFieldFrameInView = userStoryTextField.convert(userStoryTextField.bounds, to: view)
        return textFieldFrameInView.contains(location) == false
    }
}

#Preview(traits: .defaultLayout) {
    UserStoryInputViewController()
}
