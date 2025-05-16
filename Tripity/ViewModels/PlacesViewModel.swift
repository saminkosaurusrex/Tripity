////  ViewModel for places to visit
////  PlacesViewModel.swift
////  Tripity
////
////  Created by Samuel Kundrát on 06/05/2025.
////
//
//import Foundation
//import Combine
//class PlacesViewModel: ObservableObject {
//    @Published var places: [PlacesResponse.Feature] = []
//    @Published var isLoading: Bool = false
//    @Published var error: Error?
//    private var cancellables = Set<AnyCancellable>()
//    
//    private let service = PlaceService()
//    
//    func fetchPlaces(forCity city: String, latitude: Double, longitude: Double, radius: Double) {
//        isLoading = true
//        service.fetchPlaces(forCity: city, latitude: latitude, longitude: longitude, radius: radius)
//            .receive(on: DispatchQueue.main)
//            .sink(receiveCompletion: { completion in
//                if case let .failure(error) = completion {
//                    self.error = error
//                }
//                self.isLoading = false
//            }, receiveValue: { [weak self] places in
//                self?.places = places
//                self?.isLoading = false
//            })
//            .store(in: &cancellables)
//    }
//}
//
