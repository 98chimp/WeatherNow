//
//  HomeView.swift
//  WeatherNow
//
//  Created by Shahin Zangenehpour on 2025-01-19.
//

import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel = WeatherViewModel()
    @State private var city: String = ""

    var body: some View {
        ZStack {
            // Full-screen white background covering safe areas
            Color.white
                .ignoresSafeArea(.all)

            VStack {
                Spacer(minLength: 50)

                // Search Bar
                HStack {
                    TextField("Search Location", text: $city)
                        .padding(12)
                        .background(Color(.systemGray6))
                        .cornerRadius(10)
                        .overlay(
                            HStack {
                                Spacer()
                                Image(systemName: "magnifyingglass")
                                    .foregroundColor(.gray)
                                    .padding(.trailing, 10)
                            }
                        )
                        .padding(.horizontal, 20)
                }

                Spacer()

                // Empty State
                if viewModel.weather == nil {
                    VStack(spacing: 8) {
                        Text("No City Selected")
                            .font(.system(size: 24, weight: .bold))
                            .foregroundColor(.gray)

                        Text("Please Search For A City")
                            .font(.system(size: 16))
                            .foregroundColor(.secondary)
                    }
                } else {
                    VStack(spacing: 20) {
                        Text(viewModel.weather?.location.name ?? "City Name")
                            .font(.largeTitle)
                            .bold()

                        Text("\(Int(viewModel.weather?.current.temp_c ?? 0))°")
                            .font(.system(size: 80))
                            .bold()

                        AsyncImage(url: URL(string: "https:\(viewModel.weather?.current.condition.icon ?? "")")) { image in
                            image.resizable().scaledToFit()
                        } placeholder: {
                            ProgressView()
                        }
                        .frame(width: 100, height: 100)

                        HStack {
                            Text("Humidity: \(viewModel.weather?.current.humidity ?? 0)%")
                            Text("UV: \(viewModel.weather?.current.uv ?? 0)")
                            Text("Feels like: \(Int(viewModel.weather?.current.feelslike_c ?? 0))°")
                        }
                        .font(.headline)
                        .foregroundColor(.gray)
                        .padding(.horizontal)
                    }
                }

                Spacer()
            }
        }
        .preferredColorScheme(.light)  // Force light mode
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        // Mock ViewModel for preview purposes
        let mockViewModel = WeatherViewModel()

        // Provide sample weather data for preview
        mockViewModel.weather = WeatherResponse(
            location: Location(name: "San Francisco"),
            current: CurrentWeather(
                temp_c: 22.5,
                condition: Condition(text: "Sunny", icon: "//cdn.weatherapi.com/weather/64x64/day/113.png"),
                humidity: 50,
                uv: 5.0,
                feelslike_c: 24.0
            )
        )

        return HomeView()
            .environmentObject(mockViewModel)
            .previewDevice("iPhone 15 Pro")
            .preferredColorScheme(.light)  // Ensures preview uses light mode
    }
}
