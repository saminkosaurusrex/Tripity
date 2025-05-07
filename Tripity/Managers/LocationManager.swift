//
//  LocationManager.swift
//  Tripity
//
//  Created by Samuel Kundrát on 07/05/2025.
//

import MapKit
import CoreLocation

class LocationManager: NSObject, CLLocationManagerDelegate, ObservableObject {
    private let locationManager = CLLocationManager()
    
    @Published var region = MKCoordinateRegion(
        // default: Bratislava
        center: CLLocationCoordinate2D(latitude: 48.1486, longitude: 17.1077),
        span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
    )
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters // optional, na zlepšenie presnosti
        locationManager.distanceFilter = 10 // optional, len ak sa poloha zmení o viac ako 10 metrov, dostaneš update
        
        // Kontrola, či máš povolenie na používanie polohy
        if CLLocationManager.locationServicesEnabled() {
            locationManager.requestWhenInUseAuthorization() // požiadať o prístup k lokalite
            locationManager.startUpdatingLocation() // začať aktualizovať lokalitu
        } else {
            // Správa o tom, že lokalizačné služby sú vypnuté
            print("Location services are not enabled.")
        }
    }
    
    // Ak sa aktualizuje lokalita, nastaví novú hodnotu pre region
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let newLocation = locations.last else { return }
        
        // Uistíme sa, že aktualizujeme region len keď sa poloha zmení
        if region.center.latitude != newLocation.coordinate.latitude ||
            region.center.longitude != newLocation.coordinate.longitude {
            region = MKCoordinateRegion(
                center: newLocation.coordinate,
                span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
            )
        }
    }
    
    // Handle error if location update fails
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to find user's location: \(error.localizedDescription)")
    }
}

