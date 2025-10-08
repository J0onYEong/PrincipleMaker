import UIKit
import Combine

@MainActor
enum LifeCycleEvent: Equatable {
    case viewDidLoad
    case viewWillAppear(Bool)
    case viewDidAppear(Bool)
    case viewWillDisappear(Bool)
    case viewDidDisappear(Bool)
    case viewWillLayoutSubviews
    case viewDidLayoutSubviews
}

class BaseViewController: UIViewController {
    typealias LifeCyclePublisher = PassthroughSubject<LifeCycleEvent, Never>
    let lifeCyclePublisher: LifeCyclePublisher = LifeCyclePublisher()
    
    init() {
        super.init(nibName: nil, bundle: nil)
        initialize()
    }
    @available(*, deprecated)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open func initialize() {}
    
    open func attribute() {}
    
    open func layout() {}
    
    override func viewDidLoad() {
        super.viewDidLoad()
        attribute()
        layout()
        lifeCyclePublisher.send(.viewDidLoad)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        lifeCyclePublisher.send(.viewWillAppear(animated))
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        lifeCyclePublisher.send(.viewDidAppear(animated))
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        lifeCyclePublisher.send(.viewWillDisappear(animated))
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        lifeCyclePublisher.send(.viewDidDisappear(animated))
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        lifeCyclePublisher.send(.viewWillLayoutSubviews)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        lifeCyclePublisher.send(.viewDidLayoutSubviews)
    }
}
