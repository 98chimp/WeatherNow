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
    private let locale: Locale

    init(weatherService: WeatherAPIServiceProtocol = WeatherAPIService(), locale: Locale = .current) {
        self.weatherService = weatherService
        self.locale = locale
    }

    func getWeather(for city: String) async {
        do {
            let response = try await weatherService.fetchWeather(for: city)
            DispatchQueue.main.async {
                self.weather = response
                self.errorMessage = nil
            }
        } catch {
            DispatchQueue.main.async {
                self.weather = nil
                self.errorMessage = "Failed to fetch weather"
            }
        }
    }

    func saveSelectedCity(_ city: String) {
        UserDefaults.standard.set(city, forKey: userDefaultsKey)
    }

    func loadSavedCity() {
        if let city = UserDefaults.standard.string(forKey: userDefaultsKey) {
            savedCity = city
        }
    }

    func clearSavedCity() {
        UserDefaults.standard.removeObject(forKey: userDefaultsKey)
        savedCity = nil
    }

    // Function to determine temperature unit
    var preferredTemperature: String {
        guard let weather = weather else { return "--" }
        if locale.measurementSystem == .us {
            return "\(Int(weather.current.tempF))"
        } else {
            return "\(Int(weather.current.tempC))"
        }
    }

    var preferredFeelsLikeTemperature: String {
        guard let weather = weather else { return "--" }
        if locale.measurementSystem == .us {
            return "\(Int(weather.current.feelslikeF))"
        } else {
            return "\(Int(weather.current.feelslikeC))"
        }
    }
}
