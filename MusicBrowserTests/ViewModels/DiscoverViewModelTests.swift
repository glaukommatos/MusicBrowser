//
//  DiscoverViewModelTests.swift
//  MusicBrowserTests
//
//  Created by Kyle Pointer on 27.07.21.
//

import XCTest
import Combine
@testable import MusicBrowser

class DiscoverViewModelTests: XCTestCase {
    var subscriptions = Set<AnyCancellable>()

    func testFetchMore() throws {
        let exampleSessions = [Session(name: "test", genres: [], listenerCount: 0, imageData: nil)]
        let mockSessionRepository = MockSessionRepository(currentSessions: exampleSessions)
        let discoveryViewModel = DiscoverViewModel(radioRepository: mockSessionRepository)
        let sessionsSpy = Spy<[Session]>()
        let loadingSpy = Spy<Bool>()

        let sessionsExpectation = XCTestExpectation(description: "Should get new sessions.")
        sessionsExpectation.expectedFulfillmentCount = 5

        let loadingExpectation = XCTestExpectation(description: "Loading changed")
        loadingExpectation.expectedFulfillmentCount = 11

        discoveryViewModel.sessions.sink { _ in

        } receiveValue: { sessions in
            sessionsSpy.send(sessions)
            sessionsExpectation.fulfill()
        }.store(in: &subscriptions)

        discoveryViewModel.$loading
            .sink { loading in
                loadingSpy.send(loading)
                loadingExpectation.fulfill()
            }.store(in: &subscriptions)

        for _ in 0..<6 {
            discoveryViewModel.fetchMore()
        }

        wait(for: [sessionsExpectation, loadingExpectation], timeout: 10)

        XCTAssertEqual(loadingSpy.calls.first, false)
        XCTAssertEqual(loadingSpy.calls.last, false)
        XCTAssertGreaterThan(loadingSpy.calls.filter({ $0 }).count, 0)
        XCTAssertEqual(
            sessionsSpy.calls, [[Session]](repeating: exampleSessions, count: 5)
        )
    }
}
