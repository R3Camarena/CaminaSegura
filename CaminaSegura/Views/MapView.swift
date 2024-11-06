//
//  MapView.swift
//  CaminaSegura
//
//  Created by Richi Camarena on 10/10/24.
//

import SwiftUI
import MapKit

// View displaying a map with danger zones marked
struct MapView: View {
    @ObservedObject var viewModel = MapViewModel() // Observes the shared data model
    @State var camera: MapCameraPosition = .userLocation(fallback: .automatic)
    @State private var showSheet = false // Controls visibility of the AddIncident sheet
    
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            // This condition is for adapting the map to devices running iOS 17+ and devices running a lower version
            if #available(iOS 17, *) {
                Map(initialPosition: camera) {
                    UserAnnotation() // Shows user location
                    // Add markers only for zones with incidents > 0
                    ForEach(viewModel.zones.filter { $0.numberOfIncidents > 0 }) { zone in
                        // Annotation for each danger zone with incidents
                        Annotation(zone.name, coordinate: zone.coordinates) {
                            VStack {
                                Circle()
                                    .fill(viewModel.colorPin(incidents: zone.numberOfIncidents).opacity(0.5))
                                    .frame(width: 200, height: 200)
                            }
                        }
                    }
                }
                .mapControls {
                    MapUserLocationButton() // Adds a button to center on user location
                }
            } else {
                // Map for iOS versions before iOS 17
                Map(
                    coordinateRegion: $viewModel.region,
                    showsUserLocation: true,
                    annotationItems: viewModel.zones.filter { $0.numberOfIncidents > 0 }
                ) { zone in
                    MapAnnotation(coordinate: zone.coordinates) {
                        VStack {
                            Circle()
                                .fill(viewModel.colorPin(incidents: zone.numberOfIncidents).opacity(0.5))
                                .frame(width: 200, height: 200)
                        }
                    }
                }
            }
            
            // Button to add a new incident
            Button(action: {
                showSheet.toggle()
            }) {
                Image(systemName: "plus")
                    .font(.largeTitle)
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.purple)
                    .clipShape(Circle())
                    .shadow(radius: 10)
            }
            .padding(.trailing, 20)
            .padding(.bottom, 10)
            .sheet(isPresented: $showSheet) {
                AddIncidentView(viewModel: viewModel) // For diaplying the view when tapping the add button
            }
        }
    }
}

#Preview {
    MapView()
}
