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
                            .font(.system(size: 80, weight: .bold))
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
            .background(Color(.systemGray6))
            .cornerRadius(15)
            .padding(.horizontal, 20)
        }
    }
}
