//
//  Place.swift
//  Tripity
//
//  Created by Samuel Kundrát on 07/05/2025.
//

import SwiftData

@Model
class Place {
    @Attribute var name: String
    @Attribute var category: String
    @Attribute var websiteURL: String
    @Attribute var isVisited: Bool = false
    
    init(name: String, category: String, websiteURL: String) {
            self.name = name
            self.category = category
            self.websiteURL = websiteURL
        }
}
