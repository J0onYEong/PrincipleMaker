//
//  UserStoryInputViewController.swift
//  PrincipleMaker
//
//  Created by choijunios on 10/5/25.
//

import SnapKit
import UIKit
import SwiftUI

final class UserStoryInputViewController: UIViewController {
    private let contentView: UIView = UIView()
    private let messageTableView: UITableView = UITableView()
    private let userStoryTextField: UserStoryTextField = UserStoryTextField()
    
    init() {
        super.init(nibName: nil, bundle: nil)
        setupKeyboardNotification()
    }
    required init?(coder: NSCoder) { nil }
    
    @MainActor
    deinit {
        removeKeyboardObserver()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        attribute()
        layout()
    }
    
    private func attribute() {
        view.addSubview(contentView)
        
        contentView.addSubview(messageTableView)
        
        contentView.addSubview(userStoryTextField)
    }
    
    private func layout() {
        contentView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
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
}

#Preview(traits: .defaultLayout) {
    UserStoryInputViewController()
}
