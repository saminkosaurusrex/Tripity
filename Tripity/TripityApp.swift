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
    let container = try! ModelContainer(
            for: Place.self,
                 WeatherModel.self,
                 TripModel.self
        )
    @StateObject private var tripDraft = TripDraft()
    var body: some Scene {
        WindowGroup {
            // Priradíme tripDraft ako environmentObject pre ContentView
            ContentView()
                .environmentObject(tripDraft)
        }
    }
}



