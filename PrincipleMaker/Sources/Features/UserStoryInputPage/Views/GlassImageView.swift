//
//  GlassImageView.swift
//  PrincipleMaker
//
//  Created by choijunios on 10/9/25.
//

import SnapKit
import UIKit

final class GlassImageView: UIVisualEffectView {
    private let imageView: UIImageView = .init()
    
    var inset: CGFloat = 5.0 {
        didSet {
            imageView.snp.updateConstraints { make in
                make.edges.equalToSuperview().inset(inset)
            }
        }
    }
    
    var radius: CGFloat = 15.0 {
        didSet {
            self.cornerConfiguration = .corners(radius: .fixed(radius))
        }
    }
    
    var imageSize: CGSize = .init(width: 20, height: 20) {
        didSet {
            imageView.snp.updateConstraints { make in
                make.width.equalTo(imageSize.width)
                make.height.equalTo(imageSize.height)
            }
        }
    }
    
    var imageColor: UIColor = .white {
        didSet { imageView.tintColor = imageColor }
    }
    
    init(image: UIImage) {
        self.imageView.image = image
        super.init(effect: UIGlassEffect(style: .regular))
        setup()
    }
    required init?(coder: NSCoder) { nil }
    
    private func setup() {
        self.cornerConfiguration = .corners(radius: .fixed(15))
        
        contentView.addSubview(imageView)
        imageView.contentMode = .scaleAspectFit
        
        imageView.snp.makeConstraints { make in
            make.width.equalTo(imageSize.width)
            make.height.equalTo(imageSize.height)
            make.edges.equalToSuperview().inset(inset)
        }
    }
}

#Preview(traits: .defaultLayout) {
    let view = GlassImageView(
        image: .init(systemName: "globe.central.south.asia.fill")!
    )
    return view
}
