//
//  EntryRowView.swift
//  PictureList
//
//  Created by Anthony Bath on 6/21/23.
//

import SwiftUI

struct EntryRowView: View {
    var entry: PictureEntry
    
    var body: some View {
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
}

struct EntryRowView_Previews: PreviewProvider {
    static var previews: some View {
        EntryRowView(entry: PictureEntry.example)
    }
}
