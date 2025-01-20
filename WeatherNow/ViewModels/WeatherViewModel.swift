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
    @Published var savedCity: String?
    @Published var errorMessage: String?

    private let weatherService: WeatherAPIServiceProtocol
    private let userDefaultsKey = "selectedCity"

    init(weatherService: WeatherAPIServiceProtocol = WeatherAPIService()) {
        self.weatherService = weatherService
        loadSavedCity()
    }

    /// Fetches weather for the given city asynchronously
    func getWeather(for city: String) async {
        do {
            let response = try await weatherService.fetchWeather(for: city)
            DispatchQueue.main.async {
                self.weather = response
                self.errorMessage = nil
                self.saveSelectedCity(city)
            }
        } catch {
            DispatchQueue.main.async {
                self.weather = nil
                self.errorMessage = "Failed to fetch weather for \(city)"
            }
        }
    }

    /// Saves the selected city to UserDefaults
    func saveSelectedCity(_ city: String) {
        UserDefaults.standard.set(city, forKey: userDefaultsKey)
        savedCity = city
    }

    /// Loads the saved city from UserDefaults
    func loadSavedCity() {
        if let city = UserDefaults.standard.string(forKey: userDefaultsKey) {
            savedCity = city
            Task {
                await getWeather(for: city)
            }
        }
    }

    /// Clears the saved city from UserDefaults
    func clearSavedCity() {
        UserDefaults.standard.removeObject(forKey: userDefaultsKey)
        savedCity = nil
        weather = nil
    }
}
