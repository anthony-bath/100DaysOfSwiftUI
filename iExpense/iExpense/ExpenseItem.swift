//
//  ExpenseItem.swift
//  iExpense
//
//  Created by Anthony Bath on 5/1/23.
//

import Foundation

struct ExpenseItem: Identifiable, Codable {
    var id = UUID()
    let name: String
    let type: String
    let amount: Double
}
