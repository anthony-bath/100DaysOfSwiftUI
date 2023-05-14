//
//  Activity.swift
//  HabitTracker
//
//  Created by Anthony Bath on 5/11/23.
//

import Foundation

struct Activity: Codable, Identifiable, Hashable {
    var id = UUID()
    let name: String
    let description: String
    var count: Int = 0
    
    static var example = Activity(
        name: "Test Activity",
        description: "This is an examle description for Test Activity"
    )
}
