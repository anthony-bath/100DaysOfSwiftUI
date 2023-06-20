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
                    HStack {
                        entry.displayedImage
                            .resizable()
                            .scaledToFill()
                            .clipShape(Circle())
                            .frame(maxWidth: 50, maxHeight: 50)
                            .overlay(Circle().stroke(.primary, lineWidth: 2))

                        
                        VStack(alignment: .leading) {
                            Text(entry.name)
                                .font(.headline)
                            
                            Text("Added: \(entry.dateAdded.formatted())")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
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
            .navigationDestination(for: PictureEntry.self) { entry in
                DisplayView(entry: entry)
            }
            .photosPicker(isPresented: $showingPhotosPicker, selection: $selectedPhoto)
            .onChange(of: selectedPhoto) { selection in
                guard let selection = selection else { return }
                
                Task { @MainActor in
                    do {
                        if let data = try await selection.loadTransferable(type: Data.self) {
                            if let uiImage = UIImage(data: data) {
                                showingPhotosPicker = false
                                
                                if let imageData = uiImage.jpegData(compressionQuality: 0.8) {
                                    showingSaveSheet = true
                                    
                                    newEntry = PictureEntry(
                                        id: UUID(),
                                        name: "",
                                        imageData: imageData
                                    )
                                }
                            }
                        }
                    } catch {
                        print(error.localizedDescription)
                    }
                }
            }
            .sheet(item: $newEntry) { entry in
                NavigationStack {
                    VStack {
                        entry.displayedImage
                            .resizable()
                            .scaledToFit()
                            .frame(maxWidth: 300, maxHeight: 300)
                        
                        Form {
                            TextField("Name", text: $newName)
                            Button("Add", action: add)
                                .disabled(newName.isEmpty)
                        }
                    }
                    .toolbar {
                        Button("Cancel", role: .destructive) {
                            newName = ""
                            newEntry = nil
                        }
                    }
                    .navigationTitle("Add New Entry")
                }
            }
        }
    }
    
    func add() {
        guard let savingEntry = newEntry else { return }
        
        let savedEntry = PictureEntry(
            id: savingEntry.id,
            name: newName,
            imageData: savingEntry.imageData
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
