//
//  DisplayView.swift
//  PictureList
//
//  Created by Anthony Bath on 6/19/23.
//

import SwiftUI

struct DisplayView: View {
    let entry: PictureEntry
    
    var body: some View {
        List {
            Section {
                Text(entry.name)
            } header: {
                Text("Name")
            }
            
            Section {
                entry.displayedImage
                    .resizable()
                    .scaledToFit()
            } header: {
                Text("Picture")
            }
            
            Section {
                Text(entry.dateAdded.formatted())
            } header: {
                Text("Date Added")
            }
        }
        .navigationTitle("Details")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct DisplayView_Previews: PreviewProvider {
    static var previews: some View {
        DisplayView(entry: PictureEntry.example)
    }
}
