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
    // DEBUG for fonts available in APP build
//    init() {
//        for family in UIFont.familyNames {
//            print("Family: \(family)")
//            for name in UIFont.fontNames(forFamilyName: family) {
//                print("Font name: \(name)")
//            }
//        }
//    }

    var body: some Scene {
        WindowGroup {
                     //ContentView()
                     //WeatherView(placeToVisit: "Paris", date: "2025-05-06", style: .tripCard)
                        PlacesView(city: "Prague",lat: 50.0755, long: 14.4378, radius: 5000)
                 }
    }
}



