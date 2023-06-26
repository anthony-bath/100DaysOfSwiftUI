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
    fileprivate(set) var dateAdded: Date
    
    init(name: String, email: String) {
        self.name = name
        self.email = email
        self.dateAdded = .now
    }
}

@MainActor class Prospects: ObservableObject {
    let SAVE_PATH = FileManager.documentsDirectory.appendingPathComponent("SavedData")
    
    @Published private(set) var people: [Prospect]
    
    init() {
        do {
            let data = try Data(contentsOf: SAVE_PATH)
            people = try JSONDecoder().decode([Prospect].self, from: data)
        } catch {
            people = []
        }
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
        do {
            let data = try JSONEncoder().encode(people)
            try data.write(to: SAVE_PATH, options: [.atomicWrite, .completeFileProtection])
        } catch {
            print("Unable to save data.")
        }
    }
}
