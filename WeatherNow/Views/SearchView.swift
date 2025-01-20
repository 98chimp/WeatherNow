//
//  SearchView.swift
//  WeatherNow
//
//  Created by Shahin Zangenehpour on 2025-01-19.
//

import SwiftUI

struct SearchView: View {
    @State private var searchText = ""
    @StateObject private var viewModel = WeatherViewModel()

    var body: some View {
        VStack {
            TextField("Search city", text: $searchText, onCommit: {
                Task {
                    await viewModel.getWeather(for: searchText)
                }
            })
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .padding()

            if let weather = viewModel.weather {
                VStack {
                    Text(weather.location.name)
                        .font(.title)
                    Text("\(weather.current.temp_c, specifier: "%.1f")°")
                        .font(.largeTitle)
                }
            }
        }
        .padding()
    }
}
