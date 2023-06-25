//
//  Prospect.swift
//  HotProspects
//
//  Created by Anthony Bath on 6/24/23.
//

import SwiftUI

class Prospect: Identifiable, Codable {
    var id = UUID()
    var name = "Anonymous"
    var email = ""
    fileprivate(set) var isContacted = false
}

@MainActor class Prospects: ObservableObject {
    let SAVE_KEY = "SavedData"
    
    @Published private(set) var people: [Prospect]
    
    init() {
        if let data = UserDefaults.standard.data(forKey: SAVE_KEY) {
            if let decoded = try? JSONDecoder().decode([Prospect].self, from: data) {
                people = decoded
                return
            }
        }
        
        people = []
    }
    
    func add(_ prospect: Prospect) {
        people.append(prospect)
        save()
    }
    
    func toggle(_ prospect: Prospect) {
        objectWillChange.send()
        prospect.isContacted.toggle()
        save()
    }
    
    private func save() {
        if let encoded = try? JSONEncoder().encode(people) {
            UserDefaults.standard.set(encoded, forKey: SAVE_KEY)
        }
    }
}
