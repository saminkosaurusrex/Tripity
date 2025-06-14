//  View for screen to pick startDate
//  DateFromView.swift
//  Tripity
//
//  Created by Samuel Kundrát on 08/05/2025.
//

import SwiftUI

struct DateFromView: View {
    @EnvironmentObject var tripDraft: TripDraft
    @Environment(\.dismiss) var dismiss
    @State private var navigate = false
    @State private var showAlert = false
    @State private var alertMessage = "Invalid date."

    
    var body: some View {
        ZStack {
            Color.background
                .ignoresSafeArea()
            
            VStack {
                Spacer()
                Text("FROM?")
                    .lineLimit(1)
                    .minimumScaleFactor(0.5)
                    .font(.custom("SourceSerif4-Regular", size: 64))

                DatePicker(
                    "Start Date",
                    selection: Binding(
                        get: { tripDraft.startDate ?? Date() },
                        set: { tripDraft.startDate = $0 }
                    ),
                    in: Date()...,
                    displayedComponents: [.date]
                )
                .datePickerStyle(.graphical)
                .background(Color.white)
                .padding()
                Spacer()
                HStack {
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
                        if let startDate = tripDraft.startDate {
                               let today = Calendar.current.startOfDay(for: Date())
                               let selectedDay = Calendar.current.startOfDay(for: startDate)

                               if selectedDay >= today {
                                   navigate = true
                               } else {
                                   alertMessage = "The selected date must be today or later."
                                   showAlert = true
                               }
                           } else {
                               alertMessage = "Please select a valid start date."
                               showAlert = true
                           }
                    }) {
                        Text("End date")
                            .font(.custom("SourceSerif4-Regular", size: 25))
                            .foregroundColor(.black)
                            .frame(maxWidth: .infinity)
                            .padding(10)
                            .background(Color.buttonColor1)
                            .cornerRadius(49)
                    }
                    .alert(alertMessage, isPresented: $showAlert) {
                        Button("OK", role: .cancel) { }
                    }
                }
                .padding()
            }
        }
        .navigationBarBackButtonHidden(true)
        .navigationDestination(isPresented: $navigate) {
            DateToView()
        }
    }
}

#Preview {
    DateFromView()
}
