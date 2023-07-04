//
//  Roll.swift
//  DiceRollr
//
//  Created by Anthony Bath on 7/4/23.
//

import Foundation

struct Roll: Identifiable, Codable {
    var id = UUID()
    var date = Date.now
    var dice: [Int]
    var rolls: [Int]
    var total: Int {
        rolls.reduce(0) { $0 + $1 }
    }
    
    init(die: [Dice]) {
        self.dice = die.map { $0.value }
        self.rolls = die.map { $0.rolledValue ?? 0 }
    }
    
    init(dice: [Int], rolls: [Int]) {
        self.dice = dice
        self.rolls = rolls
    }
}
