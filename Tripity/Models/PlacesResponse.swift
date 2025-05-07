//
//  Trip.swift
//  Tripity
//
//  Created by Samuel Kundrát on 05/05/2025.
//

import Foundation

struct PlacesResponse: Codable {
    let type: String
    let features: [Feature]
    
    struct Feature: Codable {
        let properties: Properties
    }
    
    struct Properties: Codable {
        let name: String?
        let website: String?
    }
}

