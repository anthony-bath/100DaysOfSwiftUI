//
//  CardsIO.swift
//  Flashzilla
//
//  Created by Anthony Bath on 6/30/23.
//

import Foundation

extension FileManager {
    static var documentsDirectory: URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}

struct CardsIO {
    static var KEY = "Cards"
    static var PATH: URL {
        FileManager.documentsDirectory.appendingPathComponent(KEY)
    }
    
    static func load() -> [Card] {
        if let data = try? Data(contentsOf: PATH) {
            if let decoded = try? JSONDecoder().decode([Card].self, from: data) {
                return decoded
            }
        }
        
        return [Card]()
    }
    
    static func save(_ cards: [Card]) {
        if let data = try? JSONEncoder().encode(cards) {
            try? data.write(to: PATH, options: [.atomicWrite, .completeFileProtection])
            return
        }
    }
}
