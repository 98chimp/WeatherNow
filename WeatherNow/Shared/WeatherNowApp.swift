//
//  WeatherNowApp.swift
//  WeatherNow
//
//  Created by Shahin Zangenehpour on 2025-01-19.
//

import SwiftUI

@main
struct WeatherNowApp: App {
    @StateObject private var viewModel: WeatherViewModel

    init() {
        _viewModel = StateObject(wrappedValue: WeatherViewModel())
    }

    var body: some Scene {
        WindowGroup {
            HomeView()
                .environmentObject(viewModel)
        }
    }
}
