//
//  DailyEventsLoadingView.swift
//  PrincipleMaker
//
//  Created by choijunios on 10/19/25.
//

import Then
import SnapKit
import UIKit

final class DailyEventsLoadingView: UIView {
    private enum Config {
        static let spacing: CGFloat = 10
        static let skeletonHeight: CGFloat = 65
    }
    
    private let label = UILabel()
    private let skeletonStackView = UIStackView()
    private var skeletonViews: [SkeletonView] = []
    
    init() {
        super.init(frame: .zero)
        attribute()
        setupSkeleltonViews()
    }
    required init?(coder: NSCoder) { nil }
    
    private func attribute() {
        label.font = .systemFont(ofSize: 17)
    }
    
    private func layout() {
        skeletonStackView.axis = .vertical
        skeletonStackView.spacing = Config.spacing
        skeletonStackView.alignment = .fill
        skeletonStackView.distribution = .fillEqually
        addSubview(skeletonStackView)
        skeletonStackView.snp.makeConstraints { make in
            make.verticalEdges.equalTo(safeAreaLayoutGuide)
            make.horizontalEdges.equalToSuperview().inset(10)
        }
        
        addSubview(label)
        label.snp.makeConstraints { make in
            make.center.equalTo(safeAreaLayoutGuide)
        }
    }
    
    private func setupSkeleltonViews() {
        guard let screenHeight = window?.windowScene?.screen.bounds.height else { return }
        let safeAreaHeight: CGFloat = screenHeight - (safeAreaInsets.top + safeAreaInsets.bottom)
        let countOfHeight = Int(safeAreaHeight / (Config.skeletonHeight + Config.spacing))
        self.skeletonViews = (0..<countOfHeight).map { _ in
            let view = SkeletonView()
            skeletonStackView.addArrangedSubview(view)
            view.cornerConfiguration = .corners(radius: 15)
            view.clipsToBounds = true
            return view
        }
    }
    
    func startSkeletonAnimation() {
        Task { @MainActor in
            for view in skeletonViews {
                view.startAnimation()
                try? await Task.sleep(for: .milliseconds(200))
            }
        }
    }
    
    func stopSkeletonAnimation() {
        for view in skeletonViews {
            view.stopAnimation()
        }
    }
}
