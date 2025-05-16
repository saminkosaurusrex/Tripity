//  API service for places to visit and
//  PlaceService.swift
//  Tripity
//
//  Created by Samuel Kundrát on 06/05/2025.
//
import Foundation
import Combine

class PlaceService{
    private var cancellables = Set<AnyCancellable>()
    // API KEY
    private let apiKey = Secret.placesApiKey
    // base string for https API request
    private let baseUrl = "https://api.geoapify.com/v2/places?categories=tourism&filter=circle:"
    
    //function to fetch places from api and map them to PlacesResponse Model
    func fetchPlaces(forCity city: String, latitude: Double, longitude: Double, radius: Double) -> AnyPublisher<[PlacesResponse.Feature], Error> {
            let urlString = "\(baseUrl)\(longitude),\(latitude),\(radius)&limit=20&apiKey=\(apiKey)"
        // debug print
        //print(urlString)
            
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
    
    // Async version for sink of fetch
    func fetchPlacesAsync(forCity city: String, latitude: Double, longitude: Double, radius: Double) async throws -> [PlacesResponse.Feature] {
            return try await withCheckedThrowingContinuation { continuation in
                fetchPlaces(forCity: city, latitude: latitude, longitude: longitude, radius: radius)
                    .sink(receiveCompletion: { completion in
                        if case let .failure(error) = completion {
                            continuation.resume(throwing: error)
                        }
                    }, receiveValue: { places in
                        continuation.resume(returning: places)
                    })
                    .store(in: &self.cancellables)
            }
    }
}
