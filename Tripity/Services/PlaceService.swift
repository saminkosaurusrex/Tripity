//
//  PlaceService.swift
//  Tripity
//
//  Created by Samuel Kundrát on 06/05/2025.
//
import Foundation
import Combine

struct PlaceService{
    private let apiKey = Secret.placesApiKey
    private let baseUrl = "https://api.geoapify.com/v2/places?categories=tourism&filter=circle:"
    func fetchPlaces(forCity city: String, latitude: Double, longitude: Double, radius: Int) -> AnyPublisher<[PlacesResponse.Feature], Error> {
            let urlString = "\(baseUrl)\(longitude),\(latitude),\(radius)&limit=20&apiKey=\(apiKey)"
        
        print(urlString)
            
            guard let url = URL(string: urlString) else {
                return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
            }
            
            return URLSession.shared.dataTaskPublisher(for: url)
                .tryMap { data, response in
                    guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                        throw URLError(.badServerResponse)
                    }
                    return data
                }
                .decode(type: PlacesResponse.self, decoder: JSONDecoder())
                .map { response in
                    response.features
                }
                .eraseToAnyPublisher()
        }
}
