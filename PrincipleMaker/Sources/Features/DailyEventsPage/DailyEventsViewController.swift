//
//  DailyEventsViewController.swift
//  PrincipleMaker
//
//  Created by choijunios on 10/16/25.
//

import Combine
import SnapKit
import Reusable
import UIKit

@MainActor
final class DailyEventsViewController: BaseViewController {
    private typealias Section = Int
    private typealias EventDataSource = UITableViewDiffableDataSource<Section, EventItem>
    private typealias EventSnapshot = NSDiffableDataSourceSnapshot<Section, EventItem>
    
    private var viewModel: DailyEventsViewModel!
    private var store: Set<AnyCancellable> = []
    
    private let loadingView = DailyEventsLoadingView()
    private let tableView = UITableView(frame: .zero, style: .plain)
    private lazy var dataSource: EventDataSource = makeDataSource()
    
    override init() {
        super.init()
    }
    required init?(coder: NSCoder) { nil }
    
    func bind(viewModel: DailyEventsViewModel) {
        self.viewModel = viewModel
        
        // Input
        lifeCyclePublisher
            .viewDidLoad
            .unretained(viewModel)
            .sink { vm, _ in
                vm.send(input: .viewDidLoad)
            }
            .store(in: &store)
        
        // Output
        viewModel
            .eventItems
            .unretained(self)
            .sink { vc, events in
                vc.applySnapshot(with: events, animatingDifferences: true)
            }
            .store(in: &store)
        
        viewModel
            .isLoading
            .sink { [weak self] isLoading in
                guard let self else { return }
                if isLoading {
                    loadingView.isHidden = false
                    view.bringSubviewToFront(loadingView)
                    loadingView.startSkeletonAnimation()
                } else {
                    loadingView.stopSkeletonAnimation()
                    loadingView.isHidden = true
                }
            }
            .store(in: &store)
    }
    
    override func attribute() {
        navigationItem.title = "오늘의 사건들"
        view.backgroundColor = .systemBackground
        
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 120
        tableView.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 20, right: 0)
        tableView.register(cellType: EventCell.self)
        tableView.dataSource = dataSource
    }
    
    override func layout() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide).inset(16)
        }
        
        view.addSubview(loadingView)
        loadingView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
}

extension DailyEventsViewController {
    private func makeDataSource() -> EventDataSource {
        EventDataSource(tableView: tableView) { tableView, indexPath, item in
            let cell: EventCell = tableView.dequeueReusableCell(for: indexPath)
            cell.configure(using: item)
            return cell
        }
    }
    
    private func applySnapshot(with events: [EventItem], animatingDifferences: Bool) {
        var snapshot = EventSnapshot()
        snapshot.appendSections([0])
        snapshot.appendItems(events, toSection: 0)
        dataSource.apply(snapshot, animatingDifferences: animatingDifferences)
    }
}
