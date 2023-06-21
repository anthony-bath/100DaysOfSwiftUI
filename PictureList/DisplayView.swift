//
//  DisplayView.swift
//  PictureList
//
//  Created by Anthony Bath on 6/19/23.
//

import SwiftUI
import MapKit

struct DisplayView: View {
    let entry: PictureEntry
    var region: Binding<MKCoordinateRegion>?
    
    init(entry: PictureEntry) {
        self.entry = entry
        
        if let coordinate = entry.coordinate {
            self.region = Binding.constant(MKCoordinateRegion(
                center: coordinate,
                span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
            ))
        } else {
            self.region = nil
        }
    }
    
    var body: some View {
        List {
            Section {
                Text(entry.name)
            } header: {
                Text("Name")
            }
            
            Section {
                entry.displayedImage
                    .resizable()
                    .scaledToFit()
            } header: {
                Text("Picture")
            }
            
            Section {
                Text(entry.dateAdded.formatted())
            } header: {
                Text("Date Added")
            }
            
            if let region = region {
                Section {
                    Map(coordinateRegion: region, interactionModes: [], annotationItems: [entry]) { _ in
                        MapMarker(coordinate: entry.coordinate!)
                    }
                    .frame(height: 250)
                } header: {
                    Text("Location Added")
                }
            }
        }
        .navigationTitle("Details")
    }
}

struct DisplayView_Previews: PreviewProvider {
    static var previews: some View {
        DisplayView(entry: PictureEntry.example)
    }
}
