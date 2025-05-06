//
//  TripModel.swift
//  Tripity
//
//  Created by Samuel Kundrát on 05/05/2025.
//

import Foundation

struct TripModel{
    var city: City
    var startDate: Date
    var endDate: Date
    var transport: String
    //var placesToVisit: [Place]
    
//    init(city: City, startDate: Date, endDate: Date, transport: String, placesToVisit: [Place]) {
//            self.city = city
//            self.startDate = startDate
//            self.endDate = endDate
//            self.transport = transport
//            //self.placesToVisit = placesToVisit
//    }
    
    func isValidTrip() -> Bool {
            return startDate < endDate
    }
}
