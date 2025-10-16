import UIKit
import Combine

@MainActor
struct LifeCyclePublisher {
    fileprivate let _viewDidLoad = PassthroughSubject<Void, Never>()
    fileprivate let _viewWillAppear = PassthroughSubject<Bool, Never>()
    fileprivate let _viewDidAppear = PassthroughSubject<Bool, Never>()
    fileprivate let _viewWillDisappear = PassthroughSubject<Bool, Never>()
    fileprivate let _viewDidDisappear = PassthroughSubject<Bool, Never>()
    fileprivate let _viewWillLayoutSubviews = PassthroughSubject<Void, Never>()
    fileprivate let _viewDidLayoutSubviews = PassthroughSubject<Void, Never>()
    
    var viewDidLoad: AnyPublisher<Void, Never> {
        _viewDidLoad.eraseToAnyPublisher()
    }
    var viewWillAppear: AnyPublisher<Bool, Never> {
        _viewWillAppear.eraseToAnyPublisher()
    }
    var viewDidAppear: AnyPublisher<Bool, Never> {
        _viewDidAppear.eraseToAnyPublisher()
    }
    var viewWillDisappear: AnyPublisher<Bool, Never> {
        _viewWillDisappear.eraseToAnyPublisher()
    }
    var viewDidDisappear: AnyPublisher<Bool, Never> {
        _viewDidDisappear.eraseToAnyPublisher()
    }
    var viewWillLayoutSubviews: AnyPublisher<Void, Never> {
        _viewWillLayoutSubviews.eraseToAnyPublisher()
    }
    var viewDidLayoutSubviews: AnyPublisher<Void, Never> {
        _viewDidLayoutSubviews.eraseToAnyPublisher()
    }
}

class BaseViewController: UIViewController {
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
        lifeCyclePublisher._viewDidLoad.send(())
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        lifeCyclePublisher._viewWillAppear.send(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        lifeCyclePublisher._viewDidAppear.send(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        lifeCyclePublisher._viewWillDisappear.send(animated)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        lifeCyclePublisher._viewDidDisappear.send(animated)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        lifeCyclePublisher._viewWillLayoutSubviews.send(())
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        lifeCyclePublisher._viewDidLayoutSubviews.send(())
    }
}
