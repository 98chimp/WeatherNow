//
//  WeatherNowApp.swift
//  WeatherNow
//
//  Created by Shahin Zangenehpour on 2025-01-19.
//

import SwiftUI
import SwiftData

@main
struct WeatherNowApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Item.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            print("Failed to create ModelContainer: \(error.localizedDescription)")
            return try! ModelContainer(for: schema, configurations: [])  // Provide a fallback if needed
        }
    }()

    var body: some Scene {
        WindowGroup {
            HomeView()
        }
        .modelContainer(sharedModelContainer)
    }
}
