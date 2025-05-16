//  Model for weather for each trip
//  WeatherModel.swift
//  Tripity
//
//  Created by Samuel Kundrát on 08/05/2025.
//
import SwiftData
import Foundation
@Model
class WeatherModel {
    @Attribute var temperature: Double
    //holds string for icon
    @Attribute var conditions: String
    @Attribute var lastUpdated: Date
    
    init(temperature: Double, conditions: String) {
        self.temperature = temperature
        self.conditions = conditions
        self.lastUpdated = Date()
    }
}
