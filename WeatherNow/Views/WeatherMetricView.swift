//
//  WeatherMetricView.swift
//  WeatherNow
//
//  Created by Shahin Zangenehpour on 2025-01-19.
//

import SwiftUI

struct WeatherMetricView: View {
    let label: String
    let value: String

    var body: some View {
        VStack {
            Text(label)
                .font(.caption)
                .foregroundColor(.gray)
            Text(value)
                .font(.headline)
                .bold()
                .foregroundColor(.gray)
        }
    }
}

struct WeatherMetricView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            WeatherMetricView(label: "Humidity", value: "50%")
                .previewLayout(.sizeThatFits)
                .padding()
                .previewDisplayName("Humidity")

            WeatherMetricView(label: "UV Index", value: "5.0")
                .previewLayout(.sizeThatFits)
                .padding()
                .previewDisplayName("UV Index")

            WeatherMetricView(label: "Wind Speed", value: "10 km/h")
                .previewLayout(.sizeThatFits)
                .padding()
                .previewDisplayName("Wind Speed")
        }
    }
}
