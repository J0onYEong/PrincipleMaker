//
//  Injected.swift
//  PrincipleMaker
//
//  Created by choijunios on 10/8/25.
//

import Swinject

@propertyWrapper
struct Injected<T> {
    let wrappedValue: T
    init() {
        self.wrappedValue = DependencyInjector.shared.resolve()
    }
}

protocol DependencyAssemblable {
    func assemble(_ assemblyList: [Assembly])
    func register<T>(_ serviceType: T.Type, _ object: @escaping @autoclosure () -> T)
}


protocol DependencyResolvable {
    func resolve<T>() -> T
    func resolve<T>(_ serviceType: T.Type) -> T
}

typealias Injector = DependencyAssemblable & DependencyResolvable

final class DependencyInjector: Injector {
    nonisolated(unsafe) static let shared: DependencyInjector = .init()
    private let container: Container
    
    private init(container: Container = Container()) {
        self.container = container
    }
    
    func assemble(_ assemblyList: [Assembly]) {
        assemblyList.forEach {
            $0.assemble(container: container)
        }
    }
    
    func register<T>(_ serviceType: T.Type, _ object: @escaping @autoclosure () -> T) {
        container.register(serviceType) { _ in object() }
    }
    
    func resolve<T>() -> T {
        container.resolve(T.self)!
    }
    
    func resolve<T>(_ serviceType: T.Type) -> T {
        container.resolve(T.self)!
    }
}
