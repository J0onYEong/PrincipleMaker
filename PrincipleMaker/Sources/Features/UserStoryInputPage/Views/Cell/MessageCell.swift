//
//  MessageCell.swift
//  PrincipleMaker
//
//  Created by choijunios on 10/7/25.
//

import Lottie
import Reusable
import SnapKit
import UIKit

final class MessageCell: UITableViewCell, Reusable {
    private enum Config {
        static let cellTopPadding: CGFloat = 15
        static let messageLabelInset: CGFloat = 10
        static let messageContainerMinHeight: CGFloat = 50
    }
    
    private let topPaddingView: UIView = UIView()
    private let realContentView: UIView = UIView()
    private let hostImageView: GlassImageView = GlassImageView()
    private let messageContainer: UIVisualEffectView = UIVisualEffectView()
    private let messageLabel: UILabel = UILabel()
    private lazy var loadingView: LottieAnimationView = createLottieView()
    
    private var topPaddingHeightConstraint: Constraint?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        attribute()
        layout()
    }
    required init?(coder: NSCoder) { nil }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        stopLoadingAnimation()
        messageLabel.text = nil
    }
    
    func configure(using model: MessageModel, isFirstCell: Bool) {
        updateTopPadding(isFirstCell: isFirstCell)
        updateLayout(for: model.direction)
        
        switch model.mode {
        case .message(let string):
            setLoadingView(isPresent: false)
            stopLoadingAnimation()
            messageLabel.text = string
        case .typing:
            setLoadingView(isPresent: true)
            startLoadingAnimation()
            messageLabel.text = ""
        }
    }
    
    private func attribute() {
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        
        topPaddingView.backgroundColor = .clear
        realContentView.backgroundColor = .clear
        
        contentView.addSubview(topPaddingView)
        contentView.addSubview(realContentView)
        
        hostImageView.image = UIImage(systemName: "person.circle")
        hostImageView.contentMode = .scaleAspectFit
        hostImageView.imageColor = .systemGreen
        hostImageView.radius = 10
        hostImageView.inset = 5
        hostImageView.imageSize = .init(width: 30, height: 30)
        realContentView.addSubview(hostImageView)
        
        messageContainer.cornerConfiguration = .corners(radius: .fixed(10))
        let glassEffect = UIGlassEffect(style: .regular)
        glassEffect.tintColor = .lightGray.withAlphaComponent(0.3)
        messageContainer.effect = glassEffect
        realContentView.addSubview(messageContainer)
        
        messageLabel.font = .systemFont(ofSize: 17)
        messageLabel.textColor = .label
        messageLabel.numberOfLines = 0
        messageContainer.contentView.addSubview(messageLabel)
        
        loadingView.contentMode = .scaleAspectFit
        messageContainer.contentView.addSubview(loadingView)
    }
    
    private func layout() {
        topPaddingView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            topPaddingHeightConstraint = make.height.equalTo(Config.cellTopPadding).constraint
        }
        
        realContentView.snp.makeConstraints { make in
            make.top.equalTo(topPaddingView.snp.bottom)
            make.left.right.bottom.equalToSuperview()
        }
        
        hostImageView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.equalToSuperview()
        }
        
        messageContainer.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(15)
            make.left.equalTo(hostImageView.snp.right).offset(5)
            make.right.lessThanOrEqualTo(realContentView.snp.right).inset(20)
            make.bottom.equalToSuperview()
            make.height.greaterThanOrEqualTo(Config.messageContainerMinHeight)
        }
        
        messageContainer.contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        messageLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(Config.messageLabelInset)
        }
        
        loadingView.snp.makeConstraints { make in
            make.height.width.equalTo(Config.messageContainerMinHeight - Config.messageLabelInset)
            make.edges.equalToSuperview().inset(Config.messageLabelInset)
        }
    }
    
    private func setLoadingView(isPresent: Bool) {
        loadingView.isHidden = !isPresent
        loadingView.snp.removeConstraints()
        if isPresent {
            loadingView.snp.makeConstraints { make in
                make.height.width.equalTo(Config.messageContainerMinHeight - Config.messageLabelInset)
                make.edges.equalToSuperview().inset(Config.messageLabelInset)
            }
        }
    }
    
    private func startLoadingAnimation() {
        loadingView.loopMode = .loop
        loadingView.animationSpeed = 1
        loadingView.play()
    }
    
    private func stopLoadingAnimation() {
        loadingView.stop()
    }
    
    private func updateTopPadding(isFirstCell: Bool) {
        topPaddingHeightConstraint?.update(offset: isFirstCell ? 0 : Config.cellTopPadding)
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
                make.left.equalTo(hostImageView.snp.right).offset(5)
                make.right.lessThanOrEqualTo(realContentView.snp.right).inset(20)
                make.height.greaterThanOrEqualTo(Config.messageContainerMinHeight)
                make.bottom.equalToSuperview()
            }
        case .right:
            hostImageView.snp.removeConstraints()
            messageContainer.snp.removeConstraints()
            
            hostImageView.snp.makeConstraints { make in
                make.top.equalToSuperview()
                make.right.equalTo(realContentView.snp.right)
            }
            
            messageContainer.snp.makeConstraints { make in
                make.top.equalToSuperview().inset(15)
                make.right.equalTo(hostImageView.snp.left).offset(-5)
                make.left.greaterThanOrEqualTo(realContentView.snp.left).inset(20)
                make.height.greaterThanOrEqualTo(Config.messageContainerMinHeight)
                make.bottom.equalToSuperview()
            }
        }
    }
    
    private func createLottieView() -> LottieAnimationView {
        guard let path = Bundle.main.path(forResource: "Thinking", ofType: "json") else {
            fatalError("Lottie resource(Thinking.json) missing.")
        }
        return LottieAnimationView(filePath: path)
    }
}

#Preview("Left 메세지", traits: .defaultLayout) {
    let view = MessageCell()
    let state = MessageModel(
        direction: .left,
        mode: .message("HelloHelloHelloHelloHelloHelloHelloHelloHelloHelloHelloHelloHelloHelloHelloHelloHelloHelloHelloHelloHelloHelloHelloHelloHelloHelloHelloHelloHelloHelloHello")
    )
    view.configure(using: state, isFirstCell: true)
    return view
}

#Preview("Right 로딩중", traits: .defaultLayout) {
    let view = MessageCell()
    let state = MessageModel(
        direction: .right,
        mode: .typing
    )
    view.configure(using: state, isFirstCell: false)
    return view
}
