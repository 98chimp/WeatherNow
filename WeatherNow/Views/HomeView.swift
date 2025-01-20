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
    @State private var showSearchResults = false

    var body: some View {
        ZStack {
            VStack {
                // Search Bar
                HStack {
                    TextField("Search Location", text: $city, onCommit: {
                        Task {
                            await viewModel.getWeather(for: city)
                            showSearchResults = true
                        }
                    })
                    .accessibilityIdentifier("SearchField")
                    .padding(12)
                    .background(Color(.systemGray6))
                    .cornerRadius(15)
                    .overlay(
                        HStack {
                            Spacer()
                            Image(systemName: "magnifyingglass")
                                .foregroundColor(.gray)
                                .padding(.trailing, 10)
                        }
                    )
                    .padding(.horizontal, 20)
                    .accessibilityIdentifier("SearchField")
                }

                if let errorMessage = viewModel.errorMessage {
                    Text(errorMessage)
                        .font(.body)
                        .foregroundColor(.red)
                        .accessibilityIdentifier("ErrorMessageLabel")
                        .padding(.top, 10)
                        .transition(.opacity)
                        .onAppear {
                            triggerErrorDismissal()
                            city = ""
                        }
                }

                if showSearchResults {
                    if let weather = viewModel.weather {
                        SearchResultCard(weather: weather, onSelect: {
                            viewModel.selectedWeather = weather
                            city = ""
                            showSearchResults = false
                        })
                    } else {
                        Spacer()
                        Text("No results found")
                            .font(.title2)
                            .foregroundColor(.gray)
                        Spacer()
                    }
                } else if viewModel.weather == nil {
                    Spacer()

                    VStack(spacing: 8) {
                        Text("No City Selected")
                            .font(.system(size: 24, weight: .bold))
                            .foregroundColor(.black)

                        Text("Please Search For A City")
                            .font(.system(size: 16))
                            .foregroundColor(.secondary)
                    }

                    Spacer()
                } else {
                    VStack(spacing: 15) {
                        AsyncImage(url: URL(string: getWeatherIconUrl())) { image in
                            image.resizable().scaledToFit()
                        } placeholder: {
                            ProgressView()
                        }
                        .frame(width: 150, height: 150)

                        HStack(spacing: 5) {
                            Text(viewModel.weather?.location.name ?? "City Name")
                                .font(.system(size: 32, weight: .bold))
                                .foregroundColor(.black)
                                .accessibilityIdentifier("CityNameLabel")

                            Image(systemName: "location.fill")
                                .foregroundColor(.black)
                                .font(.title2)
                        }

                        HStack(alignment: .top, spacing: 0) {
                            Text(viewModel.preferredTemperature)
                                .font(.system(size: 80, weight: .bold))
                                .foregroundColor(.black)
                                .accessibilityIdentifier("TemperatureLabel")

                            Text("˚")
                                .font(.system(size: 40, weight: .bold))
                                .foregroundColor(.black)
                                .baselineOffset(-10)
                        }

                        HStack(spacing: 30) {
                            WeatherMetricView(label: "Humidity", value: "\(viewModel.weather?.current.humidity ?? 0)%")
                            Spacer()
                            WeatherMetricView(label: "UV", value: "\(Int(viewModel.weather?.current.uv ?? 0))")
                            Spacer()
                            WeatherMetricView(label: "Feels Like", value: viewModel.preferredFeelsLikeTemperature)
                        }
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(16)
                        .padding(.horizontal, 20)
                    }
                    .padding(.top, 30)
                    .accessibilityIdentifier("WeatherInfoSection")
                }

                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding(.bottom, 50)
        }
        .preferredColorScheme(.light)
    }

    private func triggerErrorDismissal() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            withAnimation {
                viewModel.errorMessage = nil
            }
        }
    }

    func getWeatherIconUrl() -> String {
        guard let weather = viewModel.weather else { return "" }

        let baseIconURL = "https:" + weather.current.condition.icon

        if weather.current.isDay == 1 {
            // Return day icon by replacing 'night' with 'day' in the URL if it exists
            return baseIconURL.replacingOccurrences(of: "night", with: "day")
        } else {
            // Return night icon by replacing 'day' with 'night' in the URL if it exists
            return baseIconURL.replacingOccurrences(of: "day", with: "night")
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        let mockViewModel = WeatherViewModel()

        DispatchQueue.main.async {
            mockViewModel.weather = WeatherResponse(
                location: Location(name: "San Francisco"),
                current: CurrentWeather(
                    tempC: 22.5,
                    tempF: 58.0,
                    condition: Condition(text: "Sunny", icon: "//cdn.weatherapi.com/weather/64x64/day/113.png"),
                    humidity: 50,
                    uv: 5.0,
                    feelslikeC: 24.0,
                    feelslikeF: 98.0,
                    isDay: 1
                )
            )
        }

        return HomeView()
            .environmentObject(mockViewModel)
            .previewDevice("iPhone 15 Pro")
            .preferredColorScheme(.light)
    }
}
