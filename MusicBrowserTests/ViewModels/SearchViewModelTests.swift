//
//  SearchViewModelTests.swift
//  MusicBrowserTests
//
//  Created by Kyle Pointer on 27.07.21.
//

import XCTest
import Combine
@testable import MusicBrowser

class SearchViewModelTests: XCTestCase {
    var subscriptions = Set<AnyCancellable>()

    func testSearch() throws {
        let exampleSessions = [Session(name: "example", genres: [], listenerCount: 0, imageData: nil)]
        let mockSessionRepository = MockSessionRepository(searchResults: ["New Search Term": exampleSessions])
        let searchViewModel = SearchViewModel(sessionRepository: mockSessionRepository)
        let resultsSpy = Spy<[Session]>()
        let loadingSpy = Spy<Bool>()

        let expectation = XCTestExpectation(description: "Should get search results.")

        searchViewModel.searchResults
            .sink { _ in

            } receiveValue: { sessions in
                resultsSpy.send(sessions)
                expectation.fulfill()
            }.store(in: &subscriptions)

        searchViewModel.$loading
            .removeDuplicates()
            .sink { loading in
                loadingSpy.send(loading)
            }.store(in: &subscriptions)

        searchViewModel.search(for: "New Search Term")

        wait(for: [expectation], timeout: 2)

        XCTAssertEqual(resultsSpy.calls, [exampleSessions])
        XCTAssertEqual(loadingSpy.calls, [false, true, false])
    }
}
