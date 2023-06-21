//
//  SaveView.swift
//  PictureList
//
//  Created by Anthony Bath on 6/21/23.
//

import SwiftUI

struct AddView: View {
    @State private var name: String = ""
    
    var entry: PictureEntry
    var onAdd: (String) -> Void
    var onCancel: () -> Void
    
    var body: some View {
        NavigationStack {
            VStack {
                entry.displayedImage
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: 300, maxHeight: 300)
                
                Form {
                    TextField("Name", text: $name)
                    Button("Add") { onAdd(name) }
                        .disabled(name.isEmpty)
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel", role: .destructive, action: onCancel)
                }
            }
            .navigationTitle("Add New Entry")
        }
    }
}

struct AddView_Previews: PreviewProvider {
    static var previews: some View {
        AddView(
            entry: PictureEntry.example,
            onAdd: { name in },
            onCancel: { }
        )
    }
}
