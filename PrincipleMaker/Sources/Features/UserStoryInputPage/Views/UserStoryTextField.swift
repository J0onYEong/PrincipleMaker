//
//  UserStoryTextField.swift
//  PrincipleMaker
//
//  Created by choijunios on 10/5/25.
//

import Combine
import CombineCocoa
import SnapKit
import UIKit
import SwiftUI

final class UserStoryTextField: UIView {
    private enum Config {
        static let minimunTextViewHeight: CGFloat = 30
        static let maximumTextViewHeight: CGFloat = 120
        static let contentVerticalInset: CGFloat = 10
        static let contentHorizontalInset: CGFloat = 20
    }
    
    enum ViewAction {
        case textInputChanged(message: String)
        case submitButtonTapped
    }
    
    let viewActionPublisher: PassthroughSubject<ViewAction, Never> = .init()
    
    private let visualEffectView = UIVisualEffectView(effect: UIGlassEffect(style: .regular))
    private let contentView: UIView = UIView()
    private let textView: PlaceholderTextView = PlaceholderTextView()
    private let submitButton: UIButton = UIButton()
    
    private var store: Set<AnyCancellable> = []
    
    init() {
        super.init(frame: .zero)
        attribute()
        layout()
        bindInputs()
    }
    required init?(coder: NSCoder) { nil }
    
    @discardableResult
    override func resignFirstResponder() -> Bool {
        textView.resignFirstResponder()
    }
    
    private func bindInputs() {
        textView
            .textPublisher
            .unretained(self)
            .sink { view, message in
                view.viewActionPublisher.send(.textInputChanged(message: message ?? ""))
            }
            .store(in: &store)
        
        submitButton
            .tapPublisher
            .unretained(self)
            .sink { view in
                view.viewActionPublisher.send(.submitButtonTapped)
                view.textView.text = ""
            }
            .store(in: &store)
    }
    
    private func attribute() {
        addSubview(visualEffectView)
        
        visualEffectView.contentView.addSubview(contentView)
        visualEffectView.layer.cornerRadius = (Config.minimunTextViewHeight + Config.contentVerticalInset) / 2
        
        textView.placeholder = "이야기를 알려주세요!"
        contentView.addSubview(textView)
        
        submitButton.configuration = .glass()
        submitButton.configuration?.image = UIImage(systemName: "arrow.up.message.fill")
        contentView.addSubview(submitButton)
    }
    
    private func layout() {
        visualEffectView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        contentView.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview().inset(Config.contentVerticalInset)
            make.horizontalEdges.equalToSuperview().inset(Config.contentHorizontalInset)
        }
        
        textView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.equalToSuperview()
            make.bottom.equalToSuperview()
            make.right.equalTo(submitButton.snp.left).offset(-10)
            make.height.greaterThanOrEqualTo(Config.minimunTextViewHeight)
            make.height.lessThanOrEqualTo(Config.maximumTextViewHeight)
        }
        
        submitButton.snp.makeConstraints { make in
            make.width.equalTo(50)
            make.height.equalTo(30)
            make.right.equalToSuperview()
            make.centerY.equalToSuperview()
        }
    }
}

#Preview(traits: .defaultLayout) {
    UserStoryTextField()
}
