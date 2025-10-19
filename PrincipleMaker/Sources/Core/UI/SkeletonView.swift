//
//  SkeletonView.swift
//  PrincipleMaker
//
//  Created by choijunios on 10/19/25.
//

import UIKit

final class SkeletonView: UIView {
    private let gradientLayer = CAGradientLayer()
    
    init() {
        super.init(frame: .zero)
        setup()
        startAnimation()
    }
    required init?(coder: NSCoder) { nil }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = layer.bounds
    }
    
    private func setup() {
        layer.backgroundColor = UIColor.systemBackground.cgColor
        
        gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
        gradientLayer.colors = [
            UIColor.systemGray5.cgColor,
            UIColor.systemGray4.withAlphaComponent(0.6).cgColor,
            UIColor.systemGray5.cgColor,
        ]
        gradientLayer.locations = [-1.0, -0.5, 0.0]
        layer.addSublayer(gradientLayer)
    }
    
    func startAnimation() {
        gradientLayer.removeAllAnimations()
        
        let locationsAnimation = CAKeyframeAnimation(keyPath: "locations")
        locationsAnimation.values = [
            [-1.0, -0.5, 0.0],
            [0.0, 0.5, 1.0],
            [1.0, 1.5, 2.0],
        ]
        locationsAnimation.keyTimes = [0.0, 0.5, 1.0] as [NSNumber]
        locationsAnimation.duration = 1.8
        locationsAnimation.repeatCount = .infinity
        locationsAnimation.isRemovedOnCompletion = false
        locationsAnimation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        
        let opacityAnimation = CAKeyframeAnimation(keyPath: "opacity")
        opacityAnimation.values = [0.6, 1.0, 0.6]
        opacityAnimation.keyTimes = [0.0, 0.5, 1.0] as [NSNumber]
        opacityAnimation.duration = 1.8
        opacityAnimation.repeatCount = .infinity
        opacityAnimation.isRemovedOnCompletion = false
        opacityAnimation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        
        gradientLayer.add(locationsAnimation, forKey: "skeleton.locations")
        gradientLayer.add(opacityAnimation, forKey: "skeleton.opacity")
    }
    
    func stopAnimation() {
        gradientLayer.removeAllAnimations()
    }
}
