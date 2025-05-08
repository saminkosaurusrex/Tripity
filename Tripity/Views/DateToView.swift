//
//  DateToView.swift
//  Tripity
//
//  Created by Samuel Kundrát on 08/05/2025.
//

import SwiftUI

struct DateToView: View {
    @EnvironmentObject var tripDraft: TripDraft
    @Environment(\.dismiss) var dismiss
    @State private var navigate = false
    @State private var showAlert = false
    @State private var alertMessage = "Invalid date."

    
    var body: some View {
        ZStack {
            Color.background
                .ignoresSafeArea() // Natiahne farbu na celú obrazovku
            
            VStack {
                Spacer()
                Text("TO?")
                    .lineLimit(1)
                    .minimumScaleFactor(0.5)
                    .font(.custom("SourceSerif4-Regular", size: 64))

                DatePicker(
                    "Start Date",
                    selection: Binding(
                        get: { tripDraft.endDate ?? Date() },
                        set: { tripDraft.endDate = $0 }
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
                        if let startDate = tripDraft.endDate {
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
                        Text("Set Trip")
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
    DateToView()
}
