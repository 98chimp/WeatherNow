//
//  WeatherNowUITests.swift
//  WeatherNowUITests
//
//  Created by Shahin Zangenehpour on 2025-01-19.
//

import XCTest

class WeatherNowUITests: XCTestCase {

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    func testWeatherSearchWithMockAPI() throws {
        let app = XCUIApplication()
        app.launch()

        let searchField = app.textFields["SearchField"]
        XCTAssertTrue(searchField.exists, "Search field should exist")

        searchField.tap()
        searchField.typeText("Los Angeles\n")

        let cityName = app.staticTexts["Los Angeles"]
        XCTAssertTrue(cityName.waitForExistence(timeout: 5), "Mock Los Angeles weather should appear")

        let searchCard = app.otherElements["SearchResultCard"]
        XCTAssertTrue(searchCard.waitForExistence(timeout: 5), "Seach Result Card should be displayed")
    }
}
