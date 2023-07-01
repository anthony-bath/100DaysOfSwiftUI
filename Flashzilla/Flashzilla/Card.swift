//
//  Card.swift
//  Flashzilla
//
//  Created by Anthony Bath on 6/28/23.
//

import Foundation

struct Card: Codable, Identifiable, Equatable {
    let id: UUID
    let prompt: String
    let answer: String
    
    init(prompt: String, answer: String) {
        self.id = UUID()
        self.prompt = prompt
        self.answer = answer
    }
    
    static let example = Card(prompt: "Who played the 13th Doctor in Doctor Who?", answer: "Jodie Whittaker")
}
