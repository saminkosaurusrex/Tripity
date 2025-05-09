//
//  TripModel.swift
//  Tripity
//
//  Created by Samuel Kundrát on 05/05/2025.
//

import Foundation
import SwiftData

@Model
class TripModel {
    @Attribute var destination: String
    @Attribute var transport: String
    @Attribute var startDate: Date
    @Attribute var endDate: Date
    @Relationship var weather: WeatherModel
    @Relationship var places: [Place]

    init(destination: String, transport: String, startDate: Date, endDate: Date, weather: WeatherModel, places: [Place]) {
        self.destination = destination
        self.transport = transport
        self.startDate = startDate
        self.endDate = endDate
        self.weather = weather
        self.places = places
    }
}
