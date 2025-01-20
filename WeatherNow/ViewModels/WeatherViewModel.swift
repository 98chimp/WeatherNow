//
//  WeatherViewModel.swift
//  WeatherNow
//
//  Created by Shahin Zangenehpour on 2025-01-19.
//

import SwiftUI

@MainActor
class WeatherViewModel: ObservableObject {
    @Published var weather: WeatherResponse?
    @Published var isLoading = false
    @Published var errorMessage: String?

    private let weatherService = WeatherService()

    func getWeather(for city: String) async {
        isLoading = true
        do {
            weather = try await weatherService.fetchWeather(for: city)
            errorMessage = nil
        } catch {
            errorMessage = "Failed to fetch weather data"
        }
        isLoading = false
    }
}
