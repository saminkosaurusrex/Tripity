//
//  Secret.swift
//  Tripity
//
//  Created by Samuel Kundrát on 06/05/2025.
//

import Foundation

// struct for weather API from secrets
struct Secret {
    static var openWeatherAPIKey: String {
        guard let path = Bundle.main.path(forResource: "Secrets", ofType: "plist"),
              let xml = FileManager.default.contents(atPath: path),
              let plist = try? PropertyListSerialization.propertyList(from: xml, format: nil) as? [String: Any],
              let key = plist["OPEN_WEATHER_API_KEY"] as? String else {
            fatalError("Missing OPEN_WEATHER_API_KEY in Secrets.plist")
        }
        return key
    }
}
