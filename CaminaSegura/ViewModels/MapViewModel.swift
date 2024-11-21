//
//  MapViewModel.swift
//  CaminaSegura
//
//  Created by Richi Camarena on 14/10/24.
//

import Foundation
import CoreLocation
import MapKit
import SwiftUI

// ViewModel managing the data and logic for map and incident tracking
class MapViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
    @Published var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 19.432608, longitude: -99.133209), // CDMX as initial location for simulator
        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    )
    
    @Published var userLocation: CLLocationCoordinate2D?
    @Published var zones: [DangerZone] = [] // Array of danger zones with incidents
    @Published var selectedZone: DangerZone? // Closest zone based on user's location
    
    private var locationManager = CLLocationManager()
    
    override init() {
        super.init()
        configureLocationServices()
        loadIncidents()
    }
    
    // Configuring location services
    private func configureLocationServices() {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    // Start requesting the user's current location
    func requestUserLocation() {
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    // Delegate function that receives location updates
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let actualLocation = locations.last else { return }
        self.userLocation = actualLocation.coordinate
        self.region = MKCoordinateRegion(
            center: actualLocation.coordinate,
            span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        )
        
        // Set selectedZone to the nearest zone
        if let nearestZone = findNearestZone(to: actualLocation) {
            self.selectedZone = nearestZone
        }
    }
    
    // Determines the color of the zone pin based on incident count
    func colorPin(incidents numberOfIncidents: Int) -> Color {
        switch numberOfIncidents {
        case 0: return .green.opacity(0.0)
        case 1...5: return .green
        case 6...10: return .yellow
        case 11...20: return .orange
        default: return .red
        }
    }
    
    // Pre-load incidents
    private func loadIncidents() {
        zones = [
            DangerZone(name: "Juriquilla", coordinates: CLLocationCoordinate2D(latitude: 20.70947, longitude: -100.45802), numberOfIncidents: 1),
            DangerZone(name: "Santa Rosa Jáuregui", coordinates: CLLocationCoordinate2D(latitude: 20.74351, longitude: -100.44858), numberOfIncidents: 0),
            DangerZone(name: "Hércules", coordinates: CLLocationCoordinate2D(latitude: 20.60126, longitude: -100.35336), numberOfIncidents: 0),
            DangerZone(name: "La Pradera", coordinates: CLLocationCoordinate2D(latitude: 20.65664, longitude: -100.33978), numberOfIncidents: 1),
            DangerZone(name: "Felipe Carrillo Puerto", coordinates: CLLocationCoordinate2D(latitude: 20.60691, longitude: -100.42566), numberOfIncidents: 3),
            DangerZone(name: "El Salitre", coordinates: CLLocationCoordinate2D(latitude: 20.66494, longitude: -100.42398), numberOfIncidents: 0),
            DangerZone(name: "Pie de la Cuesta", coordinates: CLLocationCoordinate2D(latitude: 20.6402845, longitude: -100.4057819), numberOfIncidents: 0),
            DangerZone(name: "Loma Bonita", coordinates: CLLocationCoordinate2D(latitude: 20.64254, longitude: -100.44837), numberOfIncidents: 0),
            DangerZone(name: "Epigmenio González", coordinates: CLLocationCoordinate2D(latitude: 20.6121875, longitude: -100.4027739), numberOfIncidents: 0),
            DangerZone(name: "El Pueblito", coordinates: CLLocationCoordinate2D(latitude: 20.54004, longitude: -100.44344), numberOfIncidents: 0),
            DangerZone(name: "San José de los Olvera", coordinates: CLLocationCoordinate2D(latitude: 20.55443, longitude: -100.41754), numberOfIncidents: 0),
            DangerZone(name: "Venceremos", coordinates: CLLocationCoordinate2D(latitude: 20.55138, longitude: -100.39178), numberOfIncidents: 0),
            DangerZone(name: "La Negreta", coordinates: CLLocationCoordinate2D(latitude: 20.52741, longitude: -100.45106), numberOfIncidents: 0),
            DangerZone(name: "Los Ángeles", coordinates: CLLocationCoordinate2D(latitude: 20.53195, longitude: -100.49288), numberOfIncidents: 0),
            DangerZone(name: "Bravo", coordinates: CLLocationCoordinate2D(latitude: 20.39596, longitude: -100.4293), numberOfIncidents: 0),
            DangerZone(name: "Charco Blanco", coordinates: CLLocationCoordinate2D(latitude: 20.43517, longitude: -100.472), numberOfIncidents: 0),
            DangerZone(name: "La Cueva", coordinates: CLLocationCoordinate2D(latitude: 20.48407, longitude: -100.43306), numberOfIncidents: 0),
            DangerZone(name: "Purísima de San Rafael", coordinates: CLLocationCoordinate2D(latitude: 20.48398, longitude: -100.39432), numberOfIncidents: 0),
            DangerZone(name: "Los Olvera", coordinates: CLLocationCoordinate2D(latitude: 20.53487, longitude: -100.40516), numberOfIncidents: 0),
            DangerZone(name: "Lourdes", coordinates: CLLocationCoordinate2D(latitude: 20.51158, longitude: -100.47605), numberOfIncidents: 0),
            DangerZone(name: "La Cañada", coordinates: CLLocationCoordinate2D(latitude: 20.61769, longitude: -100.31919), numberOfIncidents: 0),
            DangerZone(name: "Chichimequillas", coordinates: CLLocationCoordinate2D(latitude: 20.76419, longitude: -100.336), numberOfIncidents: 0),
            DangerZone(name: "Amazcala", coordinates: CLLocationCoordinate2D(latitude: 20.70555, longitude: -100.25978), numberOfIncidents: 0),
            DangerZone(name: "El Colorado", coordinates: CLLocationCoordinate2D(latitude: 20.56701, longitude: -100.24463), numberOfIncidents: 0),
            DangerZone(name: "La Griega", coordinates: CLLocationCoordinate2D(latitude: 20.66430, longitude: -100.23813), numberOfIncidents: 0),
            DangerZone(name: "Saldarriaga", coordinates: CLLocationCoordinate2D(latitude: 20.62981, longitude: -100.2914), numberOfIncidents: 0),
            DangerZone(name: "Alfajayucan", coordinates: CLLocationCoordinate2D(latitude: 20.75361, longitude: -100.21698), numberOfIncidents: 0),
            DangerZone(name: "Dolores", coordinates: CLLocationCoordinate2D(latitude: 20.71827, longitude: -100.32564), numberOfIncidents: 0),
            DangerZone(name: "San Isidro Miranda", coordinates: CLLocationCoordinate2D(latitude: 20.56905, longitude: -100.32271), numberOfIncidents: 0),
            DangerZone(name: "El Lobo", coordinates: CLLocationCoordinate2D(latitude: 20.72783, longitude: -100.20062), numberOfIncidents: 0),
            DangerZone(name: "El Mirador", coordinates: CLLocationCoordinate2D(latitude: 20.59755, longitude: -100.33581), numberOfIncidents: 1)
        ]
    }
    
    // Centers the map based on the user's location
    func userCentering() {
        if let location = userLocation {
            region = MKCoordinateRegion(
                center: location,
                span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
            )
        }
    }
    
    // Adds a report to a selected zone if 5 minutes have passed for the current user
    func addReport(to zone: DangerZone) -> Bool {
        let currentTime = Date()
        let userDefaults = UserDefaults.standard
        
        // Check the last report date for this zone for the current user
        if let lastReportDate = userDefaults.getLastReportDate(forZoneId: zone.id), currentTime.timeIntervalSince(lastReportDate) < 300 {
            // Less than 5 minutes have passed for this user in this zone
            return false
        }
        
        if let index = zones.firstIndex(where: { $0.id == zone.id }) {
            zones[index].pendingReports += 1
            userDefaults.setLastReportDate(forZoneId: zone.id, date: currentTime)  // Update the last report time for this user in this zone
            
            // Check if there are enough reports to confirm the incident
            if zones[index].pendingReports >= 3 {
                zones[index].numberOfIncidents += 1  // Increment official incident count
                zones[index].pendingReports = 0  // Reset pending reports
                print("Confirmed incident in \(zones[index].name): Total incidents \(zones[index].numberOfIncidents)")
            } else {
                print("Pending reports for \(zones[index].name): \(zones[index].pendingReports)")
            }
            
            objectWillChange.send()  // Notify observers
        }
        
        return true
    }
    
    // Finds the nearest zone to the user's location
    func findNearestZone(to userLocation: CLLocation) -> DangerZone? {
        var nearestZone: DangerZone?
        var shortestDistance: CLLocationDistance = .greatestFiniteMagnitude
        
        for zone in zones {
            let zoneLocation = CLLocation(latitude: zone.coordinates.latitude, longitude: zone.coordinates.longitude)
            let distance = userLocation.distance(from: zoneLocation)
            
            if distance < shortestDistance {
                shortestDistance = distance
                nearestZone = zone
            }
        }
        return nearestZone
    }
}
