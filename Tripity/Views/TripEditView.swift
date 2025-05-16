//
//  TripEditView.swift
//  Tripity
//
//  Created by Samuel Kundrát on 11/05/2025.
//
import SwiftUI
import SwiftData

struct TripEditView: View {
    @Environment(\.dismiss) private var dismiss
    @Bindable var trip: TripModel
    let weatherService = WeatherService()
    var body: some View {
        NavigationStack {
            Form {
                // date pickers
                Section(header: Text("Dates")) {
                    DatePicker(
                           "Start Date",
                           selection: $trip.startDate,
                           in: Date()..., // od dnes
                           displayedComponents: [.date]
                       )

                       DatePicker(
                           "End Date",
                           selection: $trip.endDate,
                           in: trip.startDate..., // od startDate
                           displayedComponents: [.date]
                       )
                }
                
                // transport selection
                Section(header: Text("Transport")) {
                    Picker("Transport", selection: $trip.transport) {
                        ForEach(TransportMode.allCases) { mode in
                            Text(mode.rawValue)
                                .tag(mode)
                        }
                    }
                    .pickerStyle(.segmented)
                    .padding(.horizontal)
                }
            }
            .navigationTitle("Edit Trip")
            .navigationBarTitleDisplayMode(.inline)
            
            // is start date changes update weather
            .onChange(of: trip.startDate) { oldValue, newValue in
                Task {
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd"
                    let dateString = dateFormatter.string(from: newValue)
                    do {
                        let newWeather = try await weatherService.fetchWeatherAsync(for: trip.coordinate, date: dateString, timeZone: trip.timezone)
                        trip.weather.temperature = newWeather.temperature.getAverageTemperature()
                        trip.weather.conditions = newWeather.getWeatherIcon().rawValue
                    } catch {
                        print("❌ Error fetching weather: \(error)")
                    }
                }
            }
        }
    }
}

