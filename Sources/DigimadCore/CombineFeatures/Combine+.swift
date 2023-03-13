//
//  File.swift
//  
//
//  Created by Роман Анпилов on 13.03.2023.
//

import Foundation
import Combine

@available(macOS 10.15, *)
public struct Feedback<State, Event> {
    let run: (AnyPublisher<State, Never>) -> AnyPublisher<Event, Never>
}

@available(macOS 10.15, *)
public extension Feedback {
    init<Effect: Publisher>(
        effects: @escaping (State) -> Effect
    ) where Effect.Output == Event, Effect.Failure == Never {
        self.run = { state -> AnyPublisher<Event, Never> in
            state
                .map { effects($0) }
                .switchToLatest()
                .eraseToAnyPublisher()
        }
    }
}
