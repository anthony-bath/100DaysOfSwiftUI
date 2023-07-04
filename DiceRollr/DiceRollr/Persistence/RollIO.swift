//
//  RollIO.swift
//  DiceRollr
//
//  Created by Anthony Bath on 7/4/23.
//

import Foundation

fileprivate let PATH = FileManager.documentsDirectory.appendingPathComponent("Rolls")

struct RollSaver {
    func save(_ rolls: [Roll]) {
        do {
            let data = try JSONEncoder().encode(rolls)
            try data.write(to: PATH, options: [.atomicWrite, .completeFileProtection])
        } catch {
            print("Could not save Rolls: \(error.localizedDescription)")
        }
    }
}

struct RollLoader {
    func load() -> [Roll] {
        do {
            let data = try Data(contentsOf: PATH)
            return try JSONDecoder().decode([Roll].self, from: data)
        } catch {
            return []
        }
    }
}
