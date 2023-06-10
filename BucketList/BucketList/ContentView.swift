//
//  ContentView.swift
//  BucketList
//
//  Created by Anthony Bath on 6/9/23.
//

import SwiftUI
import MapKit
import LocalAuthentication

struct Location: Identifiable {
    let id = UUID()
    let name: String
    let coordinate: CLLocationCoordinate2D
}

struct ContentView: View {
    @State private var isUnlocked = false
    @State private var mapRegion = MKCoordinateRegion(
        center: CLLocationCoordinate2D(
            latitude: 51.5,
            longitude: -0.12
        ),
        span: MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2)
    )
    
    let locations = [
        Location(
            name: "Buckingham Palace",
            coordinate: CLLocationCoordinate2D(
                latitude: 51.501,
                longitude: -0.141
            )
        ),
        Location(
            name: "Tower of London",
            coordinate: CLLocationCoordinate2D(
                latitude: 51.508,
                longitude: -0.076
            )
        )
    ]
    
    var body: some View {
        VStack {
            if isUnlocked {
                Map(coordinateRegion: $mapRegion, annotationItems: locations) { location in
                    MapAnnotation(coordinate: location.coordinate) {
                        Circle()
                            .stroke(.red, lineWidth: 3)
                            .frame(width: 44, height: 44)
                            .onTapGesture { print("Tapped on \(location.name)")}
                    }
                }
            } else {
                Text("Locked")
            }
        }
        .onAppear(perform: authenticate)

    }
    
    func authenticate() {
        let context = LAContext()
        var error: NSError?
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "We need to unlock your BucketList data"
            
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, authenticationError in
                if success {
                    isUnlocked = true
                } else {
                    // a problem
                }
            }
        } else {
            // No Biometrics Available
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
