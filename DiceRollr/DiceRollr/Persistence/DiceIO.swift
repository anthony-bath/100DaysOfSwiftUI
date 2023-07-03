//
//  DiceLoader.swift
//  DiceRollr
//
//  Created by Anthony Bath on 7/3/23.
//

import Foundation

let PATH = FileManager.documentsDirectory.appendingPathComponent("Dice")

struct DiceSaver {
    func save(_ die: [Dice]) {
        do {
            let data = try JSONEncoder().encode(die)
            try data.write(to: PATH, options: [.atomicWrite, .completeFileProtection])
        } catch {
            print("Could not save Dice: \(error.localizedDescription)")
        }
    }
}

struct DiceLoader {
    func load() -> [Dice] {
        do {
            let data = try Data(contentsOf: PATH)
            return try JSONDecoder().decode([Dice].self, from: data)
        } catch {
            return []
        }
    }
}
