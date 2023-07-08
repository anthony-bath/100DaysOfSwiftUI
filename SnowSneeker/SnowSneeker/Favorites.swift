//
//  Favorites.swift
//  SnowSneeker
//
//  Created by Anthony Bath on 7/6/23.
//

import Foundation

class Favorites: ObservableObject {
    private var resorts: Set<String>
    private let saveKey = "Favorites"
    
    init() {
        let resortArray = UserDefaults.standard.array(forKey: saveKey) as? [String]
        
        if let resortArray = resortArray {
            resorts = Set(resortArray)
        } else {
            resorts = Set<String>()
        }
    }
    
    func contains(_ resort: Resort) -> Bool {
        resorts.contains(resort.id)
    }
    
    func add(_ resort: Resort) {
        objectWillChange.send()
        resorts.insert(resort.id)
        save()
    }
    
    func remove(_ resort: Resort) {
        objectWillChange.send()
        resorts.remove(resort.id)
        save()
    }
    
    func save() {
        UserDefaults.standard.set(Array(resorts), forKey: saveKey)
    }
}
