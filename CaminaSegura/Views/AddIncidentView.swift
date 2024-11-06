//
//  AddIncidentView.swift
//  CaminaSegura
//
//  Created by Richi Camarena on 22/10/24.
//

import SwiftUI
import CoreLocation

// View for adding incidents to a selected danger zone
struct AddIncidentView: View {
    @ObservedObject var viewModel: MapViewModel  // Observes the shared data model
    @State private var selectedZoneId: UUID? = nil
    @State private var numberOfNewIncidents = 1  // Default number of incidents to add
    @Environment(\.dismiss) var dismiss  // For closing the view when done
    
    var body: some View {
        NavigationView {
            Form {
                // Section for selecting a danger zone
                Section(header: Text("Selecciona una localidad")) {
                    Picker("Localidad", selection: $selectedZoneId) {
                        ForEach(viewModel.zones) { zone in
                            Text(zone.name).tag(zone.id as UUID?)
                        }
                    }
                    .pickerStyle(.menu)
                }
                
                // Section for specifying the number of incidents
                Section(header: Text("Número de incidentes en ésta zona")) {
                    Stepper("\(numberOfNewIncidents)", value: $numberOfNewIncidents, in: 1...10)
                }
            }
            .navigationBarTitle("Agregar Incidente", displayMode: .inline)
            .navigationBarItems(trailing: Button("Guardar") {
                // Update the selected zone with the new incidents
                if let zone = viewModel.zones.first(where: { $0.id == selectedZoneId }) {
                    print("Guardando incidencia para la zona: \(zone.name)")
                    print("Número de incidentes a agregar: \(numberOfNewIncidents)")
                    viewModel.addIncident(to: zone, count: numberOfNewIncidents)  // Update incident count in selected zone
                    dismiss()  // Close the view
                } else {
                    print("No se encontró la zona seleccionada para agregar el incidente")
                }
            })
        }
        .onAppear {
            // Request user's location and set the closest zone as the initial selection
            viewModel.requestUserLocation()
            
            // Set selectedZoneId to the nearest zone based on user's location
            if let userLocation = viewModel.userLocation {
                let userCLLocation = CLLocation(latitude: userLocation.latitude, longitude: userLocation.longitude)
                if let nearestZone = viewModel.findNearestZone(to: userCLLocation) {
                    selectedZoneId = nearestZone.id
                } else {
                    // Default to the first zone if no nearest zone is found
                    selectedZoneId = viewModel.zones.first?.id
                }
            } else {
                // Default to the first zone if user location is unavailable
                selectedZoneId = viewModel.zones.first?.id
            }
            
            /**DEBUGGING**/
            print("Zona seleccionada antes de guardar: \(String(describing: selectedZoneId))")
            print("Número de incidentes a agregar: \(numberOfNewIncidents)")
        }
    }
}

#Preview {
    AddIncidentView(viewModel: MapViewModel())
}
