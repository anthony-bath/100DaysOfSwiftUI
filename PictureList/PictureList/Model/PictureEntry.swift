//
//  PictureEntry.swift
//  PictureList
//
//  Created by Anthony Bath on 6/19/23.
//

import Foundation
import SwiftUI

struct PictureEntry: Identifiable, Codable, Comparable, Hashable {
    var id: UUID
    var name: String
    var imageData: Data
    var dateAdded: Date
    
    init(id: UUID, name: String, imageData: Data) {
        self.id = id
        self.name = name
        self.imageData = imageData
        self.dateAdded = .now
    }
    
    var displayedImage: Image {
        if let uiImage = UIImage(data: imageData) {
            return Image(uiImage: uiImage)
        } else {
            return Image(systemName: "error")
        }
    }
    
    static func < (lhs: PictureEntry, rhs: PictureEntry) -> Bool {
        lhs.name < rhs.name
    }
    
    static let example = PictureEntry(
        id: UUID(),
        name: "Example Test",
        imageData: UIImage(systemName: "trash")!.jpegData(compressionQuality: 0.8)!
    )
}
