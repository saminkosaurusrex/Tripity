//
//  TripDetail.swift
//  Tripity
//
//  Created by Samuel Kundrát on 09/05/2025.
//

import SwiftUI
import MapKit
import SwiftData
import CoreLocation

struct TripDetail: View {
    let trip: TripModel
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss
    
    @State private var isEditing = false
    @State private var showDeleteConfirmation = false
    @State private var showDeletedAlert = false
    @State private var isUpdatingWeather = false
    @State private var weatherUpdateError: String? = nil
    @State private var showWeatherAlert = false

    private var compactDateFormatter: DateFormatter {
        let df = DateFormatter()
        df.dateFormat = "d. MMMM yyyy"
        return df
    }
    
    // Check if weather data is outdated (more than 3 hours old)
    private var isWeatherOutdated: Bool {
        let threeHoursAgo = Date().addingTimeInterval(-10800) // 3 hours in seconds
        return trip.weather.lastUpdated < threeHoursAgo
    }
    
    var body: some View {
        ZStack {
            Color.background.ignoresSafeArea()

            VStack {
                Text(trip.destination)
                    .font(.custom("SourceSerif4-Regular", size: 55))
                    .foregroundColor(.black)
                    .lineLimit(1)
                    .minimumScaleFactor(0.7)

                HStack(spacing: 0) {
                    HStack {
                        Text("\(String(format: "%.0f", trip.weather.temperature))°C")
                            .font(.custom("SourceSerif4-Regular", size: 40))
                            .lineLimit(1)
                            .minimumScaleFactor(0.5)

                        Spacer()

                        Image(systemName: trip.weather.conditions)
                            .font(.custom("SourceSerif4-Regular", size: 40))
                            .lineLimit(1)
                            .minimumScaleFactor(0.5)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.horizontal, 10)
                    .padding(.trailing, 3)
                    .overlay(
                        Rectangle()
                            .frame(width: 3)
                            .foregroundColor(.black),
                        alignment: .trailing
                    )

                    VStack {
                        Text("\(compactDateFormatter.string(from: trip.startDate))")
                            .font(.custom("SourceSerif4-Regular", size: 40))
                            .lineLimit(1)
                            .minimumScaleFactor(0.5)

                        Text("\(compactDateFormatter.string(from: trip.endDate))")
                            .font(.custom("SourceSerif4-Regular", size: 40))
                            .lineLimit(1)
                            .minimumScaleFactor(0.5)
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                }
                .padding(.vertical, 4)
                .overlay(
                    VStack {
                        Rectangle()
                            .frame(height: 3)
                        Spacer()
                        Rectangle()
                            .frame(height: 3)
                    }
                    .foregroundColor(.black)
                )
                
                // Weather update information and refresh button
                HStack {
                    Text("Weather updated: \(formattedWeatherUpdateTime)")
                        .font(.custom("SourceSerif4-Regular", size: 12))
                        .foregroundColor(.gray)
                    
                    Spacer()
                    
                    Button(action: {
                        Task {
                            await updateWeather()
                        }
                    }) {
                        Image(systemName: isUpdatingWeather ? "arrow.triangle.2.circlepath" : "arrow.clockwise")
                            .font(.system(size: 14))
                            .foregroundColor(.black)
                            .rotationEffect(isUpdatingWeather ? .degrees(360) : .degrees(0))
                            .animation(isUpdatingWeather ? Animation.linear(duration: 1).repeatForever(autoreverses: false) : .default, value: isUpdatingWeather)
                    }
                    .disabled(isUpdatingWeather)
                }
                .padding(.horizontal)
                .padding(.top, 4)

                Text("Places to visit")
                    .font(.custom("SourceSerif4-Regular", size: 30))
                    .padding(.top, 12)

                ScrollView {
                    if trip.places.isEmpty {
                        Text("No places found for this trip")
                            .font(.custom("SourceSerif4-Regular", size: 16))
                            .foregroundColor(.gray)
                            .padding()
                    } else {
                        VStack(spacing: 12) {
                            ForEach(trip.places) { place in
                                let urlString = place.websiteURL.isEmpty ?
                                    "https://www.google.com/search?q=\(place.name.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")" :
                                    place.websiteURL

                                ZStack {
                                    Button(action: {
                                        if let url = URL(string: urlString) {
                                            UIApplication.shared.open(url)
                                        }
                                    }) {
                                        Rectangle()
                                            .fill(Color.buttonColor1)
                                            .cornerRadius(49)
                                            .frame(height: 56)
                                    }
                                    .buttonStyle(PlainButtonStyle())

                                    HStack {
                                        Button(action: {
                                            place.isVisited.toggle()
                                            try? context.save()
                                        }) {
                                            Circle()
                                                .fill(place.isVisited ? Color.green.opacity(0.7) : Color.red.opacity(0.7))
                                                .frame(width: 20, height: 20)
                                                .overlay(
                                                    Group {
                                                        if place.isVisited {
                                                            Image(systemName: "checkmark")
                                                                .font(.system(size: 12))
                                                                .foregroundColor(.white)
                                                        }
                                                    }
                                                )
                                        }
                                        .zIndex(1)

                                        Text(place.name)
                                            .font(.custom("SourceSerif4-Regular", size: 16))
                                            .foregroundColor(Color.black)
                                            .lineLimit(1)
                                            .minimumScaleFactor(0.5)

                                        Spacer()

                                        Image(systemName: "arrow.forward")
                                            .foregroundColor(.black)
                                    }
                                    .padding(.horizontal, 16)
                                }
                                .padding(.horizontal)
                            }
                        }
                    }
                }
                .frame(maxHeight: 300)

                Spacer()

                HStack(spacing: 16) {
                    Button {
                        isEditing = true
                    } label: {
                        Image(systemName: "pencil")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 24, height: 24)
                            .foregroundColor(.black)
                            .frame(maxWidth: .infinity, minHeight: 60)
                            .background(Color.buttonColor2)
                            .cornerRadius(30)
                    }

                    NavigationLink(destination: MainView()) {
                        Image(systemName: "house")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 24, height: 24)
                            .foregroundColor(.black)
                            .frame(maxWidth: .infinity, minHeight: 60)
                            .background(Color.icon)
                            .cornerRadius(30)
                    }

                    Button {
                        showDeleteConfirmation = true
                    } label: {
                        Image(systemName: "trash.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 24, height: 24)
                            .foregroundColor(.black)
                            .frame(maxWidth: .infinity, minHeight: 60)
                            .background(Color.buttonColor2)
                            .cornerRadius(30)
                    }
                }
                .padding(.horizontal)
                .padding(.bottom, 16)
            }
            .padding()
        }
        .alert("Are you sure you want to delete this trip?", isPresented: $showDeleteConfirmation) {
            Button("Cancel", role: .cancel) {}
            Button("Delete", role: .destructive) {
                context.delete(trip)
                try? context.save()
                showDeletedAlert = true
            }
        }
        .alert("Trip deleted", isPresented: $showDeletedAlert) {
            Button("OK") {
                dismiss()
            }
        }
        .alert(weatherUpdateError != nil ? "Actualization error" : "Weather updated", isPresented: $showWeatherAlert) {
            Button("OK") { }
        } message: {
            if let error = weatherUpdateError {
                Text(error)
            } else {
                Text("Weather for  \(trip.destination) updated.")
            }
        }
        .navigationBarBackButtonHidden()
        .sheet(isPresented: $isEditing) {
            TripEditView(trip: trip)
                .presentationDetents([.height(300)])
                
        }
        .task {
            // Check if weather needs updating when view appears
            if isWeatherOutdated {
                await updateWeather()
            }
        }
    }
    
    // Format weather update time
    private var formattedWeatherUpdateTime: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter.string(from: trip.weather.lastUpdated)
    }
    
    // Update weather data using existing WeatherService
    // Update weather data using existing WeatherService
    private func updateWeather() async {
        // Prevent multiple concurrent updates
        guard !isUpdatingWeather else { return }
        
        isUpdatingWeather = true
        weatherUpdateError = nil
        
        do {
            // Create coordinate from trip data
            let coordinate = CLLocationCoordinate2D(latitude: trip.latitude, longitude: trip.longtitude)
            
            // Get the trip's start date as string instead of current date
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let dateString = dateFormatter.string(from: trip.startDate)
            
            // Create weather service and fetch weather
            let weatherService = WeatherService()
            let weatherResponse = try await weatherService.fetchWeatherAsync(
                for: coordinate,
                date: dateString,
                timeZone: trip.timezone
            )
            
            // Update the trip's weather with new data
            let avgTemp = weatherResponse.getAverageTemperature()
            let icon = weatherResponse.getWeatherIcon().rawValue
            
            // Update the model
            trip.weather.temperature = avgTemp
            trip.weather.conditions = icon
            trip.weather.lastUpdated = Date()
            
            // Save changes
            try context.save()
            
            // Show success alert
            await MainActor.run {
                showWeatherAlert = true
            }
            
        } catch {
            print("Failed to update weather: \(error.localizedDescription)")
            await MainActor.run {
                weatherUpdateError = "Could not update the weather: \(error.localizedDescription)"
                showWeatherAlert = true
            }
        }
        
        // Reset updating state
        isUpdatingWeather = false
    }
}
