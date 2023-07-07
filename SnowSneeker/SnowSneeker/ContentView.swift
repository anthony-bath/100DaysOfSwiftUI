//
//  ContentView.swift
//  SnowSneeker
//
//  Created by Anthony Bath on 7/5/23.
//

import SwiftUI

struct ContentView: View {
    let resorts: [Resort] = Bundle.main.decode("resorts.json")
    
    @State private var resortId: String?
    @State private var searchTerm: String = ""
    @StateObject private var favorites = Favorites()
    
    var selectedResort : Resort? {
        if let resortId = resortId {
            return resorts.first { $0.id == resortId }
        }
        
        return nil
    }
    
    var filteredResorts: [Resort] {
        if searchTerm.isEmpty {
            return resorts
        }
        
        return resorts.filter { $0.name.localizedCaseInsensitiveContains(searchTerm) }
    }
    
    var body: some View {
        NavigationSplitView(columnVisibility: .constant(.detailOnly)) {
            List(filteredResorts, selection: $resortId) { resort in
                NavigationLink(value: resort) {
                    HStack {
                        Image(resort.country)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 40, height: 25)
                            .clipShape(RoundedRectangle(cornerRadius: 5))
                            .overlay(RoundedRectangle(cornerRadius: 5).stroke(.black, lineWidth: 1))
                        
                        VStack(alignment: .leading) {
                            Text(resort.name)
                                .font(.headline)
                            
                            Text("\(resort.runs) Runs")
                                .foregroundColor(.secondary)
                        }
                        
                        if favorites.contains(resort) {
                            Spacer()
                            Image(systemName: "heart.fill")
                                .accessibilityLabel("This is a favorite resort")
                                .foregroundColor(.red)
                        }
                    }
                }
            }
            .searchable(text: $searchTerm, prompt: "Search for a resort")
            .navigationTitle("Resorts")
        } detail: {
            if let resort = selectedResort {
                ResortView(resort: resort)
            } else {
                WelcomeView()
            }
        }
        .environmentObject(favorites)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
