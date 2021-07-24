//
//  SmokeTests.swift
//  MusicBrowserUITests
//
//  Created by Kyle Pointer on 28.07.21.
//

import XCTest

class SmokeTests: XCTestCase {
    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    func testMainCollectionViewLoads() throws {
        let app = XCUIApplication()
        app.launch()

        let currentSessions = app.collectionViews["DiscoverResults"].firstMatch

        XCTAssertTrue(currentSessions.cells.firstMatch.waitForExistence(timeout: 5))
    }

    func testSearchCollectionViewLoads() throws {
        let app = XCUIApplication()
        app.launch()

        let searchField = app.navigationBars.searchFields.firstMatch
        let searchResults = app.collectionViews["SearchResults"].firstMatch

        searchField.tap()
        searchField.typeText("Search")

        XCTAssertTrue(searchResults.cells.firstMatch.waitForExistence(timeout: 5))
    }
}
