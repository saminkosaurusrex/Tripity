//
//  MainView.swift
//  Tripity
//
//  Created by Samuel Kundrát on 07/05/2025.
//

import SwiftUI

struct MainView: View {
    var body: some View {
        VStack {
            Spacer()
            Text("No trips yet")
                .font(.custom("SourceSerif4-Regular", size: 41))
            
            Spacer()
            
            NavigationLink(destination: SelectDestinationView()) {
                Text("Take a Trip")
                    .font(.custom("SourceSerif4-Regular", size: 41))
                    .foregroundColor(.black)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.buttonColor1)
                    .cornerRadius(49)
            }
        }
        .padding()
        .background(Color.background)
    }
}

#Preview {
    MainView()
}
