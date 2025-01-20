//
//  WeatherResponseTests.swift
//  WeatherNowTests
//
//  Created by Shahin Zangenehpour on 2025-01-19.
//

import XCTest
@testable import WeatherNow

class WeatherResponseTests: XCTestCase {

    func testWeatherResponseDecoding() throws {
        let json = """
        {
            "location": {
                "name": "San Francisco"
            },
            "current": {
                "temp_c": 22.5,
                "condition": {
                    "text": "Sunny",
                    "icon": "//cdn.weatherapi.com/weather/64x64/day/113.png"
                },
                "humidity": 50,
                "uv": 5.0,
                "feelslike_c": 24.0,
                "is_day": 1
            }
        }
        """.data(using: .utf8)!

        let decoder = JSONDecoder()
        let decodedWeather = try decoder.decode(WeatherResponse.self, from: json)

        XCTAssertEqual(decodedWeather.location.name, "San Francisco")
        XCTAssertEqual(decodedWeather.current.tempC, 22.5)
        XCTAssertEqual(decodedWeather.current.condition.text, "Sunny")
        XCTAssertEqual(decodedWeather.current.humidity, 50)
        XCTAssertEqual(decodedWeather.current.uv, 5.0)
        XCTAssertEqual(decodedWeather.current.feelslikeC, 24.0)
    }

    func testWeatherResponseWithMissingFields() throws {
        let incompleteJson = """
        {
            "location": {
                "name": "New York"
            }
        }
        """.data(using: .utf8)!

        let decoder = JSONDecoder()

        XCTAssertThrowsError(try decoder.decode(WeatherResponse.self, from: incompleteJson))
    }

    func testInvalidJSONStructure() throws {
        let invalidJson = """
        {
            "location": "San Francisco",
            "current": "invalid structure"
        }
        """.data(using: .utf8)

        do {
            _ = try JSONDecoder().decode(WeatherResponse.self, from: invalidJson!)
            XCTFail("Decoding should have failed for invalid JSON structure")
        } catch {
            XCTAssertTrue(true) // Expected failure
        }
    }

    func testExtremeWeatherValues() throws {
        let edgeCaseJson = """
        {
            "location": {
                "name": "Death Valley"
            },
            "current": {
                "temp_c": 56.7,
                "condition": {
                    "text": "",
                    "icon": "//cdn.weatherapi.com/weather/64x64/day/113.png"
                },
                "humidity": 5,
                "uv": 12.0,
                "feelslike_c": 60.0,
                "is_day": 1
            }
        }
        """.data(using: .utf8)!

        let decoder = JSONDecoder()
        let decodedWeather = try decoder.decode(WeatherResponse.self, from: edgeCaseJson)

        XCTAssertEqual(decodedWeather.location.name, "Death Valley")
        XCTAssertEqual(decodedWeather.current.tempC, 56.7)
        XCTAssertEqual(decodedWeather.current.humidity, 5)
        XCTAssertEqual(decodedWeather.current.uv, 12.0)
        XCTAssertEqual(decodedWeather.current.feelslikeC, 60.0)
        XCTAssertTrue(decodedWeather.current.condition.text.isEmpty)
    }

    func testTemperatureUnitConversion() throws {
        let json = """
        {
            "location": {
                "name": "London"
            },
            "current": {
                "temp_c": 10.0,
                "condition": {
                    "text": "Cloudy",
                    "icon": "//cdn.weatherapi.com/weather/64x64/night/119.png"
                },
                "humidity": 75,
                "uv": 3.0,
                "feelslike_c": 8.0,
                "is_day": 0
            }
        }
        """.data(using: .utf8)!

        let decoder = JSONDecoder()
        let decodedWeather = try decoder.decode(WeatherResponse.self, from: json)

        let tempF = (decodedWeather.current.tempC * 9/5) + 32
        let feelsLikeF = (decodedWeather.current.feelslikeC * 9/5) + 32

        XCTAssertEqual(decodedWeather.location.name, "London")
        XCTAssertEqual(decodedWeather.current.tempC, 10.0)
        XCTAssertEqual(tempF, 50.0)  // Expect 50°F
        XCTAssertEqual(decodedWeather.current.condition.text, "Cloudy")
        XCTAssertEqual(feelsLikeF, 46.4)  // Expect 46.4°F
    }

    func testWeatherResponseWithUnexpectedFormat() async throws {
        let invalidJson = """
        {
            "location": {
                "city_name": "Miami"
            },
            "weather": {
                "temperature": "hot"
            }
        }
        """.data(using: .utf8)!

        do {
            let _ = try JSONDecoder().decode(WeatherResponse.self, from: invalidJson)
            XCTFail("Decoding should have failed for unexpected format")
        } catch {
            XCTAssertTrue(error is DecodingError, "Expected a decoding error")
        }
    }

    func testExtremeTemperatureValues() async throws {
        let extremeJson = """
        {
            "location": {
                "name": "Antarctica"
            },
            "current": {
                "temp_c": -89.2,
                "condition": {
                    "text": "Extremely Cold",
                    "icon": "//cdn.weatherapi.com/weather/64x64/night/248.png"
                },
                "humidity": 0,
                "uv": 0.0,
                "feelslike_c": -100.0,
                "is_day": 0
            }
        }
        """.data(using: .utf8)!

        let decoder = JSONDecoder()
        let decodedWeather = try decoder.decode(WeatherResponse.self, from: extremeJson)

        XCTAssertEqual(decodedWeather.location.name, "Antarctica")
        XCTAssertEqual(decodedWeather.current.tempC, -89.2)
        XCTAssertEqual(decodedWeather.current.feelslikeC, -100.0)
        XCTAssertEqual(decodedWeather.current.humidity, 0)
        XCTAssertEqual(decodedWeather.current.uv, 0.0)
    }
}
