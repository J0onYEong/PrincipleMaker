//
//  PlaceholderTextView.swift
//  PrincipleMaker
//
//  Created by choijunios on 10/5/25.
//

import UIKit

final class PlaceholderTextView: UITextView, UITextViewDelegate {
    private let placeholderLabel = UILabel()
    
    var placeholder: String? {
        didSet { placeholderLabel.text = placeholder }
    }
    
    override var intrinsicContentSize: CGSize {
        CGSize(
            width: UIView.noIntrinsicMetric,
            height: contentSize.height + contentInset.top + contentInset.bottom
        )
    }

    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        setup()
    }
    required init?(coder: NSCoder) { nil }

    private func setup() {
        self.delegate = self
        self.backgroundColor = .clear
        self.font = .systemFont(ofSize: 17, weight: .regular)
        self.textContainer.maximumNumberOfLines = 0
        self.textContainerInset = .init(top: 5, left: 5, bottom: 5, right: 5)
        self.textContainer.lineFragmentPadding = 0
        
        placeholderLabel.textColor = .lightGray
        placeholderLabel.font = font
        placeholderLabel.numberOfLines = 0

        addSubview(placeholderLabel)
        placeholderLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(textContainerInset.left)
            make.centerY.equalToSuperview()
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        placeholderLabel.isHidden = !textView.text.isEmpty
        textView.invalidateIntrinsicContentSize()
    }
}
