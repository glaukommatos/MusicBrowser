//
//  MockSessionRepository.swift
//  MusicBrowserTests
//
//  Created by Kyle Pointer on 27.07.21.
//

import Foundation
import Combine
@testable import MusicBrowser

struct MockSessionRepository: SessionRepositoryProtocol {
    var currentSessions: [Session]?
    var searchResults: [String: [Session]]?

    func current() -> AnyPublisher<[Session], Error> {
        Future { promise in
            promise(Result.success(currentSessions!))
        }
        .eraseToAnyPublisher()
    }

    func search(for term: String) -> AnyPublisher<[Session], Error> {
        Future { promise in
            promise(Result.success(searchResults![term]!))
        }
        .eraseToAnyPublisher()
    }
}
