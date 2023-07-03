//
//  Dice.swift
//  DiceRollr
//
//  Created by Anthony Bath on 7/3/23.
//

import Foundation

struct Dice: Identifiable, Codable, Equatable {
    var id = UUID()
    var value = 6
    
    static func ==(lhs: Dice, rhs: Dice) -> Bool {
        lhs.id == rhs.id
    }
}
