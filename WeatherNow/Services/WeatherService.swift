//
//  WeatherService.swift
//  WeatherNow
//
//  Created by Shahin Zangenehpour on 2025-01-19.
//

import Foundation

struct WeatherService {
    private let apiKey = "9f19524b23314fd485b205122251901"
    private let baseURL = "https://api.weatherapi.com/v1/current.json"

    func fetchWeather(for city: String) async throws -> WeatherResponse {
        let urlString = "\(baseURL)?key=\(apiKey)&q=\(city)"
        guard let url = URL(string: urlString) else {
            throw WeatherError.invalidURL
        }

        let (data, response) = try await URLSession.shared.data(from: url)

        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw WeatherError.invalidResponse
        }

        let decodedData = try JSONDecoder().decode(WeatherResponse.self, from: data)
        return decodedData
    }
}

enum WeatherError: Error {
    case invalidURL
    case invalidResponse
    case decodingError
}
