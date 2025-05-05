//
//  WeatherView.swift
//  Tripity
//
//  Created by Samuel Kundrát on 05/05/2025.
//

import SwiftUI

struct WeatherView : View {
    @StateObject private var viewModel = WeatherViewModel()
    let placeToVisit: String
    let date: String
    let style: WeatherStyle
    
    var body: some View {
        HStack {
            if let weather = viewModel.weather{
                Text("\(weather.temperature)")
                    //.font(.custom("SourceSerif4", size: style.fontSize))
                    .foregroundColor(style.textColor)
            }else if viewModel.isLoading{
                ProgressView()
            }else if let error = viewModel.error {
                Text("Error: \(error.localizedDescription)")
                //.font(.custom("SourceSerif4", size: style.fontSize))
                .foregroundColor(style.textColor)
            }
        }
        .background(style.backgroundColor)
        .border(style.textColor, width: 2)
        .onAppear {
            viewModel.loadWeather(for: placeToVisit, date: date)
        }
    }
}

struct WeatherStyle {
    let backgroundColor: Color
    let textColor: Color
    let fontSize: CGFloat
}

extension WeatherStyle {
    static let tripCard = WeatherStyle(backgroundColor: .icon , textColor: .background, fontSize: 32.0)
    static let detailed = WeatherStyle(backgroundColor: .background, textColor: .black, fontSize: 41.0)
}

#Preview {
    WeatherView(placeToVisit: "New York", date: "2025-05-10", style: .tripCard)
}


