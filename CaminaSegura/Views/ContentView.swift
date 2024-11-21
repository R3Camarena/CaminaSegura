//
//  ContentView.swift
//  CaminaSegura
//
//  Created by Richi Camarena on 10/10/24.
//

import SwiftUI

// Main ContentView handling the tab navigation
struct ContentView: View {
    @StateObject private var viewModel = MapViewModel() // Shared view model
    @State private var isOnboardingCompleted = UserDefaults.standard.isOnboardingCompleted // Track onboarding status
    
    var body: some View {
        Group {
            if isOnboardingCompleted {
                // Show main app content if onboarding is complete
                MainTabView(viewModel: viewModel)
            } else {
                // Show onboarding view if it's the first time
                OnboardingView(isOnboardingCompleted: $isOnboardingCompleted)
            }
        }
    }
}

// MainTabView is the main app content
struct MainTabView: View {
    @ObservedObject var viewModel: MapViewModel
    
    var body: some View {
        // This condition is for adapting the tabview to the new standards in iOS 18+ but also handles the previous iOS versions.
        if #available(iOS 18, *) {
            TabView {
                // Map view tab
                Tab("Mapa", systemImage: "map.fill") {
                    MapView(viewModel: viewModel)
                }
                
                // Statistics view tab
                Tab("Incidencias", systemImage: "number.circle.fill") {
                    IncidentsView(viewModel: viewModel)
                }
            }
            .tint(.purple)
        } else {
            // TabView for iOS versions before iOS 18
            TabView {
                // Map view tab
                MapView(viewModel: viewModel)
                    .tabItem {
                        Image(systemName: "map.fill")
                        Text("Mapa")
                    }
                
                // Statistics view tab
                IncidentsView(viewModel: viewModel)
                    .tabItem {
                        Image(systemName: "number.circle.fill")
                        Text("Incidencias")
                    }
            }
        }
    }
}

// This extension manages the state of the onboarding view to determine if it should be displayed or not
extension UserDefaults {
    private enum Keys {
        static let onboardingCompleted = "onboardingCompleted"
    }
    
    var isOnboardingCompleted: Bool {
        get { bool(forKey: Keys.onboardingCompleted) }
        set { set(newValue, forKey: Keys.onboardingCompleted) }
    }
}

#Preview {
    ContentView()
}
