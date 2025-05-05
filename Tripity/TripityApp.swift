//
//  TripityApp.swift
//  Tripity
//
//  Created by Samuel Kundrát on 28/04/2025.
//

import SwiftUI
import SwiftData

@main
struct TripityApp: App {
    var body: some Scene {
        WindowGroup {
            WeatherView(placeToVisit: "New York", date: "2025-05-06", style: .tripCard)
        }
    }
}


