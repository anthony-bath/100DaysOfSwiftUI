//
//  EditView.swift
//  BucketList
//
//  Created by Anthony Bath on 6/11/23.
//

import SwiftUI

struct EditView: View {
    @Environment(\.dismiss) var dismiss
    var location: Location
    var onSave: (Location) -> Void
    
    @State private var name: String
    @State private var description: String
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("Location Name", text: $name)
                    TextField("Description", text: $description)
                }
            }
            .navigationTitle("Location Details")
            .toolbar {
                Button("Save") {
                    var updatedLocation = location
                    
                    updatedLocation.id = UUID()
                    updatedLocation.name = name
                    updatedLocation.description = description
                    
                    onSave(updatedLocation)
                    dismiss()
                }
            }
        }
    }
    
    init(location: Location, onSave: @escaping (Location) -> Void) {
        self.location = location
        self.onSave = onSave
        _name = State(initialValue: location.name)
        _description = State(initialValue: location.description)
    }
}

struct EditView_Previews: PreviewProvider {
    static var previews: some View {
        EditView(location: Location.example) { _ in }
    }
}
