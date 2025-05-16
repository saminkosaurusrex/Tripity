//  Data model for City object
//  City.swift
//  Tripity
//
//  Created by Samuel Kundrát on 06/05/2025.
//
import Foundation
struct City: Identifiable, Hashable, Codable {
    var id = UUID()
    var name: String
    var latitude: Double
    var longitude: Double
}
