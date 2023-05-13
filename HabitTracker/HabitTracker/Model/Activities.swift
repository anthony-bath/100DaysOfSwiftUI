//
//  Activities.swift
//  HabitTracker
//
//  Created by Anthony Bath on 5/11/23.
//

import Foundation

class Activities: ObservableObject {
    @Published var list = [Activity]() {
        didSet {
            if let encoded = try? JSONEncoder().encode(list) {
                UserDefaults.standard.set(encoded, forKey: "ActivityList")
            }
        }
    }
    
    init() {
        if let savedList = UserDefaults.standard.data(forKey: "ActivityList") {
            if let decoded = try? JSONDecoder().decode([Activity].self, from: savedList) {
                list = decoded
                return
            }
        }
        
        list = []
    }
}
