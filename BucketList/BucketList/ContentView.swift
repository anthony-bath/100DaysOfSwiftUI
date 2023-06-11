//
//  ContentView.swift
//  BucketList
//
//  Created by Anthony Bath on 6/9/23.
//

import SwiftUI
import MapKit

struct ContentView: View {
    @State private var mapRegion = MKCoordinateRegion(
        center: CLLocationCoordinate2D(
            latitude: 50,
            longitude: 0
        ),
        span: MKCoordinateSpan(latitudeDelta: 25, longitudeDelta: 25)
    )
    
    @State private var locations = [Location]()
    @State private var selected: Location?
    
    var body: some View {
        ZStack {
            Map(coordinateRegion: $mapRegion, annotationItems: locations) { location in
                MapAnnotation(coordinate: location.coordinate) {
                    VStack {
                        Image(systemName: "star.circle")
                            .resizable()
                            .foregroundColor(.red)
                            .frame(width: 44, height: 44)
                            .background(.white)
                            .clipShape(Circle())
                        
                        Text(location.name)
                            .fixedSize()
                    }
                    .onTapGesture { selected = location }
                }
            }
            .ignoresSafeArea()
            
            Circle()
                .fill(.blue)
                .opacity(0.3)
                .frame(width: 32, height: 32)
            
            VStack {
                Spacer()
                
                HStack {
                    Spacer()
                    
                    Button {
                        let newLocation = Location(
                            id: UUID(),
                            name: "New location",
                            description: "",
                            latitude: mapRegion.center.latitude,
                            longitude: mapRegion.center.longitude
                        )
                        
                        locations.append(newLocation)
                    } label: {
                        Image(systemName: "plus")
                        
                    }
                    .padding()
                    .background(.black.opacity(0.75))
                    .foregroundColor(.white)
                    .font(.title)
                    .clipShape(Circle())
                    .padding(.trailing)
                }
            }
        }
        .sheet(item: $selected) { location in
            EditView(location: location) { updatedLocation in
                if let index = locations.firstIndex(of: location) {
                    locations[index] = updatedLocation
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
