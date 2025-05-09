////
////  TripService.swift
////  Tripity
////
////  Created by Samuel Kundrát on 09/05/2025.
////
//import SwiftUI
//import Foundation
//class TripService {
//    static let shared = TripService()
//    
//    func createTrip(from draft: TripDraft) async throws -> Trip {
//        // 1. Validuj vstup
//        guard let location = draft.destination,
//              let startDate = draft.startDate,
//              let endDate = draft.endDate else {
//            throw TripError.missingData
//        }
//
//        // 2. Zavolaj WeatherService a PlaceService
//        let weather = try await WeatherService.shared.fetchWeather(for: location, start: startDate, end: endDate)
//        let places = try await PlaceService.shared.fetchPlaces(for: location)
//
//        // 3. Vytvor model Trip
//        let trip = Trip(
//            locationName: location,
//            startDate: startDate,
//            endDate: endDate,
//            weather: weather,
//            places: places
//        )
//
//        // 4. Ulož do SwiftData
//        try TripStorage.shared.save(trip)
//
//        return trip
//    }
//}
//
