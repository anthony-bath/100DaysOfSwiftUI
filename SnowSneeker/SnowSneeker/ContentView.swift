//
//  ContentView.swift
//  SnowSneeker
//
//  Created by Anthony Bath on 7/5/23.
//

import SwiftUI

struct ContentView: View {
    enum SortType {
        case name, runs, country
    }
    
    let resorts: [Resort] = Bundle.main.decode("resorts.json")
    
    @State private var resortId: String?
    @State private var searchTerm: String = ""
    @State private var isShowingSortDialog = false
    @State private var sortType: SortType = .name
    @State private var columnVisibility = Binding.constant(NavigationSplitViewVisibility.detailOnly)
    @StateObject private var favorites = Favorites()
    
    var selectedResort : Resort? {
        if let resortId = resortId {
            return resorts.first { $0.id == resortId }
        }
        
        return nil
    }
    
    var filteredSortedResorts: [Resort] {
        var filteredResorts = resorts
        
        if !searchTerm.isEmpty {
            filteredResorts = resorts.filter { $0.name.localizedCaseInsensitiveContains(searchTerm) }
        }
        
        switch sortType {
        case .name:
            return filteredResorts.sorted { $0.name < $1.name }
        case .runs:
            return filteredResorts.sorted { $0.runs > $1.runs }
        case .country:
            return filteredResorts.sorted { $0.country < $1.country }
        }
    }
    
    var body: some View {
        NavigationSplitView(columnVisibility: columnVisibility ) {
            List(filteredSortedResorts, selection: $resortId) { resort in
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
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        isShowingSortDialog = true
                    } label: {
                        Label("Sort", systemImage: "line.3.horizontal.decrease")
                    }
                }
            }
            .confirmationDialog("Sort By", isPresented: $isShowingSortDialog, titleVisibility: .visible) {
                Button("Name") {
                    sortType = .name
                    isShowingSortDialog = false
                    columnVisibility = Binding.constant(NavigationSplitViewVisibility.all)
                }
                
                Button("Runs") {
                    sortType = .runs
                    isShowingSortDialog = false
                    columnVisibility = Binding.constant(NavigationSplitViewVisibility.all)
                }
                
                Button("Country") {
                    sortType = .country
                    isShowingSortDialog = false
                    columnVisibility = Binding.constant(NavigationSplitViewVisibility.all)
                }
            }
            .onChange(of: selectedResort) { _ in
                columnVisibility = Binding.constant(NavigationSplitViewVisibility.detailOnly)
            }
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
