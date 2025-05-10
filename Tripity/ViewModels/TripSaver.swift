//
//  TripSaveViewModel.swift
//  Tripity
//
//  Created by Samuel Kundrát on 09/05/2025.
//

import Foundation
import SwiftData
import CoreLocation

@MainActor
struct TripSaver {
    
    
    static func save(from draft: TripDraft, modelContext: ModelContext) async throws -> TripModel {
        // 1. Fetch weather
        let coordinate = CLLocationCoordinate2D(latitude: draft.latitude, longitude: draft.longtitude)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dateString = dateFormatter.string(from: draft.startDate ?? Date())
        let weatherService = WeatherService()
        let weather = try await weatherService.fetchWeatherAsync(
            for: coordinate,
            date: dateString,
            timeZone: formattedTimeZoneOffset()
        )

        let avgTemp = weather.getAverageTemperature()
        let icon = weather.getWeatherIcon().rawValue
        let weatherModel = WeatherModel(temperature: avgTemp, conditions: icon)
        modelContext.insert(weatherModel)
        
        print("🌤 WeatherModel — temperature: \(weatherModel.temperature)°, conditions: \(weatherModel.conditions)")
        dump(weatherModel)

        // 2. Fetch places
        let placeService = PlaceService()
        let fetchedPlaces = try await placeService.fetchPlacesAsync(
            forCity: draft.destination,
            latitude: draft.latitude,
            longitude: draft.longtitude,
            radius: draft.radius
        )

        let placeModels = fetchedPlaces.map {
            Place(name: $0.properties.name ?? "Unknown", category: "sight", websiteURL: $0.properties.website ?? "")
        }
        for (index, place) in placeModels.enumerated() {
            print("📍 Place \(index): name = \(place.name), category = \(place.category), website = \(place.websiteURL)")
        }
        placeModels.forEach { modelContext.insert($0) }

        // 3. Vytvor TripModel
        let trip = TripModel(
            destination: draft.destination,
            transport: draft.transport.rawValue,
            startDate: draft.startDate ?? Date(),
            endDate: draft.endDate ?? Date(),
            weather: weatherModel,
            places: placeModels
        )
        modelContext.insert(trip)

        // 4. Save to SwiftData
        try modelContext.save()
        return trip
    }
    
    static func formattedTimeZoneOffset() -> String {
        let seconds = TimeZone.current.secondsFromGMT()
        let sign = seconds >= 0 ? "+" : "-"
        let absSeconds = abs(seconds)
        let hours = absSeconds / 3600
        let minutes = (absSeconds % 3600) / 60
        return String(format: "%@%02d:%02d", sign, hours, minutes)
    }
}
