//  Model for API response from weather API
//  Weather.swift
//  Tripity
//
//  Created by Samuel Kundrát on 05/05/2025.
//

import Foundation

// Model for weather API parsing
struct WeatherResponse: Codable {
    let temperature: Temperature
    let cloudCover: CloudCover
    let humidity: Humidity
    let precipitation: Precipitation
    let wind: Wind
    
    // mapper for JSON
    enum CodingKeys: String, CodingKey {
        case temperature
        case cloudCover = "cloud_cover"
        case humidity
        case precipitation
        case wind
    }
}

struct Temperature: Codable {
    let min: Double
    let max: Double
    let afternoon: Double
    let night: Double
    let evening: Double
    let morning: Double
    
    func getAverageTemperature() -> Double {
        return (min + max) / 2
    }
}

struct CloudCover: Codable {
    let afternoon: Double
}

struct Humidity: Codable {
    let afternoon: Double
}

struct Precipitation: Codable {
    let total: Double
}

struct Wind: Codable {
    let max: WindSpeed
}

struct WindSpeed: Codable {
    let speed: Double
    let direction: Double
}

extension WeatherResponse{
    enum WeatherIcon: String {
            case sunny = "sun.max"
            case cloudy = "cloud"
            case rainy = "cloud.rain"
            case windy = "wind"
    }
    
    func getWeatherIcon() -> WeatherIcon {
            if temperature.afternoon > 23 {
                return .sunny
            }
            if cloudCover.afternoon > 50 {
                return .cloudy
            }
            if precipitation.total > 50 {
                return .rainy
            }
            if wind.max.speed > 10 {
                return .windy
            }
        return .sunny
    }
    
    func getAverageTemperature() -> Double {
        return temperature.getAverageTemperature()
    }
}
