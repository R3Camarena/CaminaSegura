//
//  AddIncidentView.swift
//  CaminaSegura
//
//  Created by Richi Camarena on 22/10/24.
//

import SwiftUI

struct AddIncidentView: View {
    @ObservedObject var viewModel: MapViewModel
    @State private var selectedZoneId: UUID? = nil
    @State private var showAlert = false  // State to control the alert display
    @State private var alertTitle = ""  // Dynamic title for the alert
    @State private var alertMessage = ""  // Dynamic message for the alert
    @Environment(\.dismiss) var dismiss
    
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
            }
            .navigationBarTitle("Reportar Incidente", displayMode: .inline)
            .navigationBarItems(trailing: Button("Reportar") {
                if let zone = viewModel.zones.first(where: { $0.id == selectedZoneId }) {
                    // Try to add a report and check if it was allowed
                    let reportAdded = viewModel.addReport(to: zone)
                    
                    if reportAdded {
                        alertTitle = "Incidente Agregado"
                        alertMessage = "El incidente ha sido agregado exitosamente."
                        showAlert = true
                        // Close the sheet after a 1-second delay
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            dismiss()
                        }
                    } else {
                        alertTitle = "Reporte No Permitido"
                        alertMessage = "Solo se puede reportar un incidente cada 5 minutos en la misma zona para prevenir falsos reportes."
                        showAlert = true
                    }
                } else {
                    print("No se encontró la zona seleccionada para agregar el incidente")
                }
            })
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text(alertTitle),
                    message: Text(alertMessage),
                    dismissButton: .default(Text("Ok"))
                )
            }
        }
        .onAppear {
            // Set initial selection to the nearest zone if available
            if selectedZoneId == nil {
                selectedZoneId = viewModel.selectedZone?.id
            }
        }
        .presentationDetents([.medium]) // Define the sheet height as 30% of the screen height
    }
}

#Preview {
    AddIncidentView(viewModel: MapViewModel())
}
