//
//  Item.swift
//  WeatherNow
//
//  Created by Shahin Zangenehpour on 2025-01-19.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
