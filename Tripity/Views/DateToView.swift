//  View for screen to pick endDate
//  DateToView.swift
//  Tripity
//
//  Created by Samuel Kundrát on 08/05/2025.
//

import SwiftUI

struct DateToView: View {
    @EnvironmentObject var tripDraft: TripDraft
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) private var modelContext

    @State private var createdTrip: TripModel? = nil
    
    @State private var showAlert = false
    @State private var alertMessage = "Invalid date."
    @State private var isSaving = false

    var body: some View {
        ZStack {
            Color.background
                .ignoresSafeArea()

            VStack {
                Spacer()
                Text("TO?")
                    .font(.custom("SourceSerif4-Regular", size: 64))
                    .lineLimit(1)
                    .minimumScaleFactor(0.5)

                DatePicker(
                    "End Date",
                    selection: Binding(
                        get: { tripDraft.endDate ?? Date() },
                        set: { tripDraft.endDate = $0 }
                    ),
                    in: (tripDraft.startDate ?? Date())...,
                    displayedComponents: [.date]
                )
                .datePickerStyle(.graphical)
                .background(Color.white)
                .padding()

                Spacer()

                HStack {
                    Button("Back") {
                        dismiss()
                    }
                    .font(.custom("SourceSerif4-Regular", size: 25))
                    .foregroundColor(.black)
                    .frame(maxWidth: .infinity)
                    .padding(10)
                    .background(Color.buttonColor1)
                    .cornerRadius(49)

                    Button("Set Trip") {
                        guard
                            let start = tripDraft.startDate,
                            let end = tripDraft.endDate
                        else {
                            alertMessage = "Please select both start and end dates."
                            showAlert = true
                            return
                        }
                        let today = Calendar.current.startOfDay(for: Date())
                        let selStart = Calendar.current.startOfDay(for: start)
                        let selEnd   = Calendar.current.startOfDay(for: end)

                        guard selStart >= today, selEnd >= selStart else {
                            alertMessage = "End date must be today or later and not before start date."
                            showAlert = true
                            return
                        }

                        isSaving = true
                        Task {
                            do {
                                let trip = try await TripSaver.save(
                                    from: tripDraft,
                                    modelContext: modelContext
                                )
                                createdTrip = trip
                                
                            } catch {
                                alertMessage = "Saving failed: \(error.localizedDescription)"
                                showAlert = true
                            }
                            isSaving = false
                        }
                    }
                    .font(.custom("SourceSerif4-Regular", size: 25))
                    .foregroundColor(.black)
                    .frame(maxWidth: .infinity)
                    .padding(10)
                    .background(Color.buttonColor1)
                    .cornerRadius(49)
                    .disabled(isSaving)
                    .alert(alertMessage, isPresented: $showAlert) {
                        Button("OK", role: .cancel) { }
                    }
                }
                .padding()
            }

            // Loading overlay
            if isSaving {
                Color.black.opacity(0.3).ignoresSafeArea()
                ProgressView("Saving…")
                    .progressViewStyle(CircularProgressViewStyle())
            }
        }
        .navigationBarBackButtonHidden(true)
        .navigationDestination(
            item: $createdTrip,
            destination: { trip in
                TripDetail(trip: trip)
            }
        )
    }
}

#Preview {
    DateToView()
        .environmentObject(TripDraft())
}
