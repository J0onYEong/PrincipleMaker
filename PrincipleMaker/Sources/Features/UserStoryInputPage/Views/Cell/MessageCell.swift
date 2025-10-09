//
//  MessageCell.swift
//  PrincipleMaker
//
//  Created by choijunios on 10/7/25.
//

import Reusable
import SnapKit
import UIKit

final class MessageCell: UITableViewCell, Reusable {
    private enum Config {
        static let messageLabelInset: CGFloat = 10
        static let messageContainerMinWidth: CGFloat = 50
        static let messageContainerMinHeight: CGFloat = 40
    }
    private let hostImageView: GlassImageView = GlassImageView()
    private let messageContainer: UIVisualEffectView = UIVisualEffectView()
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
        messageLabel.text = nil
    }
    
    private func attribute() {
        self.backgroundColor = .clear
        
        contentView.backgroundColor = .clear
        
        hostImageView.image = UIImage(systemName: "person.circle")
        hostImageView.contentMode = .scaleAspectFit
        hostImageView.imageColor = .systemGreen
        hostImageView.radius = 10
        hostImageView.inset = 5
        hostImageView.imageSize = .init(width: 30, height: 30)
        contentView.addSubview(hostImageView)
        
        messageContainer.cornerConfiguration = UICornerConfiguration.corners(radius: .fixed(10))
        let glassEffect = UIGlassEffect(style: .regular)
        glassEffect.tintColor = .lightGray.withAlphaComponent(0.3)
        messageContainer.effect = glassEffect
        contentView.addSubview(messageContainer)
        
        messageLabel.font = .systemFont(ofSize: 17)
        messageLabel.textColor = .black
        messageLabel.numberOfLines = 0
        messageContainer.contentView.addSubview(messageLabel)
        
        loadingImage.image = UIImage(systemName: "hourglass")
        loadingImage.tintColor = .white
        messageContainer.contentView.addSubview(loadingImage)
    }
    
    private func layout() {
        hostImageView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.equalToSuperview()
        }
        
        messageContainer.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(15)
            make.left.equalTo(hostImageView.snp.right).offset(3)
            make.right.lessThanOrEqualToSuperview().inset(20)
            make.bottom.equalToSuperview()
            
            make.height.greaterThanOrEqualTo(Config.messageContainerMinHeight)
            make.width.greaterThanOrEqualTo(Config.messageContainerMinWidth)
        }
        
        messageLabel.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(Config.messageLabelInset)
            make.verticalEdges.equalToSuperview().inset(Config.messageLabelInset)
        }
        
        loadingImage.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.height.equalTo(20)
        }
    }
    
    private func startLoadingAnimation() {
        loadingImage.addSymbolEffect(.rotate, options: .repeat(.periodic))
    }
    
    private func stopLoadingAnimation() {
        loadingImage.removeAllSymbolEffects()
    }
    
    func configure(using model: MessageModel) {
        updateLayout(for: model.direction)

        switch model.mode {
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

    private func updateLayout(for direction: MessageDirection) {
        switch direction {
        case .left:
            hostImageView.snp.removeConstraints()
            messageContainer.snp.removeConstraints()
            
            hostImageView.snp.makeConstraints { make in
                make.top.equalToSuperview()
                make.left.equalToSuperview()
            }

            messageContainer.snp.makeConstraints { make in
                make.top.equalToSuperview().inset(15)
                make.left.equalTo(hostImageView.snp.right).offset(3)
                make.right.lessThanOrEqualToSuperview().inset(20)
                make.height.greaterThanOrEqualTo(Config.messageContainerMinHeight)
                make.width.greaterThanOrEqualTo(Config.messageContainerMinWidth)
                make.bottom.equalToSuperview()
            }
        case .right:
            hostImageView.snp.removeConstraints()
            messageContainer.snp.removeConstraints()
            
            hostImageView.snp.makeConstraints { make in
                make.top.equalToSuperview()
                make.right.equalToSuperview()
            }

            messageContainer.snp.makeConstraints { make in
                make.top.equalToSuperview().inset(15)
                make.right.equalTo(hostImageView.snp.left).offset(-3)
                make.left.greaterThanOrEqualToSuperview().inset(20)
                make.height.greaterThanOrEqualTo(Config.messageContainerMinHeight)
                make.width.greaterThanOrEqualTo(Config.messageContainerMinWidth)
                make.bottom.equalToSuperview()
            }
        }
    }
}

#Preview("Left 메세지", traits: .defaultLayout) {
    let view = MessageCell()
    let state = MessageModel(
        direction: .left,
        mode: .message("HelloHelloHelloHelloHelloHelloHelloHelloHelloHelloHelloHelloHelloHelloHelloHelloHelloHelloHelloHelloHelloHelloHelloHelloHelloHelloHelloHelloHelloHelloHello")
    )
    view.configure(using: state)
    return view
}

#Preview("Right 로딩중", traits: .defaultLayout) {
    let view = MessageCell()
    let state = MessageModel(
        direction: .right,
        mode: .typing
    )
    view.configure(using: state)
    return view
}
