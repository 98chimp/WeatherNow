//
//  WeatherViewModelTests.swift
//  WeatherNow
//
//  Created by Shahin Zangenehpour on 2025-01-19.
//

import XCTest
@testable import WeatherNow

class WeatherViewModelTests: XCTestCase {

    override func setUp() {
        super.setUp()
        UserDefaults.standard.removeObject(forKey: "selectedCity")
    }

    func testFetchWeatherSuccess() async throws {
        let mockAPIService = MockWeatherAPIService()
        let viewModel = await WeatherViewModel(weatherService: mockAPIService)

        await viewModel.getWeather(for: "New York")

        await MainActor.run {
            XCTAssertEqual(viewModel.weather?.location.name, "New York")
            XCTAssertEqual(viewModel.weather?.current.tempC, 25.0)
        }
    }

    func testFetchWeatherFailure() async throws {
        let mockAPIService = MockWeatherAPIService(shouldFail: true)
        let viewModel = await WeatherViewModel(weatherService: mockAPIService)

        await viewModel.getWeather(for: "Invalid City")

        await MainActor.run {
            XCTAssertNil(viewModel.weather)
            XCTAssertEqual(viewModel.errorMessage, "Failed to fetch weather for Invalid City")
        }
    }

    func testSaveAndLoadSelectedCity() async throws {
        let viewModel = await WeatherViewModel()

        await viewModel.saveSelectedCity("San Francisco")
        await viewModel.loadSavedCity()

        await MainActor.run {
            XCTAssertEqual(viewModel.savedCity, "San Francisco")
        }
    }

    func testClearSavedCity() async throws {
        let viewModel = await WeatherViewModel()
        await viewModel.saveSelectedCity("Chicago")

        await viewModel.clearSavedCity()

        await MainActor.run {
            XCTAssertNil(viewModel.savedCity)
            XCTAssertNil(viewModel.weather)
        }
    }

    func testReloadSavedCityOnAppStart() async throws {
        UserDefaults.standard.set("London", forKey: "selectedCity")

        let viewModel = await WeatherViewModel()
        await viewModel.loadSavedCity()

        await MainActor.run {
            XCTAssertEqual(viewModel.savedCity, "London")
        }
    }

    func testMultipleCitySearches() async throws {
        let mockAPIService = MockWeatherAPIService()
        let viewModel = await WeatherViewModel(weatherService: mockAPIService)

        await viewModel.getWeather(for: "New York")
        await MainActor.run {
            XCTAssertEqual(viewModel.weather?.location.name, "New York")
        }

        await viewModel.getWeather(for: "Tokyo")
        await MainActor.run {
            XCTAssertEqual(viewModel.weather?.location.name, "Tokyo")
        }
    }

    func testClearWeatherData() async throws {
        let mockAPIService = MockWeatherAPIService()
        let viewModel = await WeatherViewModel(weatherService: mockAPIService)

        await viewModel.getWeather(for: "Paris")
        await MainActor.run {
            XCTAssertNotNil(viewModel.weather)
        }

        await MainActor.run {
            viewModel.weather = nil
        }

        await MainActor.run {
            XCTAssertNil(viewModel.weather)
        }
    }

    func testWeatherServiceInjection() async throws {
        let mockAPIService = MockWeatherAPIService()
        let viewModel = await WeatherViewModel(weatherService: mockAPIService)

        await viewModel.getWeather(for: "Los Angeles")

        await MainActor.run {
            XCTAssertEqual(viewModel.weather?.location.name, "Los Angeles")
        }
    }

    func testPersistenceOfSavedCityAcrossAppLaunches() async throws {
        let viewModel = await WeatherViewModel()
        await viewModel.saveSelectedCity("Berlin")

        let newViewModel = await WeatherViewModel()
        await newViewModel.loadSavedCity()

        await MainActor.run {
            XCTAssertEqual(newViewModel.savedCity, "Berlin")
        }
    }

    @MainActor func testTemperatureUnitSwitching() {
        let mockWeather = WeatherResponse(
            location: Location(name: "New York"),
            current: CurrentWeather(
                tempC: 20.0,
                tempF: 68.0,
                condition: Condition(text: "Clear", icon: "//cdn.weatherapi.com/weather/64x64/day/113.png"),
                humidity: 50,
                uv: 5.0,
                feelslikeC: 22.0,
                feelslikeF: 71.6,
                isDay: 1
            )
        )

        let viewModelUS = WeatherViewModel(locale: Locale(identifier: "en_US"))
        viewModelUS.weather = mockWeather
        XCTAssertEqual(viewModelUS.preferredTemperature, "68")
        XCTAssertEqual(viewModelUS.preferredFeelsLikeTemperature, "71")

        let viewModelUK = WeatherViewModel(locale: Locale(identifier: "en_GB"))
        viewModelUK.weather = mockWeather
        XCTAssertEqual(viewModelUK.preferredTemperature, "20")
        XCTAssertEqual(viewModelUK.preferredFeelsLikeTemperature, "22")
    }
}
