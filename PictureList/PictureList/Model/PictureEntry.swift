//
//  PictureEntry.swift
//  PictureList
//
//  Created by Anthony Bath on 6/19/23.
//

import CoreLocation
import Foundation
import SwiftUI

struct PictureEntry: Identifiable, Codable, Comparable, Hashable {
    let id: UUID
    let name: String
    let imageData: Data
    let dateAdded: Date
    let latitude: Double?
    let longitude: Double?
        
    
    init(id: UUID, name: String, imageData: Data, latitude: Double?, longitude: Double?) {
        self.id = id
        self.name = name
        self.imageData = imageData
        self.dateAdded = .now
        self.latitude = latitude
        self.longitude = longitude
    }
    
    var displayedImage: Image {
        if let uiImage = UIImage(data: imageData) {
            return Image(uiImage: uiImage)
        } else {
            return Image(systemName: "error")
        }
    }
    
    var coordinate: CLLocationCoordinate2D? {
        if let latitude = latitude, let longitude = longitude {
            return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        }
        
        return nil
    }
    
    static func < (lhs: PictureEntry, rhs: PictureEntry) -> Bool {
        lhs.name < rhs.name
    }
    
    #if DEBUG
    static let example = PictureEntry(
        id: UUID(),
        name: "Example Test",
        imageData: UIImage(systemName: "trash")!.jpegData(compressionQuality: 0.8)!,
        latitude: -13.66016,
        longitude: -55.19867
    )
    #endif
}
