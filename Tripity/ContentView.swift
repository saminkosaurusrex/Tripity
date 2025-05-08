//
//  ContentView.swift
//  Tripity
//
//  Created by Samuel Kundrát on 28/04/2025.
//
import SwiftUI

struct ContentView: View {
    @EnvironmentObject var tripDraft: TripDraft
    var body: some View {
        NavigationStack {
            MainView()
        }
    }
}

#Preview {
    ContentView()
}
