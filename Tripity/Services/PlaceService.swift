//
//  PlaceService.swift
//  Tripity
//
//  Created by Samuel Kundrát on 06/05/2025.
//
import Foundation
import Combine

class PlaceService{
    private var cancellables = Set<AnyCancellable>()
    private let apiKey = Secret.placesApiKey
    private let baseUrl = "https://api.geoapify.com/v2/places?categories=tourism&filter=circle:"
    func fetchPlaces(forCity city: String, latitude: Double, longitude: Double, radius: Double) -> AnyPublisher<[PlacesResponse.Feature], Error> {
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

struct GeoService {
    private let apiKey = Secret.placesApiKey
    
    func geocode(city: String) -> AnyPublisher<GeoResponse, Error> {
        let urlString = "https://api.geoapify.com/v1/geocode/autocomplete?text=\(city.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")&apiKey=\(apiKey)"
        
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
            .decode(type: GeoResponse.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
}
