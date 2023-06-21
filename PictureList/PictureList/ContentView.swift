//
//  ContentView.swift
//  PictureList
//
//  Created by Anthony Bath on 6/18/23.
//

import SwiftUI
import PhotosUI



struct ContentView: View {
    @State private var showingPhotosPicker = false
    @State private var showingSaveSheet = false
    @State private var entries = [PictureEntry]()
    @State private var selectedPhoto: PhotosPickerItem?
    @State private var newEntry: PictureEntry?
    @State private var newName = ""
    
    let savePath = FileManager.documentsDirectory.appendingPathComponent("SavedEntries")
    let locationFetcher = LocationFetcher()
    
    init() {
        do {
            let data = try Data(contentsOf: savePath)
            let loaded = try JSONDecoder().decode([PictureEntry].self, from: data)
            
            _entries = State(initialValue: loaded.sorted())
        } catch {
            print("Error Loading: \(error.localizedDescription)")
        }
    }
    
    var body: some View {
        NavigationStack {
            List(entries) { entry in
                NavigationLink(value: entry) {
                    EntryRowView(entry: entry)
                        .padding([.bottom,.top],5)
                }
                .swipeActions {
                    Button(role: .destructive) {
                        entries.removeAll { $0.id == entry.id }
                        save()
                    } label: {
                        Label("Delete", systemImage: "trash")
                    }
                }
            }
            .navigationTitle("PictureList")
            .toolbar {
                Button {
                    showingPhotosPicker = true
                } label: {
                    Label("Add", systemImage: "photo")
                }
            }
            .navigationDestination(for: PictureEntry.self) { entry in DisplayView(entry: entry) }
            .photosPicker(isPresented: $showingPhotosPicker, selection: $selectedPhoto)
            .onChange(of: selectedPhoto, perform: onSelectPhoto)
            .onAppear { self.locationFetcher.start() }
            .sheet(item: $newEntry) { entry in
                AddView(
                    entry: entry,
                    onAdd: add,
                    onCancel: { newEntry = nil }
                )
            }
        }
    }
    
    func onSelectPhoto(_ selection: PhotosPickerItem?) {
        guard let selection = selection else { return }
        
        Task { @MainActor in
            do {
                if let data = try await selection.loadTransferable(type: Data.self) {
                    if let uiImage = UIImage(data: data) {
                        showingPhotosPicker = false
                        
                        if let imageData = uiImage.jpegData(compressionQuality: 0.8) {
                            showingSaveSheet = true
                            
                            var latitude: Double? = nil
                            var longitude: Double? = nil
                            
                            if let location = self.locationFetcher.lastKnownLocation {
                                latitude = location.latitude
                                longitude = location.longitude
                            }
                            
                            newEntry = PictureEntry(
                                id: UUID(),
                                name: "",
                                imageData: imageData,
                                latitude: latitude,
                                longitude: longitude
                            )
                        }
                    }
                }
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func add(name: String) {
        guard let savingEntry = newEntry else { return }
        
        let savedEntry = PictureEntry(
            id: savingEntry.id,
            name: name,
            imageData: savingEntry.imageData,
            latitude: savingEntry.latitude,
            longitude: savingEntry.longitude
        )
        
        entries.append(savedEntry)
        entries.sort()
        
        newEntry = nil
        newName = ""
        save()
    }
    
    func save() {
        do {
            let data = try JSONEncoder().encode(entries)
            try data.write(to: savePath, options: [.atomicWrite, .completeFileProtection])
        } catch {
            print("Unable to save data.")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
