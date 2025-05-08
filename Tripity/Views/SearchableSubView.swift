//
//  LocationSearchRow.swift
//  Tripity
//
//  Created by Samuel Kundrát on 08/05/2025.
//

import SwiftUI
import MapKit

struct LocationSearchResultRow: View {
    let location: MKLocalSearchCompletion
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(alignment: .leading) {
                Text(location.title)
                    .font(.headline)
                if !location.subtitle.isEmpty {
                    Text(location.subtitle)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
            }
            .padding(.vertical, 6)
        }
    }
}
