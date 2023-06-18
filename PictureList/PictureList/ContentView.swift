//
//  ContentView.swift
//  PictureList
//
//  Created by Anthony Bath on 6/18/23.
//

import SwiftUI
import PhotosUI

struct PictureEntry: Identifiable, Codable {
    var id: UUID
    var name: String
    var imageData: Data
    
    var displayedImage: Image {
        if let uiImage = UIImage(data: imageData) {
            return Image(uiImage: uiImage)
        } else {
            return Image(systemName: "error")
        }
    }
}

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

            _entries = State(initialValue: loaded)
        } catch {
            print("Error Loading: \(error.localizedDescription)")
        }
    }
    
    var body: some View {
        NavigationStack {
            List(entries) { entry in
                HStack {
                    entry.displayedImage
                        .resizable()
                        .scaledToFit()
                        .clipShape(Circle())
                        .frame(maxWidth: 100, maxHeight: 100)
                    
                    Text(entry.name)
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
            .presentationDetents([.fraction(0.5)])
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
                            Button("Save", action: save)
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
    
    func save() {
        guard let savingEntry = newEntry else { return }
        
        let savedEntry = PictureEntry(
            id: savingEntry.id,
            name: newName,
            imageData: savingEntry.imageData
        )
        
        entries.append(savedEntry)
        
        do {
            let data = try JSONEncoder().encode(entries)
            try data.write(to: savePath, options: [.atomicWrite, .completeFileProtection])
            print(savePath)
            print("Saved")
        } catch {
            print("Unable to save data.")
        }
        
        newEntry = nil
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
