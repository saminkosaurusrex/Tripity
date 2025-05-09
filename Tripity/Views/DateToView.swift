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
    @Environment(\.modelContext) private var modelContext

    @State private var navigate = false
    @State private var showAlert = false
    @State private var alertMessage = "Invalid date."

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
                        guard let endDate = tripDraft.endDate,
                              let startDate = tripDraft.startDate else {
                            alertMessage = "Please select both start and end dates."
                            showAlert = true
                            return
                        }
                        let today = Calendar.current.startOfDay(for: Date())
                        let selEnd = Calendar.current.startOfDay(for: endDate)
                        let selStart = Calendar.current.startOfDay(for: startDate)

                        guard selStart >= today, selEnd >= selStart else {
                            alertMessage = "End date must be today or later and not before start date."
                            showAlert = true
                            return
                        }

                        Task {
                            do {
                                try await TripSaver.save(from: tripDraft, modelContext: modelContext)
                                navigate = true
                            } catch {
                                alertMessage = "Saving failed: \(error.localizedDescription)"
                                showAlert = true
                            }
                        }
                    }
                    .font(.custom("SourceSerif4-Regular", size: 25))
                    .foregroundColor(.black)
                    .frame(maxWidth: .infinity)
                    .padding(10)
                    .background(Color.buttonColor1)
                    .cornerRadius(49)
                    .alert(alertMessage, isPresented: $showAlert) {
                        Button("OK", role: .cancel) { }
                    }
                }
                .padding()
            }
        }
        .navigationBarBackButtonHidden(true)
        .navigationDestination(isPresented: $navigate) {
            TripDetail()
        }
    }
}


#Preview {
    DateToView()
}
