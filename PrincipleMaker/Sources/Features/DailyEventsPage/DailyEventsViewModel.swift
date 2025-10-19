//
//  DailyEventsViewModel.swift
//  PrincipleMaker
//
//  Created by choijunios on 10/16/25.
//

import Combine
import Foundation

@MainActor
final class DailyEventsViewModel: Sendable {
    // Outputs
    var eventItems: AnyPublisher<[EventItem], Never> {
        $_eventItems.eraseToAnyPublisher()
    }
    var isLoading: AnyPublisher<Bool, Never> {
        $_isLoading.eraseToAnyPublisher()
    }
    
    // Internal states
    @Published private var _eventItems: [EventItem] = []
    @Published private var _isLoading: Bool = true
    
    init() {}
}

extension DailyEventsViewModel {
    enum Input {
        case viewDidLoad
    }
    
    func send(input: Input) {
        switch input {
        case .viewDidLoad:
            break
        }
    }
}
