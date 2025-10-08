//
//  MessageCell.swift
//  PrincipleMaker
//
//  Created by choijunios on 10/7/25.
//

import SnapKit
import UIKit

enum StoryMessageDirection {
    case left, right
}

enum StoryMessageMode {
    case message(String)
    case typing
}

struct StoryMessageState {
    let direction: StoryMessageDirection
    let mode: StoryMessageMode
}

final class MessageCell: UITableViewCell {
    private enum Config {
        static let messageLabelInset: CGFloat = 10
        static let messageContainerMinWidth: CGFloat = 50
        static let messageContainerMinHeight: CGFloat = 30
    }
    private let hostImageView: UIImageView = UIImageView()
    private let messageContainer: UIView = UIView()
    private let messageLabel: UILabel = UILabel()
    private let loadingImage: UIImageView = UIImageView()
    
    // Animation
    private var loadingTimer: Timer?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        attribute()
        layout()
    }
    required init?(coder: NSCoder) { nil }
    
    override func prepareForReuse() {
        stopLoadingAnimation()
    }
    
    private func attribute() {
        hostImageView.image = UIImage(systemName: "person.circle")
        hostImageView.tintColor = .systemGreen
        hostImageView.layer.cornerRadius = 10
        
        messageContainer.layer.cornerRadius = 10
        messageContainer.backgroundColor = .lightGray
        
        messageLabel.font = .systemFont(ofSize: 17)
        messageLabel.textColor = .black
        messageLabel.numberOfLines = 0
        
        loadingImage.image = UIImage(systemName: "hourglass")
        loadingImage.tintColor = .white
    }
    
    private func layout() {
        contentView.addSubview(hostImageView)
        hostImageView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.equalToSuperview()
            make.width.height.equalTo(30)
        }
        
        contentView.addSubview(messageContainer)
        messageContainer.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(15)
            make.left.equalTo(hostImageView.snp.right).offset(3)
            make.right.lessThanOrEqualToSuperview().inset(20)
            
            make.height.greaterThanOrEqualTo(Config.messageContainerMinHeight)
            make.width.greaterThanOrEqualTo(Config.messageContainerMinWidth)
        }
        
        messageContainer.addSubview(messageLabel)
        messageLabel.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(Config.messageLabelInset)
            make.verticalEdges.equalToSuperview().inset(Config.messageLabelInset)
        }
        
        messageContainer.addSubview(loadingImage)
        loadingImage.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.height.equalTo(15)
        }
    }
    
    private func startLoadingAnimation() {
        loadingImage.addSymbolEffect(.rotate, options: .repeat(.periodic))
    }
    
    private func stopLoadingAnimation() {
        loadingImage.removeAllSymbolEffects()
    }
    
    func configure(using state: StoryMessageState) {
        updateLayout(for: state.direction)

        switch state.mode {
        case .message(let string):
            loadingImage.isHidden = true
            stopLoadingAnimation()
            messageLabel.text = string
        case .typing:
            loadingImage.isHidden = false
            startLoadingAnimation()
            messageLabel.text = ""
        }
    }

    private func updateLayout(for direction: StoryMessageDirection) {
        switch direction {
        case .left:
            hostImageView.snp.remakeConstraints { make in
                make.top.equalToSuperview()
                make.left.equalToSuperview()
                make.width.height.equalTo(30)
            }

            messageContainer.snp.remakeConstraints { make in
                make.top.equalToSuperview().inset(15)
                make.left.equalTo(hostImageView.snp.right).offset(3)
                make.right.lessThanOrEqualToSuperview().inset(20)
                make.height.greaterThanOrEqualTo(Config.messageContainerMinHeight)
                make.width.greaterThanOrEqualTo(Config.messageContainerMinWidth)
            }
        case .right:
            hostImageView.snp.remakeConstraints { make in
                make.top.equalToSuperview()
                make.right.equalToSuperview()
                make.width.height.equalTo(30)
            }

            messageContainer.snp.remakeConstraints { make in
                make.top.equalToSuperview().inset(15)
                make.right.equalTo(hostImageView.snp.left).offset(-3)
                make.left.greaterThanOrEqualToSuperview().inset(20)
                make.height.greaterThanOrEqualTo(Config.messageContainerMinHeight)
                make.width.greaterThanOrEqualTo(Config.messageContainerMinWidth)
            }
        }
    }
}

#Preview("Left 메세지", traits: .defaultLayout) {
    let view = MessageCell()
    let state = StoryMessageState(
        direction: .left,
        mode: .message("HelloHelloHelloHelloHelloHelloHelloHelloHelloHelloHelloHelloHelloHelloHelloHelloHelloHelloHelloHelloHelloHelloHelloHelloHelloHelloHelloHelloHelloHelloHello")
    )
    view.configure(using: state)
    return view
}

#Preview("Right 로딩중", traits: .defaultLayout) {
    let view = MessageCell()
    let state = StoryMessageState(
        direction: .right,
        mode: .typing
    )
    view.configure(using: state)
    return view
}
