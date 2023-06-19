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
        entry.displayedImage
    }
}

struct DisplayView_Previews: PreviewProvider {
    static var previews: some View {
        DisplayView(entry: PictureEntry.example)
    }
}
