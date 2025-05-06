//
//  WeatherService.swift
//  Tripity
//
//  Created by Samuel Kundrát on 05/05/2025.
//

import Foundation
import Combine
import CoreLocation

class WeatherService {
    // weather API key
    private let apiKey = Secret.openWeatherAPIKey
    
    // Returns latitude and longitude for a location
    func getCoordinates(for city: String) -> AnyPublisher<(CLLocationCoordinate2D, String), Error> {
        Future { promise in
            CLGeocoder().geocodeAddressString(city) { placemarks, error in
                if let error = error {
                    promise(.failure(WeatherServiceError.geocodingError(error.localizedDescription)))
                } else if let placemark = placemarks?.first,
                          let coordinate = placemark.location?.coordinate,
                          let timeZone = placemark.timeZone {
                    // Get the time zone offset in seconds
                    let timeZoneOffset = timeZone.secondsFromGMT()
                    
                    // Convert seconds to HH:mm format
                    let hours = abs(timeZoneOffset) / 3600
                    let minutes = (abs(timeZoneOffset) % 3600) / 60
                    let sign = timeZoneOffset >= 0 ? "+" : "-"
                    let timeZoneString = String(format: "%@%02d:%02d", sign, hours, minutes)
                    
                    promise(.success((coordinate, timeZoneString)))
                } else {
                    promise(.failure(WeatherServiceError.noLocationFound))
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    // Fetches weather data from API
    func fetchWeather(for coordinate: CLLocationCoordinate2D, date: String, timeZone: String) -> AnyPublisher<WeatherResponse, Error> {
        // URL composition
        print("lati: \(coordinate.latitude) longi: \(coordinate.longitude) date: \(date) apiKey: \(apiKey) timezone: \(timeZone)")
        //tz MUST be in url
        let urlString = "https://api.openweathermap.org/data/3.0/onecall/day_summary?lat=\(coordinate.latitude)&lon=\(coordinate.longitude)&date=\(date)&tz=\(timeZone)&appid=\(apiKey)&units=metric"
        
        print(urlString)
        //https://api.openweathermap.org/data/3.0/onecall/day_summary?lat={lat}&lon={lon}&date={date}&appid={API key}
        
        guard let url = URL(string: urlString) else {
            return Fail(error: WeatherServiceError.invalidURL).eraseToAnyPublisher()
        }
        
        // Fetch and decode weather data
        return URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: WeatherResponse.self, decoder: JSONDecoder())
            .mapError { error in
                WeatherServiceError.apiError(error.localizedDescription)
            }
            .eraseToAnyPublisher()
    }
}

// Error handling
enum WeatherServiceError: Error {
    case invalidURL
    case noData
    case geocodingError(String)
    case noLocationFound
    case apiError(String)
}

