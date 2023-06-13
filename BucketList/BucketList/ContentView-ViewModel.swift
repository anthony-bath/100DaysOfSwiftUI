//
//  ContentView-ViewModel.swift
//  BucketList
//
//  Created by Anthony Bath on 6/13/23.
//

import LocalAuthentication
import Foundation
import MapKit

extension ContentView {
    
    @MainActor
    class ViewModel: ObservableObject {
        @Published var mapRegion = MKCoordinateRegion(
            center: CLLocationCoordinate2D(
                latitude: 50,
                longitude: 0
            ),
            span: MKCoordinateSpan(latitudeDelta: 25, longitudeDelta: 25)
        )
        
        @Published private(set) var locations: [Location]
        @Published var selected: Location?
        @Published var isUnlocked = false
        
        let savePath = FileManager.documentsDirectory.appendingPathComponent("SavedLocations")
        
        init() {
            do {
                let data = try Data(contentsOf: savePath)
                locations = try JSONDecoder().decode([Location].self, from: data)
            } catch {
                locations = []
            }
        }
        
        func authenticate() {
            let context = LAContext()
            var error: NSError?
            
            if context.canEvaluatePolicy(.deviceOwnerAuthentication, error: &error) {
                let reason = "We need to unlock your BucketList data"
                context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, authError in
                    if success {
                        Task { @MainActor in self.isUnlocked = true }
                    } else {
                        // error
                    }
                }
            } else {
                // no biometrics
            }
        }
        
        func save() {
            do {
                let data = try JSONEncoder().encode(locations)
                try data.write(to: savePath, options: [.atomicWrite, .completeFileProtection])
            } catch {
                print("Unable to save data.")
            }
        }
        
        func addLocation() {
            let newLocation = Location(
                id: UUID(),
                name: "New location",
                description: "",
                latitude: mapRegion.center.latitude,
                longitude: mapRegion.center.longitude
            )
            
            locations.append(newLocation)
            
            save()
        }
        
        func updateLocation(_ location: Location) {
            guard let selected = selected else { return }
            
            if let index = locations.firstIndex(of: selected) {
                locations[index] = location
            }
            
            save()
        }
    }
}
