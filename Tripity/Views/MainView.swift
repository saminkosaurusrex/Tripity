//
//  MainView.swift
//  Tripity
//
//  Created by Samuel Kundrát on 07/05/2025.
//

import SwiftUI
import SwiftData

struct MainView: View {
    @EnvironmentObject var tripDraft: TripDraft
    @Environment(\.modelContext) private var modelContext
    @Query private var trips: [TripModel]
    
    
    // Date formatter for displaying dates in DD.MM. YYYY format
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM. yyyy"
        return formatter
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.background
                    .ignoresSafeArea()
                
                VStack{
                    if trips.isEmpty {
                        // No trips view
                        Spacer()
                        Text("No trips yet")
                            .font(.custom("SourceSerif4-Regular", size: 41))
                        Spacer()
                    } else {
                        // Horizontal scrolling trips
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 16) {
                                ForEach(trips.sorted(by: { $0.startDate > $1.startDate })) { trip in
                                    NavigationLink(destination: TripDetail(trip: trip)) {
                                        TripCardView(trip: trip)
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                }
                            }
                            .padding(.horizontal)
                            .padding(.vertical, 8)
                        }
                    }
                    
                    Spacer()
                    
                    // New trip button
                    NavigationLink(destination: SelectDestinationView()) {
                        Text("Take a trip")
                            .font(.custom("SourceSerif4-Regular", size: 42))
                            .foregroundColor(.black)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.buttonColor1)
                            .cornerRadius(49)
                            .padding(.horizontal, 32)
                    }
                    .padding(.bottom, 24)
                }
            }
            .navigationBarHidden(true)
        }
    }
}

// Trip card view
struct TripCardView: View {
    let trip: TripModel
    
    // Date formatter to match the design (DD.MM. YYYY)
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM. yyyy"
        return formatter
    }
    
    var body: some View {
        VStack(spacing: 0) {
            Rectangle()
                .fill(Color(red: 69 / 255, green: 58 / 255, blue: 73 / 255))
                .frame(width: 300, height: 600)
                .cornerRadius(20)
                .overlay(
                    VStack(alignment: .center, spacing: 20) {
                        // Destination name
                        Spacer()
                        Text(trip.destination)
                            .font(.custom("SourceSerif4-Regular", size: 50))
                            .foregroundColor(.white)
                            .lineLimit(1)
                            .minimumScaleFactor(0.5)
                            
                        
                        Spacer()
                        
                        HStack {
                            Image(systemName: transportIcon(for: trip.transport))
                                .resizable()
                                .scaledToFit()
                                .frame(width: 40, height: 40) // pevný rám pre jednotnosť
                                .foregroundColor(Color.icon)
                            Text(dateFormatter.string(from: trip.startDate))
                                .font(.custom("SourceSerif4-Regular", size: 40))
                                .foregroundColor(.white)
                                .lineLimit(1)
                                .minimumScaleFactor(0.5)
                        }

                        HStack {
                            Image(systemName: "house.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 40, height: 40) // rovnaký rám
                                .foregroundColor(Color.icon)
                            Text(dateFormatter.string(from: trip.endDate))
                                .font(.custom("SourceSerif4-Regular", size: 40))
                                .foregroundColor(.white)
                                .lineLimit(1)
                                .minimumScaleFactor(0.5)
                        }

                        
                        // Weather card
                        HStack {
                            Text("\(String(format: "%.0f", trip.weather.temperature))°C")
                                .font(.custom("SourceSerif4-Regular", size: 32))
                                .foregroundColor(.white)
                            
                            Spacer()
                            
                            Image(systemName: trip.weather.conditions)
                                .font(.system(size: 32))
                                .foregroundColor(.white)
                        }
                        .padding()
                        .background(Color.icon)
                        .cornerRadius(16)
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(Color.white, lineWidth: 2)
                        )
                        .padding(.bottom, 40)
                    }
                    .padding(.horizontal, 24)
                )
        }
        .frame(width: 300, height: 600)
    }
    
    // Helper function to map transport string to SF Symbol
    private func transportIcon(for transport: String) -> String {
        switch transport.lowercased() {
        case "car":
            return "car.fill"
        case "plane":
            return "airplane"
        case "train":
            return "tram.fill"
        default:
            return "figure.walk"
        }
    }
}

#Preview {
    MainView()
        .environmentObject(TripDraft())
        .modelContainer(for: TripModel.self, inMemory: true)
}
