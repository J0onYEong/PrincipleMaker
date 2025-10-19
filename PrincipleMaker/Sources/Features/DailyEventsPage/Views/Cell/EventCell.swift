//
//  EventCell.swift
//  PrincipleMaker
//
//  Created by choijunios on 10/19/25.
//

import Then
import SnapKit
import Reusable
import UIKit

final class EventCell: UITableViewCell, Reusable {
    private let mainContainer = UIVisualEffectView()
    private let mainStack = UIStackView()
    private let textView = UITextView()
    private let editButton = UIButton()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        attribute()
        layout()
    }
    required init?(coder: NSCoder) { nil }
    
    private func attribute() {
        selectionStyle = .none
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        
        mainContainer.cornerConfiguration = .corners(radius: .fixed(10))
        mainContainer.effect = UIGlassEffect(style: .regular).then {
            $0.tintColor = UIColor.lightGray.withAlphaComponent(0.3)
        }
        
        textView.isUserInteractionEnabled = false
        textView.isScrollEnabled = false
        textView.backgroundColor = .clear
        textView.textContainerInset = .zero
        textView.textContainer.lineFragmentPadding = 0
        textView.font = .preferredFont(forTextStyle: .body)
        textView.textColor = .label
        
        editButton.configuration = .glass()
        editButton.configuration?.image = UIImage(systemName: "square.and.pencil")
    }
    
    private func layout() {
        contentView.addSubview(mainContainer)
        mainContainer.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        mainContainer.addSubview(mainStack)
        mainStack.axis = .horizontal
        mainStack.alignment = .top
        mainStack.spacing = 10
        mainStack.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(20)
            make.verticalEdges.equalToSuperview().inset(10)
        }
        
        [textView, editButton].forEach {
            mainStack.addArrangedSubview($0)
        }
        
        editButton.snp.makeConstraints { make in
            make.width.height.equalTo(40)
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        textView.text = nil
    }
    
    func configure(using item: EventItem) {
        textView.text = item.description
    }
}
