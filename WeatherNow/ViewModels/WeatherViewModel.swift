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
    @Published var selectedWeather: WeatherResponse?
    @Published var isLoading = false
    @Published var errorMessage: String?
    @AppStorage("savedCity") private var savedCity: String = ""

    private let weatherService = WeatherService()

    init() {
        if !savedCity.isEmpty {
            Task {
                await getWeather(for: savedCity)
            }
        }
    }

    func getWeather(for city: String) async {
        isLoading = true
        do {
            let weatherData = try await weatherService.fetchWeather(for: city)
            weather = weatherData
            savedCity = city  // Persisting the city
            errorMessage = nil
        } catch {
            errorMessage = "Failed to fetch weather data"
            weather = nil
        }
        isLoading = false
    }

    func clearWeather() {
        weather = nil
        savedCity = ""
    }
}
