//
//  TripDraft.swift
//  Tripity
//
//  Created by Samuel Kundrát on 08/05/2025.
//

import Foundation
import SwiftUI

class TripDraft: ObservableObject {
    @Published var destination: String = ""
    @Published var transport: TransportMode = .car
    @Published var radius: Double = 2000
    @Published var startDate: Date?
    @Published var endDate: Date?
    @Published var weather: WeatherModel?
    @Published var places: [Place] = []
    // set for Brno Czech republic
    @Published var longtitude: Double = 49.19522
    @Published var latitude: Double = 16.60796
}
