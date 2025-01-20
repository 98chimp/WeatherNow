//
//  UserDefaultsTests.swift
//  WeatherNow
//
//  Created by Shahin Zangenehpour on 2025-01-19.
//

import XCTest
import Foundation
@testable import WeatherNow

class UserDefaultsTests: XCTestCase {

    override func setUp() {
        super.setUp()
        UserDefaults.standard.removeObject(forKey: "selectedCity")
    }

    @MainActor
    func testSaveSelectedCity() {
        let viewModel = WeatherViewModel()
        viewModel.saveSelectedCity("San Francisco")
        XCTAssertEqual(UserDefaults.standard.string(forKey: "selectedCity"), "San Francisco")
    }

    @MainActor func testLoadSavedCity() {
        UserDefaults.standard.set("Los Angeles", forKey: "selectedCity")
        let viewModel = WeatherViewModel()
        viewModel.loadSavedCity()
        XCTAssertEqual(viewModel.savedCity, "Los Angeles")
    }

    @MainActor func testClearSavedCity() {
        UserDefaults.standard.set("Chicago", forKey: "selectedCity")
        let viewModel = WeatherViewModel()
        viewModel.clearSavedCity()
        XCTAssertNil(UserDefaults.standard.string(forKey: "selectedCity"))
    }
}
