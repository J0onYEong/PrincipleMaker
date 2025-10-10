//
//  Unretained.swift
//  PrincipleMaker
//
//  Created by choijunios on 10/8/25.
//

import Combine

extension Publisher {
    @MainActor
    func unretained<Target: AnyObject>(_ target: Target) -> AnyPublisher<(Target, Output), Failure> {
        self
            .compactMap { [weak target] output -> (Target, Output)? in
                guard let target else { return nil }
                return (target, output)
            }
            .eraseToAnyPublisher()
    }
    
    @MainActor
    func unretained<Target: AnyObject>(_ target: Target) -> AnyPublisher<Target, Failure> where Output == Void {
        self
            .compactMap { [weak target] output -> Target? in
                guard let target else { return nil }
                return target
            }
            .eraseToAnyPublisher()
    }
}
