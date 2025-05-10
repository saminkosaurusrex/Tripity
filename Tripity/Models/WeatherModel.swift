//
//  WeatherModel.swift
//  Tripity
//
//  Created by Samuel Kundrát on 08/05/2025.
//
import SwiftData
@Model
class WeatherModel {
    @Attribute var temperature: Double
    //holds string for icon as well
    @Attribute var conditions: String
    
    // Inicializátor pre WeatherModel
    init(temperature: Double, conditions: String) {
        self.temperature = temperature
        self.conditions = conditions
    }
}
