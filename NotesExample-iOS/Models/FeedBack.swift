//
//  FeedBack.swift
//  NotesExample-iOS
//
//  Created by Juan Francisco Miranda Aguilar on 12/06/2020.
//  Copyright © 2020 Juan Francisco Miranda Aguilar. All rights reserved.
//

import Combine

struct Feedback<State, Event> {
    let run: (AnyPublisher<State, Never>) -> AnyPublisher<Event, Never>
}

extension Feedback {
    init<Effect: Publisher>(effects: @escaping (State) -> Effect) where Effect.Output == Event, Effect.Failure == Never {
        self.run = { state -> AnyPublisher<Event, Never> in
            state
                .map { effects($0) }
                .switchToLatest()
                .eraseToAnyPublisher()
        }
    }
}
