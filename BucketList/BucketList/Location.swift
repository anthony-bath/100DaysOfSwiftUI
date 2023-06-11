//
//  Location.swift
//  BucketList
//
//  Created by Anthony Bath on 6/10/23.
//

import Foundation
import CoreLocation

struct Location: Identifiable, Equatable, Codable {
    var id: UUID
    var name: String
    var description: String
    let latitude: Double
    let longitude: Double
    
    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    static func ==(lhs: Location, rhs: Location) -> Bool {
        lhs.id == rhs.id
    }
    
    static let example = Location(
        id: UUID(),
        name: "Buckingham Palace",
        description: "Where Queen Elizabeth used to live",
        latitude: 51.501,
        longitude: -0.141
    )
}
