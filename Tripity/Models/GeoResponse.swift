//  Model for geocoding result
//  GeoResponse.swift
//  Tripity
//
//  Created by Samuel Kundrát on 07/05/2025.
//


struct GeoResponse: Codable {
    let results: [GeocodingResult]
}

struct GeocodingResult: Codable {
    let lat: Double
    let lon: Double
    let county: String
    let state: String
    let city: String
}

