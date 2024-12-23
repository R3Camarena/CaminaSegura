//
//  DangerZone.swift
//  CaminaSegura
//
//  Created by Richi Camarena on 14/10/24.
//

import Foundation
import CoreLocation
import SwiftUI

class DangerZone: Identifiable, ObservableObject, Equatable, Codable {
    let id: UUID
    let name: String
    let latitude: Double
    let longitude: Double
    @Published var numberOfIncidents: Int  // Official incident count
    @Published var pendingReports: Int = 0  // Pending user reports waiting to be confirmed
    
    // Coordinates as a computed property
    var coordinates: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    init(id: UUID = UUID(), name: String, coordinates: CLLocationCoordinate2D, numberOfIncidents: Int) {
        self.id = id
        self.name = name
        self.latitude = coordinates.latitude
        self.longitude = coordinates.longitude
        self.numberOfIncidents = numberOfIncidents
    }
    
    // Equatable protocol requires this function to allow object compasrisons in DangerZone
    static func == (lhs: DangerZone, rhs: DangerZone) -> Bool {
        return lhs.id == rhs.id
    }
    
    // Encodable & Decodable protocols require this enum
    enum CodingKeys: String, CodingKey {
        case id, name, latitude, longitude, numberOfIncidents, pendingReports
    }
    
    // Encoding and encrypting data
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(latitude, forKey: .latitude)
        try container.encode(longitude, forKey: .longitude)
        try container.encode(numberOfIncidents, forKey: .numberOfIncidents)
        try container.encode(pendingReports, forKey: .pendingReports)
    }
    
    // Decodifing and decrypting data
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        latitude = try container.decode(Double.self, forKey: .latitude)
        longitude = try container.decode(Double.self, forKey: .longitude)
        numberOfIncidents = try container.decode(Int.self, forKey: .numberOfIncidents)
        pendingReports = try container.decode(Int.self, forKey: .pendingReports)
    }
}
