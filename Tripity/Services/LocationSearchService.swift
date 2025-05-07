//
//  LocationSearchService.swift
//  Tripity
//
//  Created by Samuel Kundrát on 07/05/2025.
//

import Foundation
import MapKit

@Observable
class LocationSearchService: NSObject, ObservableObject{
    var query: String = ""{
        didSet{
            handleSearchFragment(query)
        }
    }
    
    var results: [LocationResult] = []
    var status: searchStatus = .idle
    var completer: MKLocalSearchCompleter
    var selectedCity: City? = nil
    
    init(filter: MKPointOfInterestFilter = .excludingAll,
         region: MKCoordinateRegion = MKCoordinateRegion(.world),
         types: MKLocalSearchCompleter.ResultType = [.pointOfInterest, .query, .address, .address]){
        completer = MKLocalSearchCompleter()
        super.init( )
        completer.delegate = self
        completer.pointOfInterestFilter = filter
        completer.region = region
        completer.resultTypes = types
    }
    
    private func handleSearchFragment(_ fragment: String){
        self.status = .searching
        if(!fragment.isEmpty){
            self.completer.queryFragment = fragment
        }else{
            self.status = .idle
            self.results = []
        }
    }
    
    func searchLocation(from result: LocationResult, completion: @escaping (MKMapItem?) -> Void) {
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = result.title + " " + result.subtitle
        let search = MKLocalSearch(request: request)

        search.start { response, error in
            if let item = response?.mapItems.first {
                let coordinate = item.placemark.coordinate
                self.selectedCity = City(
                    name: item.name ?? result.title,
                    latitude: coordinate.latitude,
                    longitude: coordinate.longitude
                )
                completion(item)
            } else {
                self.selectedCity = nil
                completion(nil)
            }
        }
    }
    
}

extension LocationSearchService: MKLocalSearchCompleterDelegate{
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        self.results = completer.results
            .map({result in
                LocationResult(title: result.title, subtitle: result.subtitle)
            })
        self.status = .result
    }
    
    func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: any Error) {
        self.status = .error(error.localizedDescription)
    }
}

struct LocationResult: Identifiable, Hashable {
    var id =  UUID()
    var title: String
    var subtitle: String
}

enum searchStatus: Equatable{
    case idle
    case searching
    case result
    case error(String)
}
