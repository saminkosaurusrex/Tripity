//
//  TripModel.swift
//  Tripity
//
//  Created by Samuel Kundrát on 05/05/2025.
//

import Foundation
import SwiftData
import CoreLocation

@Model
class TripModel {
    @Attribute var destination: String
    @Attribute var transport: String
    @Attribute var startDate: Date
    @Attribute var endDate: Date
    @Relationship var weather: WeatherModel
    @Relationship var places: [Place]
    @Attribute var latitude: Double
    @Attribute var longtitude: Double
    @Attribute var timezone: String

    init(destination: String, transport: String, startDate: Date, endDate: Date, weather: WeatherModel, places: [Place], latitude: Double, longtitude: Double, timezone: String) {
        self.destination = destination
        self.transport = transport
        self.startDate = startDate
        self.endDate = endDate
        self.weather = weather
        self.places = places
        self.latitude = latitude
        self.longtitude = longtitude
        self.timezone = timezone
    }
    
    // compoted property for location
    var coordinate: CLLocationCoordinate2D {
            CLLocationCoordinate2D(latitude: latitude, longitude: longtitude)
    }
}
