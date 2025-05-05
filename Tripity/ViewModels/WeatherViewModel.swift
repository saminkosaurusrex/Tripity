//
//  WeatherViewModel.swift
//  Tripity
//
//  Created by Samuel Kundrát on 05/05/2025.
//
import Foundation
import Combine
import CoreLocation
class WeatherViewModel: ObservableObject {
    @Published var weather: WeatherResponse?
    @Published var isLoading = false
    @Published var error: Error?
    
    private var cancellables = Set<AnyCancellable>()
    private let service = WeatherService()
    
    func loadWeather(for city: String, date: String) {
            service.getCoordinates(for: city)
                .flatMap { coordinate, timeZone in
                    self.service.fetchWeather(for: coordinate, date: date, timeZone: timeZone)
                }
                .receive(on: DispatchQueue.main)
                .sink(receiveCompletion: { completion in
                    if case let .failure(error) = completion {
                        self.error = error
                    }
                }, receiveValue: { weather in
                    self.weather = weather
                })
                .store(in: &cancellables)
        }
}
