//
//  TripModel.swift
//  Tripity
//
//  Created by Samuel Kundrát on 05/05/2025.
//

import Foundation
import SwiftData

// swift data model for database
@Model
class Trip {
    @Attribute var id: UUID
    @Attribute var destination: String
    @Attribute var transport: String
    @Attribute var radius: Int
    @Attribute var startDate: Date
    @Attribute var endDate: Date
    @Relationship var weather: WeatherModel?
    @Relationship var places: [Place]
    
    // Inicializátor pre Trip
    init(id: UUID = UUID(), destination: String, transport: String, radius: Int, startDate: Date, endDate: Date, weather: WeatherModel? = nil, places: [Place] = []) {
            self.id = id // inicializácia id
            self.destination = destination
            self.transport = transport
            self.radius = radius
            self.startDate = startDate
            self.endDate = endDate
            self.weather = weather
            self.places = places
        }
    
    func isValidTrip() -> Bool {
            return startDate < endDate
    }
}
