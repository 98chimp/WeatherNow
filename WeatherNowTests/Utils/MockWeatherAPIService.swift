//
//  MockWeatherAPIService.swift
//  WeatherNow
//
//  Created by Shahin Zangenehpour on 2025-01-19.
//

@testable import WeatherNow
import Foundation

class MockWeatherAPIService: WeatherAPIServiceProtocol {
    var shouldFail: Bool

    init(shouldFail: Bool = false) {
        self.shouldFail = shouldFail
    }

    func fetchWeather(for city: String) async throws -> WeatherResponse {
        if shouldFail {
            throw NSError(domain: "WeatherErrorDomain", code: 1, userInfo: nil)
        }
        return WeatherResponse(
            location: Location(name: city),
            current: CurrentWeather(
                tempC: 25.0,
                tempF: 99.0,
                condition: Condition(text: "Sunny", icon: "//cdn.weatherapi.com/weather/64x64/day/113.png"),
                humidity: 40,
                uv: 6.0,
                feelslikeC: 27.0,
                feelslikeF: 102.0,
                isDay: 1
            )
        )
    }
}
