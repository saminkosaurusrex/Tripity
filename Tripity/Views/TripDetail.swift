//
//  TripDetail.swift
//  Tripity
//
//  Created by Samuel Kundrát on 09/05/2025.
//

import SwiftUI
import MapKit
import SwiftData

struct TripDetail: View {
    let trip: TripModel
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss
    @State private var visitedPlaces: Set<String> = []
    
    @State private var isEditing = false


    @State private var showDeleteConfirmation = false
    @State private var showDeletedAlert = false

    private var compactDateFormatter: DateFormatter {
        let df = DateFormatter()
        df.dateFormat = "d. MMMM yyyy"
        return df
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

                Text("Places to visit")
                    .font(.custom("SourceSerif4-Regular", size: 30))
                    .padding(.top, 20)

                ScrollView {
                    if trip.places.isEmpty {
                        Text("No places found for this trip")
                            .font(.custom("SourceSerif4-Regular", size: 16))
                            .foregroundColor(.gray)
                            .padding()
                    } else {
                        VStack(spacing: 12) {
                            ForEach(trip.places) { place in
                                let isVisited = visitedPlaces.contains(place.name)
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
                                            if isVisited {
                                                visitedPlaces.remove(place.name)
                                            } else {
                                                visitedPlaces.insert(place.name)
                                            }
                                        }) {
                                            Circle()
                                                .fill(Color.red.opacity(0.7))
                                                .frame(width: 20, height: 20)
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
        .navigationBarBackButtonHidden()
        .sheet(isPresented: $isEditing) {
            TripEditView(trip: trip)
        }
    }
}

//#Preview {
//    let weatherModel = WeatherModel(temperature: 22.5, conditions: "sun.max.fill")
//    let places = [
//        Place(name: "Prague Castle", category: "sight", websiteURL: "https://www.hrad.cz/en/prague-castle-for-visitors"),
//        Place(name: "Charles Bridge", category: "sight", websiteURL: "https://www.prague.eu/en/object/places/93/charles-bridge-karluv-most"),
//        Place(name: "Old Town Square", category: "sight", websiteURL: "https://www.prague.eu/en/object/places/183/old-town-square-staromestske-namesti")
//    ]
//
//    let sampleTrip = TripModel(
//        destination: "Prague",
//        transport: "plane",
//        startDate: Date(),
//        endDate: Date().addingTimeInterval(86400 * 5),
//        weather: weatherModel,
//        places: places
//    )
//
//    return TripDetail(trip: sampleTrip)
//        .modelContainer(for: TripModel.self)
//}
