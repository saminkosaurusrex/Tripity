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
    @StateObject private var tripDraft = TripDraft()
    var body: some Scene {
        WindowGroup {
            // Priradíme tripDraft ako environmentObject pre ContentView
            ContentView()
                .environmentObject(tripDraft)
        }
    }
}



