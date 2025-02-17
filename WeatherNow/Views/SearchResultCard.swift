//
//  SearchResultCard.swift
//  WeatherNow
//
//  Created by Shahin Zangenehpour on 2025-01-19.
//

import SwiftUI

struct SearchResultCard: View {
    let weather: WeatherResponse
    let onSelect: () -> Void

    var body: some View {
        Button(action: onSelect) {
            HStack {
                VStack(alignment: .leading, spacing: 10) {
                    Text(weather.location.name)
                        .font(.title2)
                        .bold()
                        .foregroundColor(.black)
                        .padding(.leading, 16)
                        .padding(.top, 12)

                    HStack(alignment: .top, spacing: 0) {
                        Text("\(Int(weather.current.tempC))")
                            .font(.system(size: 60, weight: .bold))
                            .foregroundColor(.black)

                        Text("˚")
                            .font(.system(size: 40, weight: .light))
                            .foregroundColor(.black)
                            .baselineOffset(-10)
                    }
                    .padding(.leading, 16)
                }

                Spacer()

                AsyncImage(url: URL(string: "https:\(weather.current.condition.icon)")) { image in
                    image.resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(maxHeight: 80)
                        .padding(.trailing, 16)
                        .padding(.vertical, 12)
                } placeholder: {
                    ProgressView()
                }
            }
            .padding(.vertical, 12)
            .background(Color.customGray)
            .cornerRadius(15)
            .padding(.horizontal, 20)
        }
        .accessibilityElement(children: .contain)
        .accessibilityIdentifier("SearchResultCard")
    }
}

struct SearchResultCard_Previews: PreviewProvider {
    static var previews: some View {
        SearchResultCard(
            weather: WeatherResponse(
                location: Location(name: "San Francisco"),
                current: CurrentWeather(
                    tempC: 22.5,
                    tempF: 72.5,
                    condition: Condition(
                        text: "Sunny",
                        icon: "//cdn.weatherapi.com/weather/64x64/day/113.png"
                    ),
                    humidity: 50,
                    uv: 5.0,
                    feelslikeC: 24.0,
                    feelslikeF: 75.2,
                    isDay: 1
                )
            ),
            onSelect: {
                print("Search result tapped")
            }
        )
        .previewLayout(.sizeThatFits)
    }
}
