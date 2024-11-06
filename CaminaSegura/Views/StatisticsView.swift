//
//  IncidentsView.swift
//  CaminaSegura
//
//  Created by Richi Camarena on 14/10/24.
//

import SwiftUI

// View displaying statistics on the incidents per danger zone
struct IncidentsView: View {
    @ObservedObject var viewModel: MapViewModel // Observes the shared data model
    
    var body: some View {
        NavigationStack {
            ScrollView {
                // Displays each zone with incidents in a card
                ForEach(viewModel.zones.filter { $0.numberOfIncidents > 0 }) { zone in
                    CardView(zone: zone)
                        .padding(10)
                }
            }
            .navigationTitle("Estadísticas")
        }
    }
}

#Preview {
    IncidentsView(viewModel: MapViewModel())
}


