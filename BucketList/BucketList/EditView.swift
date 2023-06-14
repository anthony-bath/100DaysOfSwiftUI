//
//  EditView.swift
//  BucketList
//
//  Created by Anthony Bath on 6/11/23.
//

import SwiftUI

struct EditView: View {
    
    @Environment(\.dismiss) var dismiss
    @StateObject var viewModel: ViewModel
    var onSave: (Location) -> Void

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("Location Name", text: $viewModel.name)
                    TextField("Description", text: $viewModel.description)
                }
                
                Section("Nearby...") {
                    switch viewModel.loadingState {
                    case .loading:
                        Text("Loading...")
                    case .loaded:
                        ForEach(viewModel.pages, id: \.pageid) { page in
                            Text(page.title)
                                .font(.headline)
                            + Text(": ")
                            + Text(page.description)
                                .italic()
                        }
                    case .failed:
                        Text("Try again later.")
                    }
                }
            }
            .navigationTitle("Location Details")
            .toolbar {
                Button("Save") {
                    let updatedLocation = viewModel.getUpdatedLocation()
                    onSave(updatedLocation)
                    dismiss()
                }
            }
            .task {
                await fetchNearbyLocations()
            }
        }
    }
    
    init(location: Location, onSave: @escaping (Location) -> Void) {
        self.onSave = onSave
        _viewModel = StateObject(wrappedValue: ViewModel(location: location))
    }
    
    func fetchNearbyLocations() async {
        let urlString = "https://en.wikipedia.org/w/api.php?ggscoord=\(viewModel.location.coordinate.latitude)%7C\(viewModel.location.coordinate.longitude)&action=query&prop=coordinates%7Cpageimages%7Cpageterms&colimit=50&piprop=thumbnail&pithumbsize=500&pilimit=50&wbptterms=description&generator=geosearch&ggsradius=10000&ggslimit=50&format=json"
        
        guard let url = URL(string: urlString) else {
            print("Bad URL: \(urlString)")
            return
        }
        
        do {
            let (data,_) = try await URLSession.shared.data(from: url)
            let items = try JSONDecoder().decode(Result.self, from: data)
            viewModel.pages = items.query.pages.values.sorted()
            viewModel.loadingState = .loaded
        } catch {
            print(error)
            viewModel.loadingState = .failed
        }
    }
}

struct EditView_Previews: PreviewProvider {
    static var previews: some View {
        EditView(location: Location.example) { _ in }
    }
}
