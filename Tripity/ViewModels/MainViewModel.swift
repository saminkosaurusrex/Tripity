//
//  MainViewModel.swift
//  Tripity
//
//  Created by Samuel Kundrát on 10/05/2025.
//

import Foundation
import SwiftData
import Combine

@MainActor
class MainViewModel: ObservableObject {
    @Published var trips: [TripModel] = []

    private let context: ModelContext

    init(context: ModelContext) {
        self.context = context
    }

    func loadTrips() {
        do {
            let descriptor = FetchDescriptor<TripModel>(sortBy: [SortDescriptor(\.startDate, order: .reverse)])
            self.trips = try context.fetch(descriptor)
        } catch {
            print("Failed to fetch trips: \(error)")
        }
    }
}
