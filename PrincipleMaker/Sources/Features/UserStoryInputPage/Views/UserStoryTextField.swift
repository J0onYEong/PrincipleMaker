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
    private let visualEffectView = UIVisualEffectView(effect: UIGlassEffect(style: .regular))
    private let containerStackView: UIStackView = UIStackView()
    private let textView: PlaceholderTextView = PlaceholderTextView()
    private let submitButton: UIButton = UIButton()
    
    var cancellables: Set<AnyCancellable> = []
    
    init() {
        super.init(frame: .zero)
        attribute()
        layout()
        
        submitButton.tapPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.resignFirstResponder()
            }
            .store(in: &cancellables)
    }
    required init?(coder: NSCoder) { nil }
    
    override func resignFirstResponder() -> Bool {
        textView.resignFirstResponder()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        visualEffectView.layer.cornerRadius = visualEffectView.bounds.height / 2
    }
    
    private func attribute() {
        addSubview(visualEffectView)
        
        containerStackView.axis = .horizontal
        containerStackView.spacing = 10
        containerStackView.distribution = .fill
        visualEffectView.contentView.addSubview(containerStackView)
        
        textView.placeholder = "이야기를 알려주세요!"
        containerStackView.addArrangedSubview(textView)
        
        submitButton.configuration = .glass()
        submitButton.configuration?.image = UIImage(systemName: "arrow.up.message.fill")
        containerStackView.addArrangedSubview(submitButton)
    }
    
    private func layout() {
        visualEffectView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        containerStackView.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(visualEffectView.contentView).inset(20)
            make.verticalEdges.equalTo(visualEffectView.contentView).inset(10)
        }
        
        submitButton.snp.makeConstraints { make in
            make.width.equalTo(50)
            make.height.equalTo(30)
        }
    }
}

#Preview(traits: .defaultLayout) {
    UserStoryTextField()
}
