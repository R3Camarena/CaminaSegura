//
//  CardView.swift
//  CaminaSegura
//
//  Created by Richi Camarena on 14/10/24.
//

import SwiftUI
import CoreLocation

// View for displaying information of a specific danger zone as a card
struct CardView: View {
    @ObservedObject var zone: DangerZone  // Observes the specific zone for dynamic updates
    
    var body: some View {
        ZStack {
            // Main display of number of incidents with color-coded style
            ZStack {
                Text("\(zone.numberOfIncidents)")
                    .font(.largeTitle)
                    .fontWeight(.semibold)
                    .foregroundStyle(color(for: zone.numberOfIncidents))
                    .scaleEffect(1.59)
                    .multilineTextAlignment(.center)
                    .padding(.bottom, 24)
                
                // Name of the zone at the bottom of the card
                VStack {
                    Spacer()
                    HStack() {
                        Spacer()
                        
                        Text(zone.name)
                            .font(.headline)
                            .fontWeight(.semibold)
                        
                        Spacer()
                    }
                    .padding(16)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(.white)
                }
            }
            .frame(maxWidth: .infinity, alignment: .center)
            .frame(height: 240, alignment: .center)
            .background(LinearGradient(
                stops: [.init(color: color(for: zone.numberOfIncidents).opacity(0.6), location: 0.00),
                        .init(color: .white, location: 0.91)],
                startPoint: .top,
                endPoint: .bottom)
            )
        }
        .frame(maxWidth: .infinity, alignment: .bottomLeading)
        .frame(height: 240, alignment: .bottomLeading)
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: .black.opacity(0.15), radius: 16, x: 0, y: 4)
    }
    
    // Helper function to determine color based on the number of incidents
    private func color(for incidents: Int) -> Color {
        switch incidents {
        case 1...5:
            return .green
        case 6...10:
            return .yellow
        case 11...20:
            return .orange
        default:
            return .red
        }
    }
}

#Preview {
    CardView(zone: DangerZone(name: "Juriquilla", coordinates: CLLocationCoordinate2D(latitude: 10.0, longitude: 10.0), numberOfIncidents: 1))
}
