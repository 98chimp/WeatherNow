//
//  WeatherModel.swift
//  WeatherNow
//
//  Created by Shahin Zangenehpour on 2025-01-19.
//

import Foundation

struct WeatherResponse: Codable {
    let location: Location
    let current: CurrentWeather
}

struct Location: Codable {
    let name: String
}

struct CurrentWeather: Codable {
    enum CodingKeys: String, CodingKey {
        case tempC = "temp_c"
        case condition
        case humidity
        case uv
        case feelslikeC = "feelslike_c"
        case isDay = "is_day"
    }

    let tempC: Double
    let condition: Condition
    let humidity: Int
    let uv: Double
    let feelslikeC: Double
    let isDay: Int  // Day or night indicator (1 = day, 0 = night)
}

struct Condition: Codable {
    let text: String
    let icon: String
}
