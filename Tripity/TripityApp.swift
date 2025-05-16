//
//  TripityApp.swift
//  Tripity
//
//  Created by Samuel Kundrát on 07/05/2025.
//

import SwiftUI
import SwiftData

@main
struct TripityApp: App {
    // Create a SwiftData model container
    let modelContainer: ModelContainer
    
    // Shared instance of TripDraft for the app
    @StateObject private var tripDraft = TripDraft()
    
    init() {
        do {
            // Configure the model container with all required model types
            modelContainer = try ModelContainer(for: TripModel.self, WeatherModel.self, Place.self)
        } catch {
            fatalError("Failed to create ModelContainer: \(error)")
        }
    }
    
    var body: some Scene {
        WindowGroup {
            MainView()
                .environmentObject(tripDraft)
        }
        .modelContainer(modelContainer)
    }
}
