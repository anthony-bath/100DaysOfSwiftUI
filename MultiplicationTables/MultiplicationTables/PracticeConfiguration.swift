//
//  PracticeConfiguration.swift
//  MultiplicationTables
//
//  Created by Anthony Bath on 4/27/23.
//

import Foundation
import SwiftUI

struct Question: Hashable {
    var left: Int
    var right: Int
    
    var answer: Int {
        return left * right
    }
    
    var text: String {
        "\(left) x \(right) ="
    }
}

struct PracticeConfiguration: Hashable {
    var table: Int
    var questions: [Question]
    
    static var sample = PracticeConfiguration(
        table: 12,
        questions: [
            Question(left: 12, right: 10),
            Question(left: 12, right: 6),
            Question(left: 12, right: 7),
            Question(left: 12, right: 8),
            Question(left: 12, right: 9)
        ]
    )
}
