//
//  OnboardingView.swift
//  CaminaSegura
//
//  Created by Richi Camarena on 06/11/24.
//


import SwiftUI

struct OnboardingView: View {
    @Binding var isOnboardingCompleted: Bool  // Binding to track if onboarding is done
    
    private let features = [
        ("CaminaSegura", "Herramienta accesible y práctica que permite ver informacion sobre el índice de incidentes de seguridad en tiempo real", "figure.stand.dress"),
        ("Mapa", "Visualiza en un mapa las zonas que han tenido reportes en los últimos 3 meses.", "map.fill"),
        ("Agrega Incidentes", "Agrega un incidente nuevo en tu ubicación u otra ubicación para que las demás usuarias puedan verlo.", "mappin.and.ellipse"),
        ("Números de Incidentes", "Visualiza el número exacto de incidentes en tiempo real por cada zona.", "number.circle.fill")
    ]
    
    @State private var currentPage = 0  // Keeps track of the current page in onboarding
    
    var body: some View {
        TabView(selection: $currentPage) {
            ForEach(features.indices, id: \.self) { index in
                VStack(spacing: 20) {
                    // Display the SF Symbol image with a custom style
                    Image(systemName: features[index].2)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 100)  // Adjust size as needed
                        .foregroundColor(.purple)
                        .padding(.bottom, 20)
                    
                    Text(features[index].0)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .padding(.leading, 10)
                        .padding(.trailing, 10)
                    
                    Text(features[index].1)
                        .font(.title3)
                        .multilineTextAlignment(.center)
                        .padding()
                        .padding(.leading, 10)
                        .padding(.trailing, 10)
                    
                    if index == features.count - 1 {
                        Button(action: {
                            isOnboardingCompleted = true  // Set onboarding as completed
                            UserDefaults.standard.isOnboardingCompleted = true  // Save to UserDefaults
                        }) {
                            Text("Comenzar")
                                .fontWeight(.semibold)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.purple)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                        .padding()
                        .padding(.leading, 10)
                        .padding(.trailing, 10)
                    }
                }
                .tag(index)
            }
        }
        .tabViewStyle(PageTabViewStyle())  // Page indicator style for TabView
        .background(Gradient(colors: [.purple.opacity(0.8), .purple.opacity(0.2)]))
        .foregroundStyle(.black.opacity(0.8))
    }
}

#Preview {
    OnboardingView(isOnboardingCompleted: .constant(false))
}
