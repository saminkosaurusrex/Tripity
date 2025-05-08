//
//  SwiftUIView.swift
//  Tripity
//
//  Created by Samuel Kundrát on 06/05/2025.
//

import SwiftUI

struct PlacesView: View {
    @StateObject private var viewModel = PlacesViewModel()
    @State private var visitedPlaces: Set<String> = []
    let city: String
    let lat: Double
    let long: Double
    let radius: Int
    
    var body: some View {
        VStack{
            Text("Places to visit")
                .font(.custom("SourceSerif4-Regular", size: 24))
                .frame(maxWidth: .infinity, alignment: .center)
        
            ScrollView {
                if viewModel.isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle())
                    
                } else if let error = viewModel.error {
                    
                    Text("Error: \(error.localizedDescription)")
                        .foregroundColor(.red)
                        .padding()
                } else {
                    VStack(spacing: 12) {
                        ForEach(viewModel.places, id: \.properties.name) { place in
                            if let name = place.properties.name {
                                let isVisited = visitedPlaces.contains(name)
                                let urlString = place.properties.website ?? "https://www.google.com/search?q=\(name.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")"
                                
                                Button(action: {
                                    if let url = URL(string: urlString) {
                                        UIApplication.shared.open(url)
                                    }
                                }) {
                                    HStack {
                                        Button(action: {
                                            if isVisited {
                                                visitedPlaces.remove(name)
                                            } else {
                                                visitedPlaces.insert(name)
                                            }
                                        }) {
                                            Image(systemName: "circle.fill")
                                                .foregroundColor(isVisited ? Color.white : Color.buttonColor2)
                                        }
                                        
                                        Text(name)
                                            .font(.custom("SourceSerif4-Regular", size: 16))
                                            .foregroundColor(Color.black)
                                            .lineLimit(1) 
                                            .minimumScaleFactor(0.5)
                                        
                                        Spacer()
                                        
                                        Image(systemName: "arrow.forward")
                                            .foregroundColor(.black)
                                    }
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Color.buttonColor1)
                                    .cornerRadius(49)
                                }
                            }
                        }
                    }
                    .padding()
                }
            }
            
            .onAppear {
                viewModel.fetchPlaces(forCity: city, latitude: lat, longitude: long, radius: radius)
            }
           
        }
        .background(Color.background)
    }
}



#Preview {
    PlacesView(city: "Prague",lat: 50.0755, long: 14.4378, radius: 5000)
}
