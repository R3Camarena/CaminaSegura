//
//  DangerZone.swift
//  CaminaSegura
//
//  Created by Richi Camarena on 14/10/24.
//

import Foundation
import CoreLocation
import SwiftUI

// Model representing a danger zone, including its details and incident count
class DangerZone: Identifiable, ObservableObject, Equatable {
    let id: UUID
    let name: String
    let coordinates: CLLocationCoordinate2D
    @Published var numberOfIncidents: Int // Observable incident count
    
    init(id: UUID = UUID(), name: String, coordinates: CLLocationCoordinate2D, numberOfIncidents: Int) {
        self.id = id
        self.name = name
        self.coordinates = coordinates
        self.numberOfIncidents = numberOfIncidents
    }
    
    // Enable comparison for Equatable conformance
    static func == (lhs: DangerZone, rhs: DangerZone) -> Bool {
        return lhs.id == rhs.id
    }
}
