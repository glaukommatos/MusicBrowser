//
//  SessionRepositoryTests.swift
//  MusicBrowserTests
//
//  Created by Kyle Pointer on 27.07.21.
//

// swiftlint:disable force_try

import XCTest
import Combine
@testable import MusicBrowser

class SessionRepositoryTests: XCTestCase {
    var subscriptions = Set<AnyCancellable>()
    let encoder = Serialization.encoder

    func testSessionRepositoryGetsCurrent() {
        let mockDataProvider = MockDataProvider(responses: [
            exampleImageUrl: exampleImageData,
            currentUrl: try! encoder.encode(exampleResponse)
        ])

        let radioService = SessionRepository(dataProvider: mockDataProvider)

        let expectValue = XCTestExpectation(description: "Should receive value.")
        let expectComplete = XCTestExpectation(description: "Should complete.")

        radioService.current().sink { _ in
            expectComplete.fulfill()
        } receiveValue: { [weak self] sessions in
            XCTAssertEqual(sessions.count, 1)
            let session = sessions[0]
            XCTAssertEqual(session.name, "Test")
            XCTAssertEqual(session.listenerCount, 0)
            XCTAssertEqual(session.genres, [])
            XCTAssertEqual(session.imageData, self?.exampleImageData)

            expectValue.fulfill()
        }.store(in: &subscriptions)

        wait(for: [expectValue, expectComplete], timeout: 1)
    }

    func testSessionRepositoryGetsSearch() {
        let mockDataProvider = MockDataProvider(responses: [
            exampleImageUrl: exampleImageData,
            searchUrl: try! encoder.encode(exampleResponse)
        ])

        let radioService = SessionRepository(dataProvider: mockDataProvider)

        let expectValue = XCTestExpectation(description: "Should receive value.")
        let expectComplete = XCTestExpectation(description: "Should complete.")

        radioService.search(for: "searchTerm").sink { _ in
            expectComplete.fulfill()
        } receiveValue: { [weak self] sessions in
            XCTAssertEqual(sessions.count, 1)
            let session = sessions[0]
            XCTAssertEqual(session.name, "Test")
            XCTAssertEqual(session.listenerCount, 0)
            XCTAssertEqual(session.genres, [])
            XCTAssertEqual(session.imageData, self?.exampleImageData)

            expectValue.fulfill()
        }.store(in: &subscriptions)

        wait(for: [expectValue, expectComplete], timeout: 1)
    }

    // MARK: Test Data

    let exampleImageData = Data()
    let exampleImageUrl = URL(string: "http://www.duckduckgo.com/animage.png")!

    let exampleResponse = SessionResponseModel(
        data: SessionResponseModel.Data(
            sessions: [
                SessionResponseModel.Data.Session(
                    name: "Test",
                    genres: [],
                    listenerCount: 0,
                    currentTrack: SessionResponseModel.Data.Session.Track(
                        title: "title",
                        artworkUrl: URL(string: "http://www.duckduckgo.com/animage.png")!
                    )
                )
            ]
        )
    )

    let currentUrl = URL(string: "https://www.mocky.io/v2/5df79a3a320000f0612e0115")!
    let searchUrl = URL(string: "https://www.mocky.io/v2/5df79b1f320000f4612e011e")!
}
