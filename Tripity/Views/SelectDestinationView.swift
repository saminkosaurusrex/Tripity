//
//  SelectDestinationView.swift
//  Tripity
//
//  Created by Samuel Kundrát on 07/05/2025.
//


import SwiftUI
import MapKit

struct SelectDestinationView: View {
    @StateObject private var vm = LocationSearchService()
    @State private var query = ""
    @State private var selectedLocationName: String? = nil
    @State private var selectedTransport: TransportMode = .car
    @State private var sliderValue: Double = 2000
    @FocusState private var isSearchFocused: Bool
    @State var longtitude : Double = 49.19522
    @State var latitude : Double = 16.60796
    @Environment(\.dismiss) var dismiss
    @State private var showAlert = false
    @State private var navigate = false
    @EnvironmentObject var tripDraft: TripDraft


    var body: some View {
        ZStack {
            VStack(spacing: 16) {
                Spacer()
                Text("WHERE?")
                    .font(.custom("SourceSerif4-Regular", size: 45))

                VStack(spacing: 4) {
                    // search bar for trip destination
                    TextField(selectedLocationName ?? "Search for a destination...", text: $query)
                        .focused($isSearchFocused)
                        .multilineTextAlignment(.center)
                        .font(.custom("SourceSerif4-Regular", size: 20))
                        .padding(.vertical, 8)

                    Rectangle()
                        .frame(height: 1)
                        .foregroundColor(.gray)
                }
                .padding(.horizontal)

                if selectedLocationName != nil && query.isEmpty {
                    Text("Traveling to: \(selectedLocationName ?? "")")
                        .font(.custom("SourceSerif4-Regular", size: 20))
                        .padding(.top)
                }

                Spacer()

                Text("HOW?")
                    .font(.custom("SourceSerif4-Regular", size: 45))

                // Trnasport seelction
                Picker("Transport", selection: $selectedTransport) {
                    ForEach(TransportMode.allCases) { mode in
                        Text(mode.rawValue)
                            .tag(mode)
                    }
                }
                .pickerStyle(.segmented)
                .padding(.horizontal)
                Spacer()

                Text("PLACES TO VISIT RADIUS?")
                    .lineLimit(1)
                    .minimumScaleFactor(0.5)
                    .font(.custom("SourceSerif4-Regular", size: 45))
                    . padding()
                
                // slider for visit radius
                Slider(value: $sliderValue, in: 1000...20000, step: 100)
                    .padding(.horizontal)

                Text("\(Int(sliderValue))")
                    .lineLimit(1)
                    .minimumScaleFactor(0.5)
                    .font(.custom("SourceSerif4-Regular", size: 25))

                Spacer()
                
                HStack {
                    //back button
                    Button(action: {
                        dismiss()
                    }) {
                        Text("Back")
                            .font(.custom("SourceSerif4-Regular", size: 25))
                            .foregroundColor(.black)
                            .frame(maxWidth: .infinity)
                            .padding(10)
                            .background(Color.buttonColor1)
                            .cornerRadius(49)
                    }

                    Button(action: {
                        if selectedLocationName == nil || selectedLocationName!.isEmpty {
                            showAlert = true
                        } else {
                            tripDraft.destination = selectedLocationName ?? ""
                            tripDraft.transport = selectedTransport
                            tripDraft.radius = sliderValue
                            tripDraft.latitude = latitude
                            tripDraft.longtitude = longtitude
                            navigate = true
                            print("Destination: \( tripDraft.destination)\n Transport: \( tripDraft.transport)\n Radius: \( tripDraft.radius)\n Latitude: \( tripDraft.latitude)\n Longtitude: \( tripDraft.longtitude)")
                        }
                    }) {
                        Text("Start date")
                            .font(.custom("SourceSerif4-Regular", size: 25))
                            .foregroundColor(.black)
                            .frame(maxWidth: .infinity)
                            .padding(10)
                            .background(Color.buttonColor1)
                            .cornerRadius(49)
                    }
                    .alert("Please select a destination first.", isPresented: $showAlert) {
                        Button("OK", role: .cancel) { }
                    }
                }
                .padding()

                
            }
            .blur(radius: !query.isEmpty ? 3 : 0)
            .animation(.easeInOut(duration: 0.25), value: query)

            // Overlay for search
            if !query.isEmpty {
                Color.black.opacity(0.3)
                    .ignoresSafeArea()
                    .onTapGesture {
                        query = ""
                        vm.results = []
                        isSearchFocused = false
                    }

                VStack {
                    VStack {
                        
                        TextField(selectedLocationName ?? "Search for a destination...", text: $query)
                            .focused($isSearchFocused)
                            .multilineTextAlignment(.center)
                            .font(.custom("SourceSerif4-Regular", size: 20))
                            .padding(.vertical, 8)
                            .foregroundColor(Color.white)

                        Rectangle()
                            .frame(height: 1)
                            .foregroundColor(.white)
                            .padding(.horizontal, 5)
                    }
                    .padding(.top, 15)

                    List {
                        ForEach(vm.results) { result in
                            Button {
                                vm.searchLocation(from: result) { mapItem in
                                    guard let mapItem = mapItem else { return }
                                    selectedLocationName = mapItem.name
                                    query = ""
                                    vm.results = []
                                    isSearchFocused = false
                                    
                                    if let city = vm.selectedCity {
                                        latitude = city.latitude
                                        longtitude = city.longitude
                                    }
                                }
                            } label: {
                                VStack(alignment: .leading) {
                                    Text(result.title)
                                        .font(.custom("SourceSerif4-Regular", size: 20))
                                    Text(result.subtitle)
                                        .font(.custom("SourceSerif4-Regular", size: 16))
                                        .foregroundColor(.gray)
                                }
                                .padding(.vertical, 4)
                            }
                        }
                    }
                    .listStyle(.plain)
                    .frame(maxHeight: 350)
                    .background(Color.white)
                    .cornerRadius(12)
                    .shadow(radius: 5)
                    .padding(.horizontal)
                    .transition(.move(edge: .top))
                }
            }
        }
        .navigationBarBackButtonHidden()
        .onChange(of: query) {
            vm.query = query
        }
        .background(Color.background)
        
        .navigationDestination(isPresented: $navigate) {
            DateFromView()
        }
    }
}

enum TransportMode: String, CaseIterable, Identifiable {
    case car = "Car"
    case train = "Train"
    case plane = "Plane"
    case foot = "On foot"

    var id: String { self.rawValue }
}
