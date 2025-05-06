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
        
        
        HStack(spacing: 20) {
            if let weather = viewModel.weather{
                Text(String(format: "%.1f", weather.temperature.getAverageTemperature()) + " °C")
                    .foregroundColor(style.textColor)
                    .font(.custom("SourceSerif4-Regular", size: 41))
                Image(systemName: weather.getWeatherIcon().rawValue)
                    .foregroundColor(style.textColor)
                    .font(.system(size: 41))
            }else if viewModel.isLoading{
                ProgressView()
            }else if let error = viewModel.error {
                Text("Error: \(error.localizedDescription)")
                .foregroundColor(style.textColor)
            }
        }
        .padding(.vertical, 25)
        .padding(.horizontal, 15)
        .background(style.backgroundColor .opacity(0.7))
        .cornerRadius(30)
        .onAppear {
            viewModel.loadWeather(for: placeToVisit, date: date)
        }
        .overlay(
            RoundedRectangle(cornerRadius: 30)
                .stroke(style.textColor, lineWidth: 2)
        )
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


