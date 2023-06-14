//
//  ContentView.swift
//  BucketList
//
//  Created by Anthony Bath on 6/9/23.
//

import SwiftUI
import MapKit

struct ContentView: View {
    @StateObject private var viewModel = ViewModel()
    
    var body: some View {
        Group {
            if viewModel.isUnlocked {
                ZStack {
                    Map(coordinateRegion: $viewModel.mapRegion, annotationItems: viewModel.locations) { location in
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
                            .onTapGesture { viewModel.selected = location }
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
                                viewModel.addLocation()
                            } label: {
                                Image(systemName: "plus")
                                    .padding()
                                    .background(.black.opacity(0.75))
                                    .foregroundColor(.white)
                                    .font(.title)
                                    .clipShape(Circle())
                                    .padding(.trailing)
                            }
                        }
                    }
                }
                .sheet(item: $viewModel.selected) { location in
                    EditView(location: location) { updatedLocation in
                        viewModel.updateLocation(updatedLocation)
                    }
                }
            } else {
                Button("Unlock") {
                    viewModel.authenticate()
                }
            }
        }
        .alert("Authentication Error", isPresented: $viewModel.showingAuthError) {
            Button("OK") { }
        } message: {
            Text("Could not authenticate you.")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
